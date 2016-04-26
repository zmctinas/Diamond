//
//  PSSelectItemHeader.h
//  Diamond
//
//  Created by Leon Hu on 15/9/1.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopCartEntity.h"
@class PSSelectItemHeader;

@protocol PSSelectItemHeaderDelegate <NSObject>

/**
 *  联系卖家
 *
 *  @param seller 卖家标识
 */
- (void)didTouchContactSellerAtSection:(NSInteger)section;
- (void)didTouchShopButtonAtSection:(NSInteger)section;

- (void)selectItemHeader:(PSSelectItemHeader *)headView didTouchSelectButton:(UIButton *)button;

@end

@interface PSSelectItemHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) ShopCartEntity *entity;
@property (nonatomic) NSInteger section;
@property (nonatomic,weak) id<PSSelectItemHeaderDelegate> delegate;

@end
