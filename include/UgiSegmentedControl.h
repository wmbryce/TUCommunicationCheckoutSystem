//
//  UgiSegmentedControl.h
//  UGrokItApi
//
//  Created by Tony Requist on 3/9/16.
//  Copyright (c) 2013 U Grok It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UgiUiUtil.h"

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UgiSegmentedControl
///////////////////////////////////////////////////////////////////////////////////////

/**
 UgiSegmentedControl is a UISegmentedControl that uses the theme colors
 */
@interface UgiSegmentedControl : UISegmentedControl<UgiThemeColored>

//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *themeColorOverride;
//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *textColorOnThemeColorOverride;
//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *textColorOnBackgroundOverride;


@end
