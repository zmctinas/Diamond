//
//  PersonInfoViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/7/27.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PersonInfoViewController.h"
#import "EMError.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImageView+WebCache.h"
#import "UserDetailModel.h"
#import "City.h"
#import "EditGenderViewController.h"
#import "EditNameViewController.h"
#import "Util.h"
#import "UIImage+Scale.h"
#import "PSLocationManager.h"
#import "UIImageView+Category.h"
#import "EditAreaViewController.h"

@interface PersonInfoViewController ()<EditAreaViewControllerDelegate>

@property (nonatomic,strong) UIActionSheet *sheet;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *daimangNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (IBAction)touchSaveButton:(UIBarButtonItem *)sender;

@property (nonatomic) BOOL isChangePhoto;
@property (nonatomic,copy) NSString *lastChosenMediaType;
@property (nonatomic,strong) UserEntity *entity;
@property (nonatomic,strong) UserDetailModel *model;
/**
 *  是否被编辑过
 */
@property (nonatomic) BOOL isEdit;
/**
 *  是调转到编辑界面还是返回,如果返回,则判断是否保存
 */
@property (nonatomic) BOOL isJumpToEditView;

@end

@implementation PersonInfoViewController

NSInteger const ALERT_TAG_PHOTO = 0;
NSInteger const ALERT_TAG_GENDER = 1;
NSInteger const ALERT_TAG_NAME = 2;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width/2;
    self.photoImageView.layer.masksToBounds = YES;
    self.navigationController.navigationBarHidden = NO;
    [self addLeftBarButtonItem];
    self.title = @"个人信息";
    [self addObserverForNotifications:@[UPDATE_USER_INFO]];
    
    NSString *photoUrl = [[UserSession sharedInstance] currentUser].photo;
    if (photoUrl.length>0) {
        [self.photoImageView setDefaultLoadingImage];
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoUrl]];
    }else{
        [self.photoImageView setImage:[UIImage imageNamed:@"my_button_touxiang"]];
    }
    NSString *gender = [[UserSession sharedInstance] currentUser].sex==SexMale?@"男":@"女";
    [self.genderLabel setText:gender];
    [self.userNameLabel setText:[[UserSession sharedInstance] currentUser].user_name];
    [self.daimangNoLabel setText:[[UserSession sharedInstance] currentUser].easemob];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setupCityLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setupCityLabel
{
    UserEntity *entity = [UserSession sharedInstance].currentUser;
    NSString *cityString = nil;
    if (IS_NULL(entity.province) || IS_NULL(entity.city))
    {
        cityString = [NSString stringWithFormat:@"%@ %@",[PSLocationManager sharedInstance].province,[PSLocationManager sharedInstance].city];
    }
    else
    {
        cityString = [NSString stringWithFormat:@"%@ %@",entity.province,entity.city];
    }
    [self.cityLabel setText:cityString];

}

- (IBAction)touchSaveButton:(UIBarButtonItem *)sender {
    if (self.isEdit && !self.isJumpToEditView) {
        
//        if (self.userNameLabel.text.length < 1) {
//            [self showtips:@"名字不能为空..."];
//            return;
//        }
        
        NSMutableArray *array = nil;
        if (self.isChangePhoto)
        {
            array = [NSMutableArray array];
            UIImage *beforeImage = self.photoImageView.image;
            UIImage *image = [beforeImage transformWidth:128 height:128];
            NSString *imageString = [Util base64StringWithImage:image];
            [array addObject:imageString];
        }
        
        [self.model updateUserInfo:self.userNameLabel.text
                               sex:([self.genderLabel.text isEqualToString: @"男"]? 1:0)
                            images:array];
        [self showHUDWithTitle:@"正在保存..."];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择了第%ld行",(long)indexPath.row);
    
    self.isJumpToEditView = YES;
    switch (indexPath.row) {
        case 0:{
            self.sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照", @"相册中选取照片", nil];
            [self.sheet showInView:self.view];
            break;
        }
        case 1:{
            [self performSegueWithIdentifier:[EditGenderViewController description] sender:self];
            break;
        }
        case 2:{
            [self performSegueWithIdentifier:[EditNameViewController description] sender:self];
            break;
        }
        case 4:{
            
            break;
        }
        default:
            break;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[EditGenderViewController description]]) {
        EditGenderViewController *vc = segue.destinationViewController;
        vc.selectedSex = ([self.genderLabel.text isEqualToString:@"男"] ? SexMale : SexFeMale);
        vc.delegate = self;
        return;
    }else if([segue.identifier isEqualToString:[EditNameViewController description]]) {
        EditNameViewController *vc = segue.destinationViewController;
        vc.name = self.userNameLabel.text;
        vc.delegate = self;
        return;
    }else if([segue.identifier isEqualToString:[EditAreaViewController description]]) {
        EditAreaViewController *vc = segue.destinationViewController;
        vc.defaultAreaText = self.cityLabel.text;
        vc.delegate = self;
        return;
    }}

#pragma 拍照选择模块
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %ld", (long)buttonIndex);
    if(buttonIndex==0)
        [self shootPiicturePrVideo];
    else if(buttonIndex==1)
        [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //设置图片
        [self.photoImageView setImage:chosenImage];
        //图片已发生变更的标记
        self.isChangePhoto = YES;
        self.isEdit = YES;
        //返回后恢复标记
        self.isJumpToEditView = NO;
    }
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeMovie])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes=[UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.mediaTypes=mediatypes;
        picker.delegate=self;
        picker.allowsEditing=YES;
        picker.sourceType=sourceType;
        NSString *requiredmediatype=(NSString *)kUTTypeImage;
        NSArray *arrmediatypes=[NSArray arrayWithObject:requiredmediatype];
        [picker setMediaTypes:arrmediatypes];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    if ([notification.name isEqualToString:UPDATE_USER_INFO]) {
        NSString *photo = [[UserInfo info] currentUser].photo;//备份
        UserEntity *entity = [[UserInfo info] currentUser];
        NSString *returnPhoto = notification.object;
        if(returnPhoto.length > 0){
            entity.photo = returnPhoto;
        }else{
            entity.photo = photo;
        }
        entity.sex = [self.genderLabel.text isEqualToString:@"男"]?SexMale:SexFeMale;
        entity.user_name = self.userNameLabel.text;
        [[UserSession sharedInstance] setCurrentUser:entity];
        [[UserInfo info] setCurrentUser:entity];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - delegate

- (void)didSelectedCity:(City *)city
{
    [self.cityLabel setText:city.cityName];
    self.isEdit = YES;
    //返回后恢复标记
    self.isJumpToEditView = NO;
}

- (void)didEditGender:(NSString *)gender
{
    [self.genderLabel setText:gender];
      self.isEdit = YES;
    //返回后恢复标记
    self.isJumpToEditView = NO;
}

- (void)didEditName:(NSString *)name
{
    [self.userNameLabel setText:name];
    self.isEdit = YES;
    //返回后恢复标记
    self.isJumpToEditView = NO;
}

- (void)didEditArea
{
    self.isEdit = YES;
    //返回后恢复标记
    self.isJumpToEditView = NO;
}

#pragma mark - model

- (UserEntity *)entity
{
    if (!_entity) {
        _entity = [[UserEntity alloc] init];
    }
    return _entity;
}

- (UserDetailModel *)model
{
    if (!_model) {
        _model = [[UserDetailModel alloc] init];
    }
    return _model;
}

@end
