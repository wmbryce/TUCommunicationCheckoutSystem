//
//  UgiViewController.h
//  GrokkerTest
//
//  Created by Tony Requist on 11/11/13.
//  Copyright (c) 2013 U Grok It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ugi.h"
#import "UgiUiUtil.h"
#import "UgiTitleView.h"

/**
 UgiViewController adds some convenient functionality to UIViewController
 */
@interface UgiViewController : UIViewController

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties
///////////////////////////////////////////////////////////////////////////////////////

//! Hide the back button
@property (nonatomic) BOOL hidesBackButton;

//! Hide the title bar
@property (nonatomic) BOOL hidesTitleBar;

//! Display disconnected dialog if Grokker is not connected, if inventory is running
@property (nonatomic) BOOL displayDialogIfDisconnected;

//! Display disconnected dialog if Grokker is not connected, regardless of whether inventory is running
@property (nonatomic) BOOL displayDialogIfDisconnectedEvenIfNotRunningInventory;

//! Allow screen to rotate if this is a tablet
@property (nonatomic) BOOL allowRotationIfTablet;

//! Title view
@property (retain, nonatomic, readonly, nullable) UgiTitleView *titleView;

//////

//! Color for the view controller, defaults to UgiUiUtil.themeColor
@property (retain, nonatomic, nullable) UIColor *themeColor;
//! Color for the view controller, defaults to UgiUiUtil.textColorOnThemeColor
@property (retain, nonatomic, nullable) UIColor *textColorOnThemeColor;
//! Color for the view controller, defaults to UgiUiUtil.buttonColor
@property (retain, nonatomic, nullable) UIColor *buttonColor;
//! Color for the view controller, defaults to UgiUiUtil.buttonPressedColor
@property (retain, nonatomic, nullable) UIColor *buttonPressedColor;
//! Color for the view controller, defaults to UgiUiUtil.textColorOnBackground
@property (retain, nonatomic, nullable) UIColor *textColorOnBackground;

///////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Methods
///////////////////////////////////////////////////////////////////////////////////////

//! @cond
+ (void) pushForcedCurrentUgiViewController:(UgiViewController *)viewController;
+ (void) popForcedCurrentUgiViewController;
+ (UgiViewController *) currentViewController;
- (UIView *) getViewControllerToShowUiOn;
- (void) showViewController:(UIViewController *)viewController;
- (void) hideViewController:(UIViewController *)viewController;
//! @endcond

/**
 Notification that the Grokker connection state changed
 */
- (void) connectionStateChanged;

/**
 Notification that the Grokker inventory state changed
 */
- (void) inventoryStateChanged;

/**
 Notification that the user has pressed "cancel" in the disconnected dialog.
 The default action is to pop this view controller
 */
- (void) disconnectedDialogCancelled;

/**
 Notification that the back buton was pressed.
 The default action is to pop this view controller
 */
- (void) backButtonPressed;

/**
 Go back a screen
 */
- (void) goBack;

/**
 Go back a screen
 @param completion  Code to run after animation is complete
 */
- (void) goBackWithCompletion:(nullable VoidBlock)completion;

/**
 Notification that the app has become active
 */
- (void) appDidBecomeActive;

/**
 Notification that the app has become not active
 */
- (void) appWillResignActive;

/**
 Called when the title view is tapped
 */
- (void) titleViewTapped;

/**
 Called when the title view is long pressed
 */
- (void) titleViewLongPressed;

/**
 Prototype for completion method for performSegueWithIdentifier:withConfigCallback

 @param vc     view controller
 */
typedef void (^PerformSegueWithIdentifierCompletion)(UIViewController * _Nonnull vc);

/**
 Perform a segue with code to initialize the new view controller
 @param identifier        Segue to invoke
 @param configCompletion  Code to run after animation is complete
 */
- (void)performSegueWithIdentifier:(NSString * _Nonnull)identifier
                withConfigCallback:(nonnull PerformSegueWithIdentifierCompletion)configCompletion;

@end
