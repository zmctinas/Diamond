//
//  ReceiveGoodsAddressCell.h
//  Diamond
//
//  Created by Leon Hu on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiveGoodsAddressEntity.h"

@protocol ReceiveGoodsAddressCellDelegate <NSObject>

@optional
- (void)didSelectAddress:(ReceiveGoodsAddressEntity *)entity;
- (void)didEditAddress:(ReceiveGoodsAddressEntity *)entity;

@end

@interface ReceiveGoodsAddressCell : UITableViewCell

@property (nonatomic,strong) ReceiveGoodsAddressEntity *entity;

@property (nonatomic,weak) id<ReceiveGoodsAddressCellDelegate> delegate;

@end
