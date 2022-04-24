//
//  GCTInputViewController.m
//  GCTUIKitDemo
//
//  Created by Later on 2017/3/18.
//  Copyright © 2017年 Later. All rights reserved.
//

#import "GCTUIModalPresentationViewController.h"

static NSInteger const kAnimationOptionCurveIOS7 = (7 << 16);

@interface GCTUIModalPresentationControllerTransitionDelegate : NSObject<UIViewControllerTransitioningDelegate>

@end

@interface GCTUIModalPresentationViewController ()

@property (nonatomic, strong) GCTUIModalPresentationControllerTransitionDelegate *transitionDelegate;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> dismissTransitionContext;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning>presentTransitionContext;
@property (nonatomic, assign) BOOL isDismiss;

@end

@implementation GCTUIModalPresentationViewController

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.transitionDelegate;
        self.touchDismissEnable = YES;
        self.backViewType = GCTUIModalPresentBackViewTypeClear;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.observerView = self.view;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver];
}

- (void)dealloc {
    
}

#pragma mark Transition

- (void)showActionWitnTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.presentTransitionContext = transitionContext;
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fadView = [[UIView alloc] init];
    switch (self.backViewType) {
        case GCTUIModalPresentBackViewTypeDark:
            fadView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            break;
        case GCTUIModalPresentBackViewTypeWhite:
            fadView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            break;
        case GCTUIModalPresentBackViewTypeBlurDark:
            fadView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            break;
        case GCTUIModalPresentBackViewTypeBlurWhite:
            fadView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            break;
        case GCTUIModalPresentBackViewTypeClear:
        default:
            fadView.backgroundColor = [UIColor clearColor];
            break;
    }
    fadView.frame = fromVC.view.bounds;
    fadView.alpha = 0;
    self.backView = fadView;
    [containerView addSubview:fadView];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = fromVC.view.bounds;
    toVC.view.backgroundColor = [UIColor clearColor];
    [containerView addSubview: toVC.view];
    
    CGRect oldFrame = self.observerView.frame;
    if (CGRectGetWidth(oldFrame) == 0 || CGRectGetHeight(oldFrame) == 0) {
        [toVC.view setNeedsLayout];
        [toVC.view layoutIfNeeded];
        oldFrame = self.observerView.frame;
    }
    
    if ([self.observerView isKindOfClass:[UITextView class]] || [self.observerView isKindOfClass:[UITextField class]]) {
        [self.observerView becomeFirstResponder];
        [transitionContext completeTransition:YES];
    } else if(self.observerView) {
        [self presentAnimationWithOldFrame:oldFrame Completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else {
        [transitionContext completeTransition:YES];
    }
}

- (void)dismissActionWitnTransitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.dismissTransitionContext = transitionContext;
    if ([self.observerView isKindOfClass:[UITextField class]] || [self.observerView isKindOfClass:[UITextView class]]) {
        __weak typeof(self)weakSelf = self;
        self.isDismiss = YES;
        [self.observerView resignFirstResponder];
        
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.backView.alpha = 0;
            weakSelf.view.frame = CGRectMake(0, CGRectGetHeight(weakSelf.view.bounds), CGRectGetWidth(weakSelf.view.bounds), CGRectGetHeight(weakSelf.view.bounds));
        } completion:^(BOOL finished) {
            [weakSelf.backView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
        
    } else if(self.observerView) {
        [self dismissAnimationWithCompletion:^(BOOL finished) {
            [self.backView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }  else {
        [transitionContext completeTransition:YES];
    }
}

#pragma mark - Present

- (void)presentAnimationWithOldFrame:(CGRect)oldFrame Completion:(void (^ __nullable)(BOOL finished))completion {
    switch (self.presentAnimation) {
        case GCTUIModalPresentAnimationFadeIn:
            [self presentTypeFadeInWithCompletion:completion];
            break;
        case GCTUIModalPresentAnimationGrowIn:
            [self presentTypeGrowInWithCompletion:completion];
            break;
        case GCTUIModalPresentAnimationShrinkIn:
            [self presentTypeShrinkInWithCompletion:completion];
            break;
        case GCTUIModalPresentAnimationSlideInFromTop:
            [self presentTypeSlideInFromTopWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationSlideInFromBottom:
            [self presentTypeSlideInFromBottomWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationSlideInFromLeft:
            [self presentTypeSlideInFromLeftWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationSlideInFromRight:
            [self presentTypeSlideInFromRightWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationBounceIn:
            [self presentTypeBounceInWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationBounceInFromTop:
            [self presentTypeBounceInFromTopWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationBounceInFromBottom:
            [self presentTypeBounceInFromBottomWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationBounceInFromLeft:
            [self presentTypeBounceInFromLeftWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationBounceInFromRight:
            [self presentTypeBounceInFromRightWithOldFrame:oldFrame completion:completion];
            break;
        case GCTUIModalPresentAnimationNone:
        default: {
            self.backView.alpha = 1;
            !completion ?: completion(YES);
            break;
        }
    }
}

#pragma mark - Present Animation

// GCTUIModalPresentAnimationFadeIn
- (void)presentTypeFadeInWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 0;
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backView.alpha = 1;
        self.observerView.alpha = 1;
    }completion:completion];
}

// GCTUIModalPresentAnimationGrowIn
- (void)presentTypeGrowInWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 0.0;
    self.observerView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.15 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 1;
        self.observerView.alpha = 1.0;
        self.observerView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

// GCTUIModalPresentAnimationShrinkIn
- (void)presentTypeShrinkInWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 0.0;
    self.observerView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    
    [UIView animateWithDuration:0.15 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 1;
        self.observerView.alpha = 1.0;
        self.observerView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

// GCTUIModalPresentAnimationSlideInFromTop
- (void)presentTypeSlideInFromTopWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.y = -CGRectGetHeight(oldFrame);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.observerView.frame = oldFrame;
        self.backView.alpha = 1;
    } completion:completion];
}

// GCTUIModalPresentAnimationSlideInFromBottom
- (void)presentTypeSlideInFromBottomWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.y = CGRectGetHeight(self.view.bounds);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationSlideInFromLeft
- (void)presentTypeSlideInFromLeftWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.x = -CGRectGetWidth(oldFrame);
    self.observerView.frame = startFrame;
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationSlideInFromRight
- (void)presentTypeSlideInFromRightWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.x = CGRectGetWidth(self.view.bounds);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationBounceIn
- (void)presentTypeBounceInWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 0.0;
    CGRect startFrame = oldFrame;
    self.observerView.frame = startFrame;
    self.observerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:15.0 options:0 animations:^{
        self.backView.alpha = 1;
        self.observerView.alpha = 1.0;
        self.observerView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

// GCTUIModalPresentAnimationBounceInFromTop
- (void)presentTypeBounceInFromTopWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.y = -CGRectGetHeight(oldFrame);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationBounceInFromBottom
- (void)presentTypeBounceInFromBottomWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.y = CGRectGetHeight(self.view.bounds);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationBounceInFromLeft
- (void)presentTypeBounceInFromLeftWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.x = -CGRectGetWidth(oldFrame);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalPresentAnimationBounceInFromRight
- (void)presentTypeBounceInFromRightWithOldFrame:(CGRect)oldFrame completion:(void (^ __nullable)(BOOL finished))completion {
    self.observerView.alpha = 1.0;
    self.observerView.transform = CGAffineTransformIdentity;
    CGRect startFrame = oldFrame;
    startFrame.origin.x = CGRectGetWidth(self.view.bounds);
    self.observerView.frame = startFrame;
    
    [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:10.0 options:0 animations:^{
        self.backView.alpha = 1;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

#pragma mark - Dismiss

- (void)dismissAnimationWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    switch (self.dismissAnimation) {
        case GCTUIModalDismissAnimationFadeOut:
            [self dismissTypeFadeOutWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationGrowOut:
            [self dismissTypeGrowOutWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationShrinkOut:
            [self dismissTypeShrinkOutWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationSlideOutFromTop:
            [self dismissTypeSlideOutFromTopWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationSlideOutFromBottom:
            [self dismissTypeSlideOutFromBottomWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationSlideOutFromLeft:
            [self dismissTypeSlideOutFromLeftWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationSlideOutFromRight:
            [self dismissTypeSlideOutFromRightWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationBounceOut:
            [self dismissTypeBounceOutWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationBounceOutFromTop:
            [self dismissTypeBounceOutFromTopWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationBounceOutFromBottom:
            [self dismissTypeBounceOutFromBottomWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationBounceOutFromLeft:
            [self dismissTypeBounceOutFromLeftWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationBounceOutFromRight:
            [self dismissTypeBounceOutFromRightWithCompletion:completion];
            break;
        case GCTUIModalDismissAnimationNone:
        default:
            !completion ?: completion(YES);
            break;
    }
}

#pragma mark - Dismiss Animation
// GCTUIModalDismissAnimationFadeOut
- (void)dismissTypeFadeOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.backView.alpha = 0;
        self.observerView.alpha = 0.0;
    } completion:completion];
}

// GCTUIModalDismissAnimationGrowOut
- (void)dismissTypeGrowOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.15 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.alpha = 0.0;
        self.observerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:completion];
}

// GCTUIModalDismissAnimationShrinkOut
- (void)dismissTypeShrinkOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    [UIView animateWithDuration:0.15 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.alpha = 0.0;
        self.observerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:completion];
}

// GCTUIModalDismissAnimationSlideOutFromTop
- (void)dismissTypeSlideOutFromTopWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.y = -CGRectGetHeight(oldFrame);
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalDismissAnimationSlideOutFromBottom
- (void)dismissTypeSlideOutFromBottomWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.y = CGRectGetHeight(self.view.bounds);
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalDismissAnimationSlideOutFromLeft
- (void)dismissTypeSlideOutFromLeftWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.x = -CGRectGetWidth(oldFrame);
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalDismissAnimationSlideOutFromRight
- (void)dismissTypeSlideOutFromRightWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.x = CGRectGetWidth(self.view.bounds);
    
    [UIView animateWithDuration:0.30 delay:0 options:kAnimationOptionCurveIOS7 animations:^{
        self.backView.alpha = 0;
        self.observerView.frame = oldFrame;
    } completion:completion];
}

// GCTUIModalDismissAnimationBounceOut
- (void)dismissTypeBounceOutWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    NSTimeInterval bounce1Duration = 0.13;
    NSTimeInterval bounce2Duration = (bounce1Duration * 2.0);
    [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.observerView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            self.backView.alpha = 0;
            self.observerView.alpha = 0.0;
            self.observerView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        } completion:completion];
    }];
}

// GCTUIModalDismissAnimationBounceOutFromTop
- (void)dismissTypeBounceOutFromTopWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    NSTimeInterval bounce1Duration = 0.13;
    NSTimeInterval bounce2Duration = (bounce1Duration * 2.0);
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.y += 40.0;
    [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.observerView.frame = oldFrame;
    } completion:^(BOOL finished){
        CGRect oldFrame = self.observerView.frame;
        oldFrame.origin.y = -CGRectGetHeight(oldFrame);
        [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            self.backView.alpha = 0;
            self.observerView.frame = oldFrame;
        } completion:completion];
    }];
}

// GCTUIModalDismissAnimationBounceOutFromBottom
- (void)dismissTypeBounceOutFromBottomWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    NSTimeInterval bounce1Duration = 0.13;
    NSTimeInterval bounce2Duration = (bounce1Duration * 2.0);
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.y -= 40.0;
    [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.observerView.frame = oldFrame;
    } completion:^(BOOL finished){
        CGRect oldFrame = self.observerView.frame;
        oldFrame.origin.y = CGRectGetHeight(self.view.bounds);
        [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            self.backView.alpha = 0;
            self.observerView.frame = oldFrame;
        } completion:completion];
    }];
}

// GCTUIModalDismissAnimationBounceOutFromLeft
- (void)dismissTypeBounceOutFromLeftWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    NSTimeInterval bounce1Duration = 0.13;
    NSTimeInterval bounce2Duration = (bounce1Duration * 2.0);
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.x += 40.0;
    [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.observerView.frame = oldFrame;
    } completion:^(BOOL finished){
        CGRect oldFrame = self.observerView.frame;
        oldFrame.origin.x = -CGRectGetWidth(oldFrame);
        [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            self.backView.alpha = 0;
            self.observerView.frame = oldFrame;
        } completion:completion];
    }];
}

// GCTUIModalDismissAnimationBounceOutFromRight
- (void)dismissTypeBounceOutFromRightWithCompletion:(void (^ __nullable)(BOOL finished))completion {
    NSTimeInterval bounce1Duration = 0.13;
    NSTimeInterval bounce2Duration = (bounce1Duration * 2.0);
    CGRect oldFrame = self.observerView.frame;
    oldFrame.origin.x -= 40.0;
    [UIView animateWithDuration:bounce1Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        self.observerView.frame = oldFrame;
    } completion:^(BOOL finished){
        CGRect oldFrame = self.observerView.frame;
        oldFrame.origin.x = CGRectGetWidth(self.view.bounds);
        [UIView animateWithDuration:bounce2Duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
            self.backView.alpha = 0;
            self.observerView.frame = oldFrame;
        } completion:completion];
    }];
}
#pragma mark Observer

- (void)addObserver {
    [self removeObserver];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber * curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = [self.view convertRect:keyboardRect fromView:nil].size.height;
    
    /** 键盘将要显示 */
    if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardWillShowWithKeyboardInfo:)]) {
        [self.delegate modalPresentationViewController:self keyboardWillShowWithKeyboardInfo:notification.userInfo];
    }
    
    CGFloat maxY = CGRectGetMaxY(self.observerView.frame);
    CGFloat transformY = 0;
    if (CGRectGetHeight(self.view.bounds) - maxY < keyboardHeight) {
        transformY = maxY - keyboardHeight;
    }

    /** 键盘显示过程中 */
    [UIView animateWithDuration:[duration floatValue] delay:0 options:[curve unsignedIntegerValue] animations:^{
        /** 自定义键盘显示过程动画 */
        if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardShowActionWithKeyboardInfo:)]) {
            [self.delegate modalPresentationViewController:self keyboardShowActionWithKeyboardInfo:notification.userInfo];
        } else {
            /** 默认键盘显示过程动画 */
            self.view.transform = CGAffineTransformMakeTranslation(0, -transformY);
            self.backView.alpha = 1;
        }
    } completion:^(BOOL finished) {
        /** 键盘弹出结束 */
        if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardDidShowWithKeyboardInfo:)]) {
            [self.delegate modalPresentationViewController:self keyboardDidShowWithKeyboardInfo:notification.userInfo];
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSNumber * duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber * curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    /** 键盘将要消失 */
    if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardWillHideWithKeyboardInfo:)]) {
        [self.delegate modalPresentationViewController:self keyboardWillHideWithKeyboardInfo:notification.userInfo];
    }
    
    /** 键盘消失过程 */
    [UIView animateWithDuration:[duration floatValue] delay:0 options:[curve unsignedIntegerValue] animations:^{
        if(!self.isDismiss) {
            /** 自定义键盘消失 */
            if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardHideActionWithKeyboardInfo:)]) {
                [self.delegate modalPresentationViewController:self keyboardHideActionWithKeyboardInfo:notification.userInfo];
            } else {
                /** 默认键盘消失 */
                self.view.transform = CGAffineTransformIdentity;
            }
        }
    } completion:^(BOOL finished) {
        /** 键盘消失结束 */
        if ([self.delegate respondsToSelector:@selector(modalPresentationViewController:keyboardDidHideWithKeyboardInfo:)]) {
            [self.delegate modalPresentationViewController:self keyboardDidHideWithKeyboardInfo:notification.userInfo];
        }
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.isTouchDismissEnable) {
        if ([touches.anyObject.view isEqual:self.view]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (GCTUIModalPresentationControllerTransitionDelegate *)transitionDelegate {
    if (!_transitionDelegate) {
        _transitionDelegate = [[GCTUIModalPresentationControllerTransitionDelegate alloc] init];
    }
    return _transitionDelegate;
}


@end

#pragma mark GCTUIModelPresentationPresentViewControllerTransition

@interface GCTUIModelPresentationPresentViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>

@end

@implementation GCTUIModelPresentationPresentViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if ([toVC isKindOfClass:[GCTUIModalPresentationViewController class]]) {
        GCTUIModalPresentationViewController *inputVC = (GCTUIModalPresentationViewController *)toVC;
        [inputVC showActionWitnTransitionContext:transitionContext];
    }
}

@end

#pragma mark GCTUIModelPresentationDismissViewControllerTransition

@interface GCTUIModelPresentationDismissViewControllerTransition : NSObject<UIViewControllerAnimatedTransitioning>

@end

@implementation GCTUIModelPresentationDismissViewControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    if ([fromVC isKindOfClass:[GCTUIModalPresentationViewController class]]) {
        GCTUIModalPresentationViewController *inputVC = (GCTUIModalPresentationViewController *)fromVC;
        [inputVC dismissActionWitnTransitionContext:transitionContext];
    }
}
@end

#pragma mark GCTUIModalPresentationControllerTransitionDelegate

@implementation GCTUIModalPresentationControllerTransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    GCTUIModelPresentationPresentViewControllerTransition *presentTransition = [[GCTUIModelPresentationPresentViewControllerTransition alloc] init];
    return presentTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    GCTUIModelPresentationDismissViewControllerTransition *dismissTransition = [[GCTUIModelPresentationDismissViewControllerTransition alloc] init];
    return dismissTransition;
}

@end


