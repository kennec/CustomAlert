//
//  CustomAlert.h
//  MET
//
//  Created by Kennedy, Colin on 5/9/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomAlert : UIView
{
    id delegate;
    UIView *messageView;
}
@property id delegate;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)AlertDelegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle;
- (id)initWithData:(NSDictionary *)dictionary delegate:(id)AlertDelegate;
- (void)showInView:(UIView*)view;
@end


@protocol CustomAlertDelegate
- (void)customAlertView:(CustomAlert*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
