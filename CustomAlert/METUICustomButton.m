//
//  UICustomButton.m
//  MET
//
//  Created by Kennedy, Colin on 5/9/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import "METUICustomButton.h"

@implementation METUICustomButton

+(UIButton *)makeButton:(NSString *)buttonName withFrame:(CGRect)frameSize withColor:(NSString *)colorName withImageStr:(NSString *)imageName withImage:(UIImage *)image withBackground:(NSString *)bgImage showTouch:(BOOL)showsTouch touchImage:(NSString *)touchImage textAlign:(NSString *)textAlign textOffset:(float)textOffset {
    NSLog(@"%@", textAlign);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // BUTTON TITLE
    if ([buttonName length] > 0) {
        [button setTitle:NSLocalizedString(buttonName, buttonName) forState:UIControlStateNormal];
    }
    
    // WITH FRAME
        button.frame = (frameSize);
    
    // WITH COLOR
    if ([colorName length]>0) {
        [button setBackgroundColor:[self colorForString:colorName  withAlpha:1]];
   }
    
    // WITH IMAGE
    // SHOULD ERROR CHECK FOR FILE WITH IMAGE NAME IN APP
    if (image || imageName) {
        if ([imageName length]>0) {
            [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            // REMOVE HARDCODED
        } else if (image) {
            [button setImage:image forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0);
        }
        
        // REMOVE HARDCODED
        if ([@"center" caseInsensitiveCompare:textAlign] == NSOrderedSame ) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        } else if ([@"right" caseInsensitiveCompare:textAlign] == NSOrderedSame ) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        } else {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        
        // ADJUST TITLE PLACEMENT
        // REMOVE HARDCODED
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, button.imageView.image.size.width -10.0, 0, 0)];
    
    } else {
        if ([@"center" caseInsensitiveCompare:textAlign] == NSOrderedSame ) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        } else if ([@"right" caseInsensitiveCompare:textAlign] == NSOrderedSame ) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        } else {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        
        // CHANGED FOR ALERT!
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, textOffset, 0, 0)];
    }

    if (bgImage) {

        [button setBackgroundImage:
                        [[UIImage imageNamed:bgImage] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 8.0, 2.0, 8.0) resizingMode:UIImageResizingModeStretch]
                          forState:UIControlStateNormal];
    }
    
    if (showsTouch == NO) {
       [button setShowsTouchWhenHighlighted:showsTouch];
    } else if (showsTouch == YES) {
        [button setShowsTouchWhenHighlighted:showsTouch];
    }
    
    if (touchImage) {
        [button setBackgroundImage:
                [[UIImage imageNamed:touchImage] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 8.0, 2.0, 8.0) resizingMode:UIImageResizingModeStretch]
                    forState:UIControlStateSelected | UIControlStateHighlighted];
    }
    image = nil;
    return button;
}

// CONVERT STRING NAME TO UICOLOR
+ (UIColor *) colorForString:(NSString *)namedColor withAlpha:(float)alpha {

    if ([namedColor rangeOfString:@"color"].location == NSNotFound) {
        namedColor = [NSString stringWithFormat:@"%@Color", namedColor];
    }
    SEL selColor = NSSelectorFromString(namedColor);
    UIColor *color = nil;
    if ( [UIColor respondsToSelector:selColor] == YES) {
        if (alpha) {
            color = [[UIColor performSelector:selColor] colorWithAlphaComponent:alpha];
        } else {
            color = [UIColor performSelector:selColor];
        }
    } else {
        if (alpha) {
            color = [self colorForHex:namedColor withAlpha:alpha];
        } else {
            color = [self colorForHex:namedColor];
        }
    }
    return color;
}

// CONVERT HEX VALUE TO UICOLOR
+(UIColor *)colorForHex:(NSString *)hexColor {
	//NSLog(@"COLORFORHEX");
	return [self colorForHex:hexColor withAlpha:1.0f];
}

// CONVERT HEX VALUE TO UICOLOR WITH ALPHA
+(UIColor *)colorForHex:(NSString *)hexColor withAlpha:(float )alphaValue {
	//NSLog(@"colorForHex %@", hexColor);
	hexColor = [[hexColor stringByTrimmingCharactersInSet:
				 [NSCharacterSet whitespaceAndNewlineCharacterSet]
				 ] uppercaseString];
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length] < 6)
		return [UIColor blackColor];
	
    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
		hexColor = [hexColor substringFromIndex:1];
	
    // if the value isn't 6 characters at this point return black
    if ([hexColor length] != 6)
		return [UIColor blackColor];
	
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
	
    NSString *rString = [hexColor substringWithRange:range];
	
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
	
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
	
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
	//NSLog(@"%u, %u, %u", r, g, b);
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alphaValue];
}

@end
