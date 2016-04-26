//
//  Friend.m
//  Diamond
//
//  Created by Pan on 15/7/22.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "Friend.h"

@implementation Friend

MJCodingImplementation


- (NSString *)searchString
{
    if (!_searchString)
    {
        _searchString = IS_NULL(_remarkname) ? _user_name : [_remarkname stringByAppendingString:_user_name];
    }
    return _searchString;
}
@end
