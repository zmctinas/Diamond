//
//  OrderCommitViewController.h
//  Diamond
//
//  Created by Pan on 15/9/7.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailEntity.h"

@interface OrderCommitViewController : BaseViewController
/**
 *  请用Push 来展现此VC。
 *  @param owner  订单详情持有者，买家 || 卖家。
 *  @param entity 以下三个属性不可缺少 orderStatus,buyer_easemob,seller_easemob
 *                                                orderStatus = OrderStatusWaitCommit,
 */
- (void)setupOrder:(OrderDetailEntity *)order;

/**< 谁Push出这个OrderCommitViewController，提交完订单之后，OrderDetailViewController要回退到这个VC*/
@property (strong, nonatomic) UIViewController *pushedViewController;
@property (strong, nonatomic) NSArray *cartList;


@end
