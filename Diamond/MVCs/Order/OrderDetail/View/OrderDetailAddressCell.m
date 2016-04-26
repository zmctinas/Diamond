//
//  OrderDetailAddressCell.m
//  Diamond
//
//  Created by Pan on 15/9/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailAddressCell.h"

@interface OrderDetailAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end

@implementation OrderDetailAddressCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self hiddViewIfNeeded];
    self.nameLabel.text = self.entity.consigneeAddress.linkman;
    self.phoneLabel.text = self.entity.consigneeAddress.phoneNumber;
    self.addressLabel.text = self.entity.consigneeAddress.fullAddress;
}

- (void)hiddViewIfNeeded
{
    BOOL hiddenWhenEntityExist = self.entity.consigneeAddress ? YES : NO;
    [self.tipLabel     setHidden:hiddenWhenEntityExist];
    [self.nameLabel    setHidden:!hiddenWhenEntityExist];
    [self.phoneLabel   setHidden:!hiddenWhenEntityExist];
    [self.addressLabel setHidden:!hiddenWhenEntityExist];
    
    BOOL enableEditing = (self.entity.status == OrderStatusWaitCommit);
    [self setUserInteractionEnabled:enableEditing];
    self.accessoryType = enableEditing ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    
    if (!self.entity.consigneeAddress && self.entity.status != OrderStatusWaitCommit)
    {
        self.tipLabel.text = @"自取订单，暂无收货地址";
    }
}

@end
