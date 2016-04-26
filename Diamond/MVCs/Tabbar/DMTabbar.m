//
//  DMTabbar.m
//  Diamond
//
//  Created by Pan on 15/12/20.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "DMTabbar.h"
#import "Macros.h"

NSInteger const MAIN_INDEX = 0;
NSInteger const CHAT_INDEX = 1;
NSInteger const ORDER_INDEX = 2;
NSInteger const ME_INDEX = 3;
NSInteger const CENTER_INDEX = 1024;

@interface DMTabbar ()

@property (weak, nonatomic) IBOutlet UIButton *mainIconButton;
@property (weak, nonatomic) IBOutlet UIButton *mainTextButton;
@property (weak, nonatomic) IBOutlet UIButton *chatIconButton;
@property (weak, nonatomic) IBOutlet UIButton *chatTextButton;
@property (weak, nonatomic) IBOutlet UIButton *orderIconButton;
@property (weak, nonatomic) IBOutlet UIButton *orderTextButton;
@property (weak, nonatomic) IBOutlet UIButton *meIconButton;
@property (weak, nonatomic) IBOutlet UIButton *meTextButton;
@property (weak, nonatomic) IBOutlet UIButton *centerButton;

@property (strong, nonatomic) IBOutletCollection(PSTabbarItem) NSArray *tabbarItems;


- (IBAction)touchButton:(UIButton *)sender;
- (void)touchCenterButton;/**< 点击正中间的按钮*/

@property (assign, nonatomic) BOOL hasSetup;
@end


@implementation DMTabbar

+ (DMTabbar *)tabbar
{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:[DMTabbar description] owner:nil options:nil];
    for (UIView *view in views)
    {
        if ([view isKindOfClass:[DMTabbar class]])
        {
            return (DMTabbar *)view;
        }
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.hasSetup)
    {
        [self setSelectedTitleColorForButtons:@[self.meTextButton,self.mainTextButton,self.orderTextButton,self.chatTextButton]];
        [self.mainIconButton setImage:[UIImage imageNamed:@"tabIconWithColor0"] forState:UIControlStateSelected];
        [self.chatIconButton setImage:[UIImage imageNamed:@"tabIconWithColor1"] forState:UIControlStateSelected];
        [self.orderIconButton setImage:[UIImage imageNamed:@"tabIconWithColor2"] forState:UIControlStateSelected];
        [self.meIconButton setImage:[UIImage imageNamed:@"tabIconWithColor3"] forState:UIControlStateSelected];
        [self selectButtonAtIndex:MAIN_INDEX];
        self.hasSetup = YES;
    }
    [self hideDivideLineInTabbar];
    [self bringSubviewToFront:self.centerButton];
}

- (IBAction)touchButton:(UIButton *)sender;
{
    if ([sender isEqual:self.mainIconButton] || [sender isEqual:self.mainTextButton]) {
        if ([self shouldSelectItemAtIndex:MAIN_INDEX]) {
            [self selectButtonAtIndex:MAIN_INDEX];
        }
    } else if ([sender isEqual:self.chatIconButton] || [sender isEqual:self.chatTextButton]) {
        if ([self shouldSelectItemAtIndex:CHAT_INDEX]) {
            [self selectButtonAtIndex:CHAT_INDEX];
        }
    } else if ([sender isEqual:self.orderIconButton] || [sender isEqual:self.orderTextButton]) {
        if ([self shouldSelectItemAtIndex:ORDER_INDEX]) {
            [self selectButtonAtIndex:ORDER_INDEX];
        }
    } else if ([sender isEqual:self.meIconButton] || [sender isEqual:self.meTextButton]) {
        if ([self shouldSelectItemAtIndex:ME_INDEX]) {
            [self selectButtonAtIndex:ME_INDEX];
        }
    } else if ([sender isEqual:self.centerButton]) {
        if ([self shouldSelectCenterButton]) {
            [self touchCenterButton];
        }
    }
}

- (void)touchCenterButton;/**< 点击正中间的按钮*/
{
    if ([self.DMTDelegate respondsToSelector:@selector(didSelectCenterItem)])
    {
        [self.DMTDelegate didSelectCenterItem];
    }
}

- (void)setSelectedTitleColorForButtons:(NSArray<UIButton *> *)buttons
{
    for (UIButton *btn in buttons)
    {
        [btn setTitleColor:UIColorFromRGB(GLOBAL_TINTCOLOR) forState:UIControlStateSelected];
    }
}

- (void)selectButtonAtIndex:(NSInteger)index
{
    self.mainIconButton.selected  = index == MAIN_INDEX;
    self.mainTextButton.selected  = index == MAIN_INDEX;
    self.chatIconButton.selected  = index == CHAT_INDEX;
    self.chatTextButton.selected  = index == CHAT_INDEX;
    self.orderIconButton.selected = index == ORDER_INDEX;
    self.orderTextButton.selected = index == ORDER_INDEX;
    self.meIconButton.selected    = index == ME_INDEX;
    self.meTextButton.selected    = index == ME_INDEX;
    
    if ([self.DMTDelegate respondsToSelector:@selector(didSelectItemAtIndex:)])
    {
        [self.DMTDelegate didSelectItemAtIndex:index];
    }
}

- (BOOL)shouldSelectItemAtIndex:(NSInteger)index
{
    if ([self.DMTDelegate respondsToSelector:@selector(shouldSelectItemAtIndex:)])
    {
        return [self.DMTDelegate shouldSelectItemAtIndex:index];
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldSelectCenterButton
{
    if ([self.DMTDelegate respondsToSelector:@selector(shouldSelectCenterItem)])
    {
        return [self.DMTDelegate shouldSelectCenterItem];
    }
    else
    {
        return YES;
    }
}

- (void)hideDivideLineInTabbar
{
    /// 隐藏底部 TabBar 的上横线
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
            UIImageView *ima = (UIImageView *)view;
            //                        ima.backgroundColor = [UIColor redColor];
            ima.hidden = YES;
            break;
        }
    }
}

#pragma mark - Getter & Setter

- (void)setCenterIcon:(UIImage *)centerIcon
{
    _centerIcon = centerIcon;
    [_centerButton setImage:centerIcon forState:UIControlStateNormal];
}

- (NSArray<PSTabbarItem *> *)barItems
{
    NSArray *sortedItems = [_tabbarItems sortedArrayUsingComparator:^NSComparisonResult(PSTabbarItem *obj1, PSTabbarItem *obj2) {
        if (obj1.tag > obj2.tag)
        {
            return NSOrderedDescending;
        }
        else
        {
            return NSOrderedAscending;
        }
    }];
    _barItems = sortedItems;
    return _barItems;
}
@end
