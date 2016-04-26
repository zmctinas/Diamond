//
//  EditLimitedSpecialViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/8/16.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PSDiscountPickerView.h"

@interface EditLimitedSpecialViewController : BaseTableViewController<UITextFieldDelegate,PSDiscountPickerViewDelegate>

@property (nonatomic,strong) NSArray *goodsIds;

@end
