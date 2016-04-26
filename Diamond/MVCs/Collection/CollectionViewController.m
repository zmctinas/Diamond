//
//  CollectionViewController.m
//  Diamond
//
//  Created by Pan on 15/7/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "CollectionViewController.h"


#import "OrderCommitViewController.h"
#import "WebService+Order.h"
@interface CollectionViewController ()

@property (strong, nonatomic)UIPageViewController *pageViewController;

@end

@implementation CollectionViewController

@synthesize pageViewController = _pageViewController;
@synthesize pages = _pages;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    [self addChildViewController:self.pageViewController];
    [self.contentContainer addSubview:self.pageViewController.view];
    [self.pageControl addTarget:self
                         action:@selector(pageControlValueChanged:)
               forControlEvents:UIControlEventValueChanged];
    
    [self disableScroll];
    [self setupPageViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self updateTitleLabels];
    [self.view layoutSubviews];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setup
- (void)setupPageViewController
{
    if ([self.pages count]>0) {
        [self.pageViewController setViewControllers:@[self.pages[0]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:NULL];
    }
}

- (void)addLeftBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 20, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = item;
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)disableScroll
{
    //FIXME:脏代码 为了屏蔽PageViewController的手势，不影响TableView的右滑删除手势
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            view.scrollEnabled = NO;
        }
    }

}

- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages) {
        if ([vc conformsToProtocol:@protocol(THSegmentedPageViewControllerDelegate)] && [vc respondsToSelector:@selector(viewControllerTitle)] && [((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]) {
            [titles addObject:[((UIViewController<THSegmentedPageViewControllerDelegate> *)vc) viewControllerTitle]];
        } else {
            [titles addObject:vc.title ? vc.title : @"Title"];
        }
    }
    return [titles copy];
}

- (void)setPageControlHidden:(BOOL)hidden animated:(BOOL)animated
{
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        if (hidden) {
            self.pageControl.alpha = 0.0f;
        } else {
            self.pageControl.alpha = 1.0f;
        }
    }];
    [self.pageControl setHidden:hidden];
    [self.view setNeedsLayout];
}

- (UIViewController *)selectedController
{
    return self.pages[[self.pageControl selectedSegmentIndex]];
}

- (void)setSelectedPageIndex:(NSUInteger)index animated:(BOOL)animated {
    if (index < [self.pages count]) {
        [self.pageControl setSelectedSegmentIndex:index animated:YES];
        [self.pageViewController setViewControllers:@[self.pages[index]]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:animated
                                         completion:NULL];
    }
}

#pragma mark - UIPageViewControllerDataSource


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    
    [self.pageControl setSelectedSegmentIndex:[self.pages indexOfObject:[viewController.viewControllers lastObject]] animated:YES];
}

#pragma mark - Callback

- (void)pageControlValueChanged:(id)sender
{
    UIPageViewControllerNavigationDirection direction = [self.pageControl selectedSegmentIndex] > [self.pages indexOfObject:[self.pageViewController.viewControllers lastObject]] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[[self selectedController]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
}


#pragma mark - Getter And Setter

- (DMCollectionSegmentedControl *)pageControl
{
    if (_pageControl)
    {
        _pageControl.font = [UIFont systemFontOfSize:16.0];
        _pageControl.selectionIndicatorHeight = 3.0;
//        _pageControl.segmentEdgeInset = UIEdgeInsetsMake(0, 20, 0, 20);
        _pageControl.backgroundColor = [UIColor whiteColor];
        _pageControl.textColor = [UIColor grayColor];//UIColorFromRGB(BLUE_UNSELECTED);
        _pageControl.selectionIndicatorColor = [UIColor orangeColor];//UIColorFromRGB(BLUE_SELECTED);
        _pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _pageControl.selectedTextColor = [UIColor orangeColor];//UIColorFromRGB(BLUE_SELECTED);
        _pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _pageControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
        _pageControl.showVerticalDivider = NO;
    }
    return _pageControl;
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController)
    {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.frame = CGRectMake(0, 0, self.contentContainer.frame.size.width, self.contentContainer.frame.size.height);
        [_pageViewController setDataSource:self];
        [_pageViewController setDelegate:self];
        [_pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return _pageViewController;
}

- (NSMutableArray *)pages
{
    if (!_pages){
        _pages = [NSMutableArray new];
        UIViewController *shopCollectionPage = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopCollectionPage"];
        shopCollectionPage.title = @"店铺";
        UIViewController *goodsCollectionPage = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsCollectionPage"];
        goodsCollectionPage.title = @"宝贝";
        [_pages addObject:shopCollectionPage];
        [_pages addObject:goodsCollectionPage];
    }
    return _pages;
}

@end
