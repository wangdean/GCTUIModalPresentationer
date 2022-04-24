//
//  FirstModalPresentationViewController.m
//  PresentViewControllerTest
//
//  Created by Later on 2018/5/16.
//  Copyright © 2018年 Later. All rights reserved.
//

#import "GCTModalPresentationDemoViewController.h"

@interface GCTModalPresentationDemoViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITextField *testTextField;

@end

@implementation GCTModalPresentationDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.obserType) {
        case GCTObserverTypeInputView:
            self.observerView = self.testTextField;
            break;
        case GCTObserverTypeCustomView:
            self.observerView = self.self.contentView;
            break;
        case GCTObserverTypeSelfView:
        default:
            break;
    }
}

- (IBAction)editingBegain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
