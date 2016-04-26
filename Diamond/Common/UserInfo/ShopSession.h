//
//  ShopSession.h
//  Diamond
//
//  Created by Leon Hu on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shop.h"

@interface ShopSession : NSObject

@property (nonatomic, strong) Shop *currentShop;

+ (ShopSession *)sharedInstance;

- (void)resetShop;

@end
