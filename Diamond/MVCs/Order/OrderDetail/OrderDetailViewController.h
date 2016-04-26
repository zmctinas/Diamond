//
//  OrderDetailViewController.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderEnum.h"
#import "OrderDetailEntity.h"

@interface OrderDetailViewController : BaseViewController
/**
 *  Push之前初始化VC
 *  @param owner  订单详情持有者，买家 || 卖家。
 *  @param entity 需要 out_trade_no, orderStatus,buyer_easemob,seller_easemob
 */
- (void)setupWithOwner:(OrderOwner)owner entity:(OrderDetailEntity *)entity;

@property (nonatomic) UIViewController *backToViewController;/**< Witch ViewController need pop to,if nil,just pop last ViewController*/
@end
