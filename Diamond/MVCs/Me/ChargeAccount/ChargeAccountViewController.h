//
//  ChargeAccountViewController.h
//  Diamond
//
//  Created by Pan on 15/9/30.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChargeAccountViewControllerDelegate <NSObject>

- (void)conformWechatAccount:(NSString *)openID alipayAccount:(NSString *)alipayAccount;
- (void)conformWechatAccount:(NSString *)openID alipayAccount:(NSString *)alipayAccount real_name:(NSString *)realName;

@end

@interface ChargeAccountViewController : BaseViewController

@property (weak, nonatomic) id<ChargeAccountViewControllerDelegate> delegate;

- (void)setupWithwechatAccount:(NSString *)wechatAccount alipay:(NSString *)alipay;
@end
