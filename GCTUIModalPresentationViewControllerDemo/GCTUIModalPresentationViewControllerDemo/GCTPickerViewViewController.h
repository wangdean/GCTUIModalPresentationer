//
//  GCTPickerViewViewController.h
//  PresentViewControllerTest
//
//  Created by Later on 2018/5/16.
//  Copyright © 2018年 Later. All rights reserved.
//

#import "GCTUIModalPresentationViewController.h"

typedef NS_ENUM(NSInteger, GCTActionIndex) {
    GCTActionIndexNone = -1,
    GCTActionIndexBackViewType,
    GCTActionIndexPresentType,
    GCTActionIndexDismissType
};

@interface GCTPickerViewViewController : GCTUIModalPresentationViewController
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) GCTActionIndex actionIndex;
@property (nonatomic, strong) NSArray *infos;
@property (nonatomic, copy) void(^pickerCompletatBlock)(NSInteger index, NSString *title);
@end
