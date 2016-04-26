//
//  OrderListContainerViewController.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//


#import "BaseViewController.h"
#import <HMSegmentedControl@hons82/HMSegmentedControl.h>
#import "OrderListEntity.h"

@interface OrderListContainerViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (nonatomic) OrderOwner owner;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)updateTitleLabels;

@end