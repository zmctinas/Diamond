//
//  ShopDetailViewController.h
//  Diamond
//
//  Created by Pan on 15/7/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "Shop.h"
@interface ShopDetailViewController : BaseViewController

@property (nonatomic) Shop *shop;/**< 此Shop至少需要 shop_id 和easemob两个信息*/
@property (nonatomic) BOOL isPreview;/**< 是否是预览 */

@end
