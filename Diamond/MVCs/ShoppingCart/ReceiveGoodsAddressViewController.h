//
//  ReceiveGoodsAddressViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/8/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
@class ReceiveGoodsAddressEntity;

@protocol ConsigneeAddressViewControllerDelegate <NSObject>
@required
- (void)didChooseAddress:(ReceiveGoodsAddressEntity *)address;
- (void)didDeleteAddress:(ReceiveGoodsAddressEntity *)address;
@end

/**
 *  收货地址列表
 */
@interface ReceiveGoodsAddressViewController : BaseTableViewController

@property (strong, nonatomic) ReceiveGoodsAddressEntity *selectedAddress;

@property (weak, nonatomic) id<ConsigneeAddressViewControllerDelegate> delegate;


@end
