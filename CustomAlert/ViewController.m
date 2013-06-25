//
//  ViewController.m
//  MET
//
//  Created by Kennedy, Colin on 5/9/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
// CUSTOM ALERT IMPLEMENTATION
// REQUIRES
@property (nonatomic, strong) CustomAlert *alert;
@property (nonatomic, strong) NSDictionary *alertDictionary;
@property (nonatomic, strong) NSArray *keys;
// END CUSTOM ALERT IMPLEMENTATION 
@end


@implementation ViewController


// CUSTOM ALERT IMPLEMENTATION
// REQUIRES
@synthesize alert;
@synthesize keys;
@synthesize alertDictionary;
// END CUSTOM ALERT IMPLEMENTATION

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *alertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    alertButton.frame = CGRectMake((int)((self.view.frame.size.width-150.0)/2.0), 150.0, 150.0, 50.0);
    [alertButton setTitle:@"Display Alert" forState:UIControlStateNormal];
    [alertButton addTarget:self action:@selector(btnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:alertButton];
    alertButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    
    // CUSTOM ALERT IMPLEMENTATION
    // SET ALERT DATA VIA PLIST
    // FIX SORT TO USE BUTTON TAG INDEX
    // NOT ALPHABETICAL USING SPACES TO CREATE BUTTON ORDER
    self.alertDictionary = [METPlist loadData:[NSString stringWithFormat:@"alert_languages.plist"]];
    self.keys = [self.alertDictionary allKeys];
    self.keys = [self.keys sortedArrayUsingSelector: @selector (compare:)];
    // END CUSTOM ALERT IMPLEMENTATION
   
    
}

#pragma mark -
#pragma mark UIAlertViewDelegate Methods

// CUSTOM ALERT IMPLEMENTATION
- (void)customAlertView:(CustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"buttonIndex %d", buttonIndex);

    // CREATE CUSTOM ACTIONS HERE
    // BY RESPONDING TO BUTTON INDEX AS SET BY PLIST
    if (buttonIndex == 1001) {

        if (self.view.backgroundColor == [UIColor lightGrayColor]) {
            self.view.backgroundColor = [UIColor whiteColor];
        } else {
            self.view.backgroundColor = [UIColor lightGrayColor];
                                         
        }
        [alert removeFromSuperview];
    } else if (buttonIndex == 1000){
        [alert removeFromSuperview];
    }

}
// END CUSTOM ALERT IMPLEMENTATION

#pragma mark - Button Actions

// CUSTOM ALERT IMPLEMENTATION
// DISPLAY ALERT
- (void)btnPressed {
    alert = [[CustomAlert alloc] initWithData:self.alertDictionary delegate:self];
    //alert = [[CustomAlert alloc] initWithTitle:@"This object only has content in English." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"Play"];
    [alert showInView:self.view];
}
// END CUSTOM ALERT IMPLEMENTATION


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
