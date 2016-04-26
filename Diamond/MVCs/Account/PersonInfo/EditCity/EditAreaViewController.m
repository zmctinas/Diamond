//
//  EditCityViewController.m
//  Diamond
//
//  Created by Pan on 15/11/6.
//  Copyright © 2015年 Pan. All rights reserved.
//

#import "EditAreaViewController.h"
#import "PSAreaPickerView.h"
#import "WebService+User.h"
@interface EditAreaViewController ()<PSCityPickerViewDelegate>

@property (strong, nonatomic) WebService *webService;

@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *doneToolbar;

@property (strong, nonatomic) PSAreaPickerView *picker;

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender;
- (IBAction)didTouchDoneButton:(id)sender;
@end

@implementation EditAreaViewController
#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addLeftBarButtonItem];
    self.areaTextField.text = self.defaultAreaText;
    self.areaTextField.inputAccessoryView = self.doneToolbar;
    self.areaTextField.inputView = self.picker;
}

#pragma mark - PSCityPickerViewDelegate
- (void)cityPickerViewValueChanged
{
    [self.areaTextField setText:[NSString stringWithFormat:@"%@ %@",self.picker.province,self.picker.city]];

}

#pragma mark - Navigation


#pragma mark - IBAction
- (IBAction)didTouchDoneButton:(id)sender;
{
    if ([self.delegate respondsToSelector:@selector(didEditArea)])
    {
        [self.delegate didEditArea];
    }
    if (IS_NULL(self.picker.province) || IS_NULL(self.picker.city))
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [self saveToLocal];
    [self saveToServer];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchDoneButtonInToolbar:(UIButton *)sender;
{
    [self.areaTextField resignFirstResponder];
}

#pragma mark - Notification


#pragma mark - Private Method
//override
- (void)back
{
    if ([self.delegate respondsToSelector:@selector(didEditArea)])
    {
        [self.delegate didEditArea];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveToServer
{
    UserEntity *user = [UserSession sharedInstance].currentUser;
    [self.webService updateUserInfo:user.easemob
                           province:user.province
                               city:user.city
                         completion:^(BOOL isSuccess, NSString *message, id result) {
                             if (isSuccess)
                             {
                                 DLog(@"update user province success");
                             }
                             else
                             {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:WebServiceErrorNotification object:@"啊哦，服务器出错了，没能成功修改地区哦，请稍后重试"];
                             }
                         }];
}

- (void)saveToLocal
{
    UserEntity *user = [UserSession sharedInstance].currentUser;
    user.province = self.picker.province;
    user.city = self.picker.city;
    [UserSession sharedInstance].currentUser = user;

}

#pragma mark - Getter and Setter
- (PSAreaPickerView *)picker
{
    if (!_picker)
    {
        _picker = [[PSAreaPickerView alloc] init];
        _picker.cityPickerDelegate = self;
    }
    return _picker;
}

- (WebService *)webService
{
    if (!_webService)
    {
        _webService = [WebService service];
    }
    return _webService;
}


@end
