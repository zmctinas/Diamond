//
//  OrderListContainerViewController.m
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderListContainerViewController.h"
#import "OrderListViewController.h"
@interface OrderListContainerViewController ()

@property (weak, nonatomic) IBOutlet HMSegmentedControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *contentContainer;
@property (strong, nonatomic)UIPageViewController *pageViewController;
@property (strong, nonatomic)NSMutableArray *pages;

@end

@implementation OrderListContainerViewController

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
    [self setupTitle];
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
- (void)setupTitle
{
    switch (self.owner)
    {
        case OrderOwnerBuyer:
            self.title = @"我买到的";
            break;
        case OrderOwnerSeller:
            self.title = @"我卖出的";
            break;
        default:
            break;
    }
}

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
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (NSString *)titleWithIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
            return  TITLE_ALL;
            break;
        case 1:
        {
            if (self.owner == OrderOwnerBuyer)
            {
                return TITLE_UNPAY;
            }
            return TITLE_UNCHARGE;
        }
        case 2:
            return TITLE_TRADING;
        case 3:
            return TITLE_DONE;
        default:
            return nil;
    }
}

- (void)updateTitleLabels
{
    [self.pageControl setSectionTitles:[self titleLabels]];
}

- (NSArray *)titleLabels
{
    NSMutableArray *titles = [NSMutableArray new];
    for (UIViewController *vc in self.pages)
    {
        [titles addObject:vc.title ? vc.title : @"Title"];
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

- (HMSegmentedControl *)pageControl
{
    if (_pageControl)
    {
        _pageControl.font = [UIFont systemFontOfSize:14.0];
        _pageControl.selectionIndicatorHeight = 2.0;
        _pageControl.backgroundColor = [UIColor whiteColor];
        _pageControl.textColor = [UIColor grayColor];
        _pageControl.selectionIndicatorColor = [UIColor orangeColor];
        _pageControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _pageControl.selectedTextColor = [UIColor orangeColor];
        _pageControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
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
        _pages = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i++)
        {
            OrderListViewController *orderListViewController = [self.storyboard instantiateViewControllerWithIdentifier:[OrderListViewController description]];
            orderListViewController.title = [self titleWithIndex:i];
            orderListViewController.owner = self.owner;
            [_pages addObject:orderListViewController];
        }
    }
    return _pages;
}
@end