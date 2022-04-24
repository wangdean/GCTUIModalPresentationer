//
//  ViewController.m
//  PresentViewControllerTest
//
//  Created by Later on 2018/5/16.
//  Copyright © 2018年 Later. All rights reserved.
//

#import "ViewController.h"
#import "GCTModalPresentationDemoViewController.h"
#import "GCTPickerViewViewController.h"



@interface ViewController () 
@property (weak, nonatomic) IBOutlet UIButton *backTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *presentTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *dismissTypeButton;
@property (weak, nonatomic) IBOutlet UISwitch *touchDismissSwitch;
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, assign) GCTUIModalPresentBackViewType backType;
@property (nonatomic, assign) GCTUIModalPresentAnimation presentAnimation;
@property (nonatomic, assign) GCTUIModalDismissAnimation dismissAnimation;
@property (nonatomic, assign) BOOL touchDismissEnable;

@property (nonatomic, strong) NSArray *backTypeInfos;
@property (nonatomic, strong) NSArray *presentAnimationInfos;
@property (nonatomic, strong) NSArray *dismissAnimationInfos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backType = GCTUIModalPresentBackViewTypeDark;
    self.presentAnimation = GCTUIModalPresentAnimationSlideInFromTop;
    self.dismissAnimation = GCTUIModalDismissAnimationSlideOutFromTop;
    self.touchDismissEnable = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backViewTypeButtonAction:(UIButton *)sender {
    GCTPickerViewViewController *pickerViewController = [[GCTPickerViewViewController alloc] init];
    pickerViewController.actionIndex = GCTActionIndexBackViewType;
    pickerViewController.infos = self.backTypeInfos;
    pickerViewController.selectedIndex = self.backType;
    __weak typeof(self)weakSelf = self;
    pickerViewController.pickerCompletatBlock = ^(NSInteger index, NSString *title) {
        weakSelf.backType = index;
    };
    [self presentViewController:pickerViewController animated:YES completion:nil];
}
- (IBAction)presentTypeButtonAction:(UIButton *)sender {
    GCTPickerViewViewController *pickerViewController = [[GCTPickerViewViewController alloc] init];
    pickerViewController.actionIndex = GCTActionIndexPresentType;
    pickerViewController.infos = self.presentAnimationInfos;
    pickerViewController.selectedIndex = self.presentAnimation;
    __weak typeof(self)weakSelf = self;
    pickerViewController.pickerCompletatBlock = ^(NSInteger index, NSString *title) {
        weakSelf.presentAnimation = index;
    };
    [self presentViewController:pickerViewController animated:YES completion:nil];
}
- (IBAction)dismissTypeButtonAction:(UIButton *)sender {
    GCTPickerViewViewController *pickerViewController = [[GCTPickerViewViewController alloc] init];
    pickerViewController.actionIndex = GCTActionIndexDismissType;
    pickerViewController.infos = self.dismissAnimationInfos;
    pickerViewController.selectedIndex = self.dismissAnimation;
    __weak typeof(self)weakSelf = self;
    pickerViewController.pickerCompletatBlock = ^(NSInteger index, NSString *title) {
        weakSelf.dismissAnimation = index;
    };
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (IBAction)touchDismissSwitchAction:(UISwitch *)sender {
    self.touchDismissEnable = sender.isOn;
}
- (IBAction)presentSelfViewObserverViewController:(UIButton *)sender {
    GCTModalPresentationDemoViewController *demoPresentViewController = [[GCTModalPresentationDemoViewController alloc] init];
    demoPresentViewController.backViewType = self.backType;
    demoPresentViewController.presentAnimation = self.presentAnimation;
    demoPresentViewController.dismissAnimation = self.dismissAnimation;
    demoPresentViewController.touchDismissEnable = self.touchDismissEnable;
    demoPresentViewController.obserType = GCTObserverTypeSelfView;
    [self presentViewController:demoPresentViewController animated:YES completion:nil];
}

- (IBAction)presentCustomViewObserverViewController:(UIButton *)sender {
    GCTModalPresentationDemoViewController *demoPresentViewController = [[GCTModalPresentationDemoViewController alloc] init];
    demoPresentViewController.backViewType = self.backType;
    demoPresentViewController.presentAnimation = self.presentAnimation;
    demoPresentViewController.dismissAnimation = self.dismissAnimation;
    demoPresentViewController.touchDismissEnable = self.touchDismissEnable;
    demoPresentViewController.obserType = GCTObserverTypeCustomView;
    [self presentViewController:demoPresentViewController animated:YES completion:nil];
}

- (IBAction)presentInputViewObserverController:(id)sender {
    GCTModalPresentationDemoViewController *demoPresentViewController = [[GCTModalPresentationDemoViewController alloc] init];
    demoPresentViewController.backViewType = self.backType;
    demoPresentViewController.presentAnimation = self.presentAnimation;
    demoPresentViewController.dismissAnimation = self.dismissAnimation;
    demoPresentViewController.touchDismissEnable = self.touchDismissEnable;
    demoPresentViewController.obserType = GCTObserverTypeInputView;
    [self presentViewController:demoPresentViewController animated:YES completion:nil];
}

#pragma mark - Setter/Getter
- (void)setBackType:(GCTUIModalPresentBackViewType)backType {
    _backType = backType;
    [self.backTypeButton setTitle:self.backTypeInfos[_backType] forState:UIControlStateNormal];
}

- (void)setPresentAnimation:(GCTUIModalPresentAnimation)presentAnimation {
    _presentAnimation = presentAnimation;
    [self.presentTypeButton setTitle:self.presentAnimationInfos[_presentAnimation] forState:UIControlStateNormal];
}

- (void)setDismissAnimation:(GCTUIModalDismissAnimation)dismissAnimation {
    _dismissAnimation = dismissAnimation;
    [self.dismissTypeButton setTitle:self.dismissAnimationInfos[_dismissAnimation] forState:UIControlStateNormal];
}

- (NSArray *)backTypeInfos {
    if (!_backTypeInfos) {
        _backTypeInfos = @[
                           @"Clear", // GCTUIModalPresentBackViewTypeClear
                           @"Dark", // GCTUIModalPresentBackViewTypeDark
                           @"White", // GCTUIModalPresentBackViewTypeWhite
                           @"BlurDark", // GCTUIModalPresentBackViewTypeBlurDark
                           @"BlurWhite" // GCTUIModalPresentBackViewTypeBlurWhite
                           ];
    }
    return _backTypeInfos;
}

- (NSArray *)presentAnimationInfos {
    if (!_presentAnimationInfos) {
        _presentAnimationInfos = @[
                              @"None", // GCTUIModalPresentAnimationNone
                              @"FadeIn", // GCTUIModalPresentAnimationFadeIn
                              @"GrowIn", // GCTUIModalPresentAnimationGrowIn
                              @"ShrinkIn", // GCTUIModalPresentAnimationShrinkIn
                              @"SlideInFromTop", // GCTUIModalPresentAnimationSlideInFromTop
                              @"SlideInFromBottom", // GCTUIModalPresentAnimationSlideInFromBottom
                              @"SlideInFromLeft", // GCTUIModalPresentAnimationSlideInFromLeft
                              @"SlideInFromRight", // GCTUIModalPresentAnimationSlideInFromRight
                              @"BounceIn", // GCTUIModalPresentAnimationBounceIn
                              @"BounceInFromTop", // GCTUIModalPresentAnimationBounceInFromTop
                              @"BounceInFromBottom", // GCTUIModalPresentAnimationBounceInFromBottom
                              @"BounceInFromLeft", // GCTUIModalPresentAnimationBounceInFromLeft
                              @"BounceInFromRight" // GCTUIModalPresentAnimationBounceInFromRight
                              ];
    }
    return _presentAnimationInfos;
}

- (NSArray *)dismissAnimationInfos {
    if (!_dismissAnimationInfos) {
        _dismissAnimationInfos = @[
                              @"None", // GCTUIModalDismissAnimationNone
                              @"FadeOut", // GCTUIModalDismissAnimationFadeOut
                              @"GrowOut", // GCTUIModalDismissAnimationGrowOut
                              @"ShrinkOut", // GCTUIModalDismissAnimationShrinkOut
                              @"SlideOutFromTop", // GCTUIModalDismissAnimationSlideOutFromTop
                              @"SlideOutFromBottom", // GCTUIModalDismissAnimationSlideOutFromBottom
                              @"SlideOutFromLeft", // GCTUIModalDismissAnimationSlideOutFromLeft
                              @"SlideOutFromRight", // GCTUIModalDismissAnimationSlideOutFromRight
                              @"BounceOut", // GCTUIModalDismissAnimationBounceOut
                              @"BounceOutFromTop", // GCTUIModalDismissAnimationBounceOutFromTop
                              @"BounceOutFromBottom", // GCTUIModalDismissAnimationBounceOutFromBottom
                              @"BounceOutFromLeft", // GCTUIModalDismissAnimationBounceOutFromLeft
                              @"BounceOutFromRight" // GCTUIModalDismissAnimationBounceOutFromRight
                              ];
    }
    return _dismissAnimationInfos;
}
@end
