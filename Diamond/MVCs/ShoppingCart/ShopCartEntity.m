//
//  ShopCartEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopCartEntity.h"
#import "BuyWareEntity.h"

@implementation ShopCartEntity

- (BOOL)isChecked
{
    for (BuyWareEntity *entity in _list)
    {
        //它下面有一个没有被选中，则他没有被选中
        if (!entity.isChecked)
        {
            return NO;
        }
    }
    return YES;
}

- (void)setIsChecked:(BOOL)isChecked
{
    //勾了这个选中，就是全选
    for (BuyWareEntity *entity in _list)
    {
        entity.isChecked = isChecked;
    }
}

+ (NSDictionary *)objectClassInArray
{
    return @{@"list" : [BuyWareEntity class]};
}

@end
