//
//  CustomAlert.m
//  MET
//
//  Created by Kennedy, Colin on 5/9/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import "CustomAlert.h"
#import "METUICustomButton.h"

#define MAX_ALERT_HEIGHT 300.0

@implementation CustomAlert

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight)
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    else
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    self = [super initWithFrame:frame];
    

    return self;
}


#pragma mark - Setter Methods

// CLOSE API MATCH TO UIALERT
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)AlertDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle {
    
    CGRect frame;

    self = [self initWithFrame:frame];
    
    if (self) {
        self.delegate = AlertDelegate;
        self.alpha = 0.95;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        // BACKGROUND FROM PLIST
        NSString *alertBackgroundImage = @"prompt-box.png";
        
        // SET INITIAL ALERT HEIGHT FROM PLIST
        float alert_height = 56.0;
        // SET ALERT WIDTH FROM PLIST
        float alert_width =  260.0;
        // SET TEXT WIDTH FROM PLIST
        float text_width =   230.0;
        // SET TEXT OFFSET
        float text_offest = (alert_width - text_width) / 2;
       
        // SET TEXT TO BUTTON OFFSET FROM PLIST
        float text_to_button_offest = 42;

        // SET BUTTON OFFSET FROM PLIST
        float button_offest = 28;
        
        //ADD TITLE TEXT
        UILabel *titleLabel;

        if (title) {
            // ONLY SET THE WIDTH
            // THE REST IS RESET AFTER THE TEXT AND FONT ARE SET
            CGRect frame = CGRectMake(0, 0, text_width, 0);
            titleLabel = [self customLabel:@"title" withFrame:frame withAligment:nil withText:NSLocalizedString(title, title)];
            titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];

            // TITLE OFFSET FROM PLIST
            titleLabel.frame = CGRectMake(text_offest, alert_height, text_width, titleLabel.frame.size.height*2);
            
            // RESET ALERT HEIGHT TO INCLUDE SPACE BETWEEN TITLE AND MESSAGE TEXT
            if (message) {
                alert_height += titleLabel.frame.size.height + button_offest;
            } else {
                alert_height += titleLabel.frame.size.height + text_to_button_offest;
            }
        }
        
        UILabel *messageLabel;

        if (message) {
            // ONLY SET THE WIDTH
            // THE REST IS RESET AFTER THE TEXT AND FONT ARE SET
            CGRect frame = CGRectMake(0, 0, text_width, 0.0);
            messageLabel = [self customLabel:@"message" withFrame:frame withAligment:nil withText:NSLocalizedString(message, message)];

            // TITLE OFFSET FROM PLIST
            messageLabel.frame = CGRectMake(text_offest, alert_height, text_width, messageLabel.frame.size.height);
            
            // RESET ALERT HEIGHT TO INCLUDE SPACE FROM MESSAGE TO THE FIRST BUTTON
            alert_height += messageLabel.frame.size.height + text_to_button_offest;
        }
        
        // ALERT ONLY SHOWS BUTTONS
        // RESET THE STARTING HEIGHT
        // TO THE BUTTON_OFFSET ONLY
        if (!messageLabel && !titleLabel){
            alert_height = button_offest;
        }
        
        CGRect OtherBtnFrame = CGRectMake(text_offest, alert_height, text_width, 60);
        UIButton *otherBtn = [METUICustomButton makeButton:NSLocalizedString(otherButtonTitle, otherButtonTitle) withFrame:OtherBtnFrame withColor:nil withImageStr:nil withImage:nil withBackground:@"prompt-button-green.png" showTouch:FALSE touchImage:nil textAlign:@"Center" textOffset:0];
        [otherBtn setTag:1001];
        [otherBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [otherBtn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
      
        
        // RESET ALERT HEIGHT
        alert_height += otherBtn.frame.size.height + button_offest;

        
        // CANCEL BUTTON
        CGRect btnFrame = CGRectMake(text_offest, alert_height, text_width, 60);
        UIButton *cancelBtn = [METUICustomButton makeButton:NSLocalizedString(cancelButtonTitle, cancelButtonTitle) withFrame:btnFrame withColor:nil withImageStr:nil withImage:nil withBackground:@"prompt-button-grey.png" showTouch:FALSE touchImage:nil textAlign:@"Center" textOffset:0];
        [cancelBtn setTag:1000];
        [cancelBtn addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [cancelBtn addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];

        // RESET ALERT HEIGHT
        alert_height += cancelBtn.frame.size.height + button_offest;

        
        //add background
        
        messageView = [[UIView alloc] initWithFrame:CGRectMake(
                                                               (int)((self.frame.size.width-alert_width)/2.0), // SET ORIGIN X
                                                               (int)((self.frame.size.height-alert_height)/2.0), // SET ORIGIN Y
                                                               alert_width,
                                                               alert_height)
                       ];
        messageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        

        
        if (alertBackgroundImage) {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,messageView.frame.size.width, messageView.frame.size.height)];
            // EDGEINSETS ARE HARDCODED
            imageview.image = [[UIImage imageNamed:alertBackgroundImage] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0) resizingMode:UIImageResizingModeStretch];
            [messageView addSubview:imageview];
        }
        

        [self addSubview:messageView];
        
        if (titleLabel)
            [messageView addSubview:titleLabel];
        if (messageLabel)
            [messageView addSubview:messageLabel];
        
        if (otherBtn)
            [messageView addSubview:otherBtn];
        
        if (cancelBtn)
            [messageView addSubview:cancelBtn];
        
        
    }
    return self;
}

// PLIST ALERT VERSION
- (id)initWithData:(NSDictionary *)dictionary delegate:(id)AlertDelegate {

    CGRect frame;
    
    self = [self initWithFrame:frame];


    if (self) {
        self.delegate = AlertDelegate;
        //self.alpha = 0.95;
        float alertAlpha = 1;
        
        // RESET ALERT ALPHA IF EXISTS IN PLIST
        // SET FULL SCREEN BACKGROUND COLOR
        if ([dictionary objectForKey:@"Screen Background Alpha"]) {
            alertAlpha = [[dictionary objectForKey:@"Screen Background Alpha"] floatValue];
        }

        // SET FULL SCREEN BACKGROUND COLOR FROM PLIST
        if ([dictionary objectForKey:@"Screen Background Color"]) {
            self.backgroundColor = [METUICustomButton colorForString:[dictionary objectForKey:@"Screen Background Color"] withAlpha:alertAlpha];
        } else {
        
        }
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // GET ALERT BACKGROUND FROM PLIST
        NSString *alertBackgroundImage = [dictionary objectForKey:@"Alert Background Image"];
        
       // SET INITIAL ALERT HEIGHT FROM PLIST
        float alert_height = [[dictionary objectForKey:@"Alert Height"] floatValue];
        
        // SET ALERT WIDTH FROM PLIST
        float alert_width = [[dictionary objectForKey:@"Alert Width"] floatValue];
        
        // SET TEXT WIDTH FROM PLIST
        float text_width = [[dictionary objectForKey:@"Text Width"] floatValue];
        
        // SET TEXT TO BUTTON OFFSET FROM PLIST
        // SPACE FROM TEXT TO BUTTONS
        float text_to_button_offest = [[dictionary objectForKey:@"Text To Button Offest"] floatValue];
        
        // SET BUTTON OFFSET FROM PLIST
        // SPACE BETWEEN BUTTONS
        float button_offest = [[dictionary objectForKey:@"Button Offest"] floatValue];

        // SET TEXT OFFSET
        float text_offest = (alert_width - text_width) / 2;
        
        // GET TITLE AND MESSAGE TEXT
        NSString *title = [dictionary objectForKey:@"Title"];
        NSString *message = [dictionary objectForKey:@"Message"];
        
        //PREPARE TO ADD TITLE TEXT LABEL
        UILabel *titleLabel;
        
        // IF TITLE TEXT EXISTS
        if (title) {
            
            // ONLY SET THE WIDTH
            // THE REST OF THE FRAME IS RESET AFTER THE TEXT AND FONT ARE SET
            CGRect frame = CGRectMake(0, 0, text_width, 0);
            titleLabel = [self customLabel:@"title" withFrame:frame withAligment:nil withText:NSLocalizedString(title, title)];
            titleLabel.font = [self setFont:[dictionary objectForKey:@"Title Font Name"] withSize:[[dictionary objectForKey:@"Title Font Size"] floatValue]];

            // TITLE OFFSET FROM PLIST
            titleLabel.frame = CGRectMake(text_offest, alert_height, text_width, titleLabel.frame.size.height*2);
            
            // RESET ALERT HEIGHT TO INCLUDE SPACE BETWEEN TITLE AND MESSAGE TEXT
            if (message) {
                alert_height += titleLabel.frame.size.height + button_offest;
            } else {
                alert_height += titleLabel.frame.size.height + text_to_button_offest;
            }
        }

        //PREPARE TO ADD MESSAGE TEXT LABEL
        UILabel *messageLabel;
        
        if (message) {
            // ONLY SET THE WIDTH
            // THE REST IS RESET AFTER THE TEXT AND FONT ARE SET
            CGRect frame = CGRectMake(0, 0, text_width, 0.0);
            messageLabel = [self customLabel:@"message" withFrame:frame withAligment:nil withText:NSLocalizedString(message, message)];
            titleLabel.font = [self setFont:[dictionary objectForKey:@"Message Font Name"] withSize:[[dictionary objectForKey:@"Message Font Size"] floatValue]];
            
            // TITLE OFFSET FROM PLIST
            messageLabel.frame = CGRectMake(text_offest, alert_height, text_width, messageLabel.frame.size.height);
            
            // RESET ALERT HEIGHT TO INCLUDE SPACE FROM MESSAGE TO THE FIRST BUTTON
            alert_height += messageLabel.frame.size.height + text_to_button_offest;
        }
        
        // ALERT ONLY SHOWS BUTTONS
        // RESET THE STARTING HEIGHT
        // TO THE BUTTON_OFFSET ONLY
        if (!messageLabel && !titleLabel){
            alert_height = button_offest;
        }
        
        NSDictionary *buttonsDictionary = [dictionary objectForKey:@"Buttons"];

        // SORTING SHOULD BE REWORKED TO USE BUTTON TAG #
        // CURRENT IMPLEMENTATION USES SPACES IN FRONT OF BUTTON NAMES TO SORT BUTTONS
        NSArray *keys = [buttonsDictionary allKeys];
        keys = [keys sortedArrayUsingSelector: @selector (compare:)];
        NSMutableArray *buttonArray = [NSMutableArray array];
 
        int sizeRef = 60;
        
        for (id key in keys) {
            
            CGRect btnFrame = CGRectMake(text_offest, alert_height, text_width, sizeRef);

            UIButton *button = [METUICustomButton makeButton:[[buttonsDictionary objectForKey:key] valueForKey:@"Name"]
                                                   withFrame:btnFrame
                                                   withColor:[[buttonsDictionary objectForKey:key] valueForKey:@"Color"]
                                                withImageStr:[[buttonsDictionary objectForKey:key] valueForKey:@"Icon Image"]
                                                   withImage:nil
                                              withBackground:[[buttonsDictionary objectForKey:key] valueForKey:@"Background Image"]
                                                   showTouch:NO
                                                  touchImage:[[buttonsDictionary objectForKey:key] valueForKey:@"Highlight Image"]
                                                   textAlign:[[buttonsDictionary objectForKey:key] valueForKey:@"Text Alignment"]
                                                  textOffset:[[[buttonsDictionary objectForKey:key] valueForKey:@"Text Offset"] floatValue]

                                ];
            
            [button setTag:[[[buttonsDictionary objectForKey:key] valueForKey:@"Button Tag"] floatValue]];
            [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
           
            if ([[buttonsDictionary objectForKey:key] valueForKey:@"Font Color"]) {
                [button setTitleColor:
                 [METUICustomButton colorForHex:
                  [[buttonsDictionary objectForKey:key] valueForKey:@"Font Color"] withAlpha:0.8f]
                             forState:UIControlStateNormal];
            }
            
            // RESET ALERT HEIGHT
            // USED HERE TO VERTICALLY PLACE BUTTONS
            alert_height += button.frame.size.height + button_offest;
            
            // ADD BUTTON USING TAG AS INDEX TO CREATE BUTTON ORDER
            [buttonArray addObject:button];
        }

      
            
        //ADD ALERT MAIN VIEW
        messageView = [[UIView alloc] initWithFrame:CGRectMake(
                                                               (int)((self.frame.size.width-alert_width)/2.0), // SET ORIGIN X
                                                               (int)((self.frame.size.height-alert_height)/2.0), // SET ORIGIN Y
                                                               alert_width,
                                                               alert_height)
                       ];
        
        // IF ALERT BACKGROUND ALPHA RESET ALERT ALPHA
        if ([dictionary objectForKey:@"Alert Background Alpha"]) {
            alertAlpha = [[dictionary objectForKey:@"Alert Background Alpha"] floatValue];
        }
        
        // IF ALERT BACKGROUND COLOR SET BACKGROUND COLOR
        if ([dictionary objectForKey:@"Alert Background Color"]) {
            messageView.backgroundColor =  [METUICustomButton colorForString:[dictionary objectForKey:@"Alert Background Color"] withAlpha:alertAlpha];
        }
        

        // IF ALERT BACKGROUND IMAGE EXISTS
        // CREATE IMAGEVIEW AND SET TO BACKGROUND IMAGE
        // OVERRIDES BACKGROUND COLOR
        // NOTE: SETTING BACKGROUND COLOR TO IMAGE
        // DOES NOT RESPOND TO resizableImageWithCapInsets
       if (alertBackgroundImage) {
           UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,messageView.frame.size.width, messageView.frame.size.height)];
           // EDGEINSETS ARE HARDCODED
           imageview.image = [[UIImage imageNamed:alertBackgroundImage] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0) resizingMode:UIImageResizingModeStretch];
           [messageView addSubview:imageview];
        }
        
        // ADD ALERT VIEW
        [self addSubview:messageView];
       
        // ADD TITLE IF EXISTS
        if (titleLabel)
            [messageView addSubview:titleLabel];

        // ADD MESSAGE IF EXISTS
        if (messageLabel)
            [messageView addSubview:messageLabel];
        
        // ADD BUTTONS TO VIEW
        for (id button in buttonArray) {

            [messageView addSubview:button];
        }        
    }
   // self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return self;
}

- (UILabel *)customLabel:(NSString *)name withText:text withWidth:(int)textWidth {
    
    // ONLY SET THE WIDTH
    // THE REST IS RESET AFTER THE TEXT AND FONT ARE SET
    CGRect frame = CGRectMake(0, 0, textWidth, 0);
    UILabel *label = label = [self customLabel:name withFrame:frame withAligment:nil withText:text];
    
    return label;
}

- (UILabel *)customLabel:(NSString *)name withFrame:(CGRect)frame withAligment:(NSString *)align withText:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    // TEXT APPEARENCE HARDCODED
    if ([name isEqualToString:@"title"]) {
        label.font = [UIFont boldSystemFontOfSize:18.0f];
    } else {
        label.font = [UIFont boldSystemFontOfSize:16.0f];
        
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    
    // SET BACKGROUND TO CLEAR
    label.backgroundColor = [UIColor clearColor];
    
    // SET TEXT
    label.text = text;
    [label sizeToFit];
    return label;
}

- (void)showInView:(UIView*)view {
    if ([view isKindOfClass:[UIView class]])
    {
        [view addSubview:self];
    }
}


// SET FONT
-(UIFont *)setFont:(NSString *)fontName withSize:(float)size {
    float fontSize = 18.0;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];

    if (fontName && size) {
        font = [UIFont fontWithName:fontName size:size];
        
    } else if (fontName) {
        font = [UIFont fontWithName:fontName size:fontSize];
    }
    return font;
}
#pragma mark - Button Actions

-(IBAction)buttonTouchDown:(id)sender{
    [sender setSelected:YES];
}

-(IBAction)buttonTouchUp:(id)sender{
    [sender setSelected:NO];
    UIButton *button = (UIButton *)sender;
    if ([delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)])
        [delegate customAlertView:self clickedButtonAtIndex:button.tag];
}

// GENERAL HELPER METHOD
// OUTPUTS DICTIONARY KEYS AND VALUES
- (void)dictionaryOutput:(NSDictionary *)dictionary {
    for (id key in dictionary) {
        NSLog(@"%@ = %@", key, [dictionary objectForKey:key] );
    }
}
@end
