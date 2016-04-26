//
//  PushNotificationEntity.h
//  Diamond
//
//  Created by Pan on 15/10/30.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

extern NSString *const OrderSubmit;/**< 买家在你这里下单了*/
extern NSString *const UpdateFee;/**< 卖家修改了订单价格*/
extern NSString *const ConfirmSend;/**< 卖家确认发货了*/
extern NSString *const ConfirmOrder;/**< 买家确认收货了*/
extern NSString *const PaymentFee;/**< 买家付款了*/

@interface PushNotificationEntity : BaseEntity


@property (strong, nonatomic) NSString *easemob;/**< 是买方还是卖方的环信账号*/
@property (strong, nonatomic) NSString *out_trade_no;/**< 订单号码*/
@property (strong, nonatomic) NSString *msg;/**< 定位代号*/
@property (strong, nonatomic) NSString *title;/**< 推送标题*/
@property (strong, nonatomic) NSString *content;/**< 推送内容*/


@end
