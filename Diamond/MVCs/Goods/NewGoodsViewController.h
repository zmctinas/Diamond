//
//  NewGoodsViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseTableViewController.h"
#import "WaresEntity.h"
#import "EditGoodsTypeViewController.h"

@interface NewGoodsViewController : BaseTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate,EditGoodsTypeDelegate>

@property (nonatomic ,strong) WaresEntity *entity;

@end
