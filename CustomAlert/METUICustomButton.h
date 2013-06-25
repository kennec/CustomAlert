//
//  UICustomButton.h
//  MET
//
//  Created by Kennedy, Colin on 5/9/13.
//  Copyright (c) 2013 Colin Kennedy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface METUICustomButton : UIButton

+(UIButton *)makeButton:(NSString *)buttonName
              withFrame:(CGRect)frameSize
              withColor:(NSString *)colorName
           withImageStr:(NSString *)imageName
              withImage:(UIImage *)image
         withBackground:(NSString *)bgImage
              showTouch:(BOOL)showTouch
             touchImage:(NSString *)touchImage
              textAlign:(NSString *)textAlign
             textOffset:(float)textOffset;

+(UIColor *)colorForString:(NSString *)namedColor withAlpha:(float )alphaValue;
+(UIColor *)colorForHex:(NSString *)hexColor;
+(UIColor *)colorForHex:(NSString *)hexColor withAlpha:(float )alphaValue;
@end

