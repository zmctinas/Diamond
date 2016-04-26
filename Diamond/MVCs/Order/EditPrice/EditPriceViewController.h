//
//  EditPriceViewController.h
//  Diamond
//
//  Created by Pan on 15/8/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderDetailModel.h"

typedef NS_ENUM(NSInteger, EditPriceType)
{
    EditPriceTypeWarePrice = 1,
    EditPriceTypePostage
};


@interface EditPriceViewController : BaseViewController

@property (nonatomic) EditPriceType type;
@property (strong, nonatomic) OrderDetailModel *model;


@end
