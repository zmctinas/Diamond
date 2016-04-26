//
//  ShopSession.m
//  Diamond
//
//  Created by Leon Hu on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ShopSession.h"

@implementation ShopSession

@synthesize currentShop = _currentShop;

static ShopSession *sharedInstance = nil;

+ (ShopSession *)sharedInstance
{
    static dispatch_once_t onceQueue;
    
    dispatch_once(&onceQueue, ^{
        sharedInstance = [[ShopSession alloc] init];
    });
    
    return sharedInstance;
}

- (void)resetShop
{
    [self setCurrentShop:nil];
}

- (void)setCurrentShop:(Shop *)currentShop
{
    _currentShop = currentShop;
}

@end
