//
//  SetUpViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/7/26.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "PSCityPickerView.h"
#import "ChooseShopTypeViewController.h"

@interface SetUpViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,PSCityPickerViewDelegate,ChooseShopTypeDelegate>

@end
