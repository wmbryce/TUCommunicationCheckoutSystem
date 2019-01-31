//
//  UgiButton.h
//  UGrokItApi
//
//  Created by Tony Requist on 3/9/16.
//  Copyright (c) 2013 U Grok It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UgiUiUtil.h"

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UgiButton
///////////////////////////////////////////////////////////////////////////////////////

/**
 UgiButton is a UIButton that uses the theme colors
 */
@interface UgiButton : UIButton<UgiThemeColored>

//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *buttonColorOverride;
//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *buttonPressedColorOverride;

@end
