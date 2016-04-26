//
//  UserDetailImageCell.m
//  Diamond
//
//  Created by Pan on 15/7/21.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "UserDetailImageCell.h"

@implementation UserDetailImageCell


- (NSArray *)goodsImageViews
{
    _goodsImageViews = [_goodsImageViews sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        UIImageView *imageView1 = obj1;
        UIImageView *imageView2 = obj2;
        
        NSComparisonResult result = [@(imageView1.tag) compare:@(imageView2.tag)];
        return result;
    }];
    return _goodsImageViews;
}


@end
