//
//  DMTabbar.h
//  Diamond
//
//  Created by Pan on 15/12/20.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSTabbarItem.h"

extern NSInteger const MAIN_INDEX;
extern NSInteger const CHAT_INDEX;
extern NSInteger const ORDER_INDEX;
extern NSInteger const ME_INDEX;


@protocol DMTabbarDelegate <NSObject>
@optional
- (BOOL)shouldSelectItemAtIndex:(NSInteger)index;
- (void)didSelectItemAtIndex:(NSInteger)index;

- (BOOL)shouldSelectCenterItem;
- (void)didSelectCenterItem;
@end

@interface DMTabbar : UITabBar

+ (DMTabbar *_Nullable)tabbar;

@property (weak, nonatomic) id<DMTabbarDelegate> DMTDelegate;

@property (nullable,nonatomic,strong) UIImage *centerIcon;

@property(nullable,nonatomic,copy) NSArray<PSTabbarItem *> *barItems;

@end
