//
//  FirstModalPresentationViewController.h
//  PresentViewControllerTest
//
//  Created by Later on 2018/5/16.
//  Copyright © 2018年 Later. All rights reserved.
//

#import "GCTUIModalPresentationViewController.h"

typedef NS_ENUM(NSInteger, GCTObserverType) {
    GCTObserverTypeSelfView,
    GCTObserverTypeInputView,
    GCTObserverTypeCustomView
};
@interface GCTModalPresentationDemoViewController : GCTUIModalPresentationViewController
@property (nonatomic, assign) GCTObserverType obserType;
@end
