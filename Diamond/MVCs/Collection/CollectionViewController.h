//
//  CollectionViewController.h
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "DMCollectionSegmentedControl.h"

@interface CollectionViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet DMCollectionSegmentedControl *pageControl;

@property (weak, nonatomic) IBOutlet UIView *contentContainer;

@property (strong, nonatomic)NSMutableArray *pages;

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated;
- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated;

- (UIViewController *)selectedController;

- (void)updateTitleLabels;
@end

@protocol THSegmentedPageViewControllerDelegate <NSObject>

@optional

- (NSString *)viewControllerTitle;

@end

