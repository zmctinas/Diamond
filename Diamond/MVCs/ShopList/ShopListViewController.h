//
//  ShopListViewController.h
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "ShopModel.h"



@interface ShopListViewController : BaseViewController

@property (nonatomic) ShopType shopType;/**< 所要展示的商品类型,限时特价，小二推荐等等*/
@property (nonatomic, strong) NSNumber *activityID;

@end
