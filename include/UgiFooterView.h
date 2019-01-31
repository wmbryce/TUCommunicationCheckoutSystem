//
//  UgiFooterView.h
//  UGrokIt
//
//  Created by Tony Requist on 9/30/13.
//  Copyright (c) 2013 U Grok It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UgiUiUtil.h"

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UgiFooterView
///////////////////////////////////////////////////////////////////////////////////////

/**
 * UI object designed for the bottom of the screen, with three buttons
 */
@interface UgiFooterView : UIView<UgiThemeColored>

//! YES to force the footer to be hidden
@property (nonatomic) BOOL forceHidden;

//! Override to color in UgiViewController (default = nil)
@property (nonatomic, retain, nullable) UIColor *themeColorOverride;
//! Override to color in UgiViewController (default = nil)
@property (nonatomic, retain, nullable) UIColor *buttonColorOverride;
//! Override to color in UgiViewController (default = nil)
@property (retain, nonatomic, nullable) UIColor *buttonPressedColorOverride;

/**
 Set the left button title and handler
 * @param text          Button title
 * @param completion    Click handler
 */
- (void) setLeftText:(NSString * _Nullable)text
      withCompletion:(nullable VoidBlock)completion;

/**
 Set the center button title and handler
 * @param text          Button title
 * @param completion    Click handler
 */
- (void) setCenterText:(NSString * _Nullable)text
        withCompletion:(nullable VoidBlock)completion;

/**
 Set the center button title, image and handler
 * @param text          Button title
 * @param image         Button image
 * @param completion    Click handler
 */
- (void) setCenterText:(NSString * _Nullable)text
                 image:(UIImage * _Nullable)image
        withCompletion:(nullable VoidBlock)completion;

/**
 Set the right button title and handler
 * @param text          Button title
 * @param completion    Click handler
 */
- (void) setRightText:(NSString * _Nullable)text
       withCompletion:(nullable VoidBlock)completion;

/**
 See if any of the buttons are displayed
 * @return    YES if any buttons are displayed
 */
- (BOOL) anyButtonsDisplayed;

//! Button size, default is 1.0
@property (nonatomic) float buttonSize;

@end
