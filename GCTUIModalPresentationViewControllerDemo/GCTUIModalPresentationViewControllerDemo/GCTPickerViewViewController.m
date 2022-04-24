//
//  GCTPickerViewViewController.m
//  PresentViewControllerTest
//
//  Created by Later on 2018/5/16.
//  Copyright © 2018年 Later. All rights reserved.
//

#import "GCTPickerViewViewController.h"

@interface GCTPickerViewViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *makeSureButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation GCTPickerViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backViewType = GCTUIModalPresentBackViewTypeDark;
    self.presentAnimation = GCTUIModalPresentAnimationSlideInFromBottom;
    self.dismissAnimation = GCTUIModalDismissAnimationSlideOutFromBottom;
    self.touchDismissEnable = NO;
    self.observerView = self.contentView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
}

#pragma mark - Action

- (IBAction)closeButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)makeSureButtonAction:(UIButton *)sender {
    NSInteger row = [self.pickerView selectedRowInComponent:0];
    if (row >= 0 && row < self.infos.count) {
        NSString *title = self.infos[row];
        !self.pickerCompletatBlock ?: self.pickerCompletatBlock(row, title);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.infos.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title = self.infos[row];
    return title;
}

@end
