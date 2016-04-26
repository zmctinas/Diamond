//
//  WareListViewController.h
//  Diamond
//
//  Created by Pan on 15/7/28.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "WareModel.h"

/**
 *  可复用的展示商品的商品双栏列表
 */
@interface WareListViewController : BaseViewController

@property (nonatomic) WareType wareType;/**< 所要展示的商品类型,限时特价，小二推荐等等*/


@end
