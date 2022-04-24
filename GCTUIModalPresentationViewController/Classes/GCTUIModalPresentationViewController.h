//
//  GCTInputViewController.h
//  GCTUIKitDemo
//
//  Created by Later on 2017/3/18.
//  Copyright © 2017年 Later. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, GCTUIModalPresentAnimation) {
    GCTUIModalPresentAnimationNone = 0,
    GCTUIModalPresentAnimationFadeIn,
    GCTUIModalPresentAnimationGrowIn,
    GCTUIModalPresentAnimationShrinkIn,
    GCTUIModalPresentAnimationSlideInFromTop,
    GCTUIModalPresentAnimationSlideInFromBottom,
    GCTUIModalPresentAnimationSlideInFromLeft,
    GCTUIModalPresentAnimationSlideInFromRight,
    GCTUIModalPresentAnimationBounceIn,
    GCTUIModalPresentAnimationBounceInFromTop,
    GCTUIModalPresentAnimationBounceInFromBottom,
    GCTUIModalPresentAnimationBounceInFromLeft,
    GCTUIModalPresentAnimationBounceInFromRight
};

typedef NS_ENUM(NSInteger, GCTUIModalDismissAnimation) {
    GCTUIModalDismissAnimationNone = 0,
    GCTUIModalDismissAnimationFadeOut,
    GCTUIModalDismissAnimationGrowOut,
    GCTUIModalDismissAnimationShrinkOut,
    GCTUIModalDismissAnimationSlideOutFromTop,
    GCTUIModalDismissAnimationSlideOutFromBottom,
    GCTUIModalDismissAnimationSlideOutFromLeft,
    GCTUIModalDismissAnimationSlideOutFromRight,
    GCTUIModalDismissAnimationBounceOut,
    GCTUIModalDismissAnimationBounceOutFromTop,
    GCTUIModalDismissAnimationBounceOutFromBottom,
    GCTUIModalDismissAnimationBounceOutFromLeft,
    GCTUIModalDismissAnimationBounceOutFromRight
};

typedef NS_ENUM(NSInteger, GCTUIModalPresentBackViewType) {
    GCTUIModalPresentBackViewTypeClear = 0,
    GCTUIModalPresentBackViewTypeDark,
    GCTUIModalPresentBackViewTypeWhite,
    GCTUIModalPresentBackViewTypeBlurDark,
    GCTUIModalPresentBackViewTypeBlurWhite
};

@protocol GCTUIModalPresentationControllerDelegate;

@interface GCTUIModalPresentationViewController : UIViewController

/**
 模态控制器代理
 */
@property (nonatomic, weak) id<GCTUIModalPresentationControllerDelegate> delegate;

/**
 点击空白消失：
 
 @default YES
 */
@property (nonatomic, assign, getter=isTouchDismissEnable) BOOL touchDismissEnable;

/**
 背景视图样式：
 
 @default GCTUIModalPresentBackViewTypeClear
 */
@property (nonatomic, assign) GCTUIModalPresentBackViewType backViewType;

/**
 显示动画类型
 */
@property (nonatomic, assign) GCTUIModalPresentAnimation presentAnimation;

/**
 dismiss 动画类型
 */
@property (nonatomic, assign) GCTUIModalDismissAnimation dismissAnimation;

/**
 被观察视图
 一般性view，紧限于将试图模态出来，同步渐变透明度的背景视图；
 如果是textView\TextField，视图跟随键盘同步出现，并同步渐变透明度的背景视图
 
 @default self.view
 */
@property (nonatomic, strong) UIView *observerView;

@end

@protocol GCTUIModalPresentationControllerDelegate <NSObject>
@optional

/**
 键盘将要弹出
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘弹出具体信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardWillShowWithKeyboardInfo:(NSDictionary *)keyboardInfo;

/**
 键盘弹出动画执行，用于自定义弹出动画
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardShowActionWithKeyboardInfo:(NSDictionary *)keyboardInfo;

/**
 键盘弹出动画执行结束
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardDidShowWithKeyboardInfo:(NSDictionary *)keyboardInfo;

/**
 键盘将要消失
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘具体信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardWillHideWithKeyboardInfo:(NSDictionary *)keyboardInfo;

/**
 键盘消失动画执行，用于自定义动画
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardHideActionWithKeyboardInfo:(NSDictionary *)keyboardInfo;

/**
 键盘消失动画执行结束
 
 @param viewController 模态出来的控制器
 @param keyboardInfo 键盘具体信息
 */
- (void)modalPresentationViewController:(GCTUIModalPresentationViewController *)viewController keyboardDidHideWithKeyboardInfo:(NSDictionary *)keyboardInfo;

@end

