//
//  NewGoodsViewController.m
//  Diamond
//
//  Created by Leon Hu on 15/8/4.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "NewGoodsViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "GoodsModel.h"
#import "EMError.h"
#import "UIButton+WebCache.h"
#import "UIImage+Scale.h"
#import <QuartzCore/QuartzCore.h>
#import <QuartzCore/CoreAnimation.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "GoodsTypeCell.h"
#import "ImageEntity.h"
#import "UIButton+Category.h"

@interface NewGoodsViewController ()<GoodsTypeCellDelegate,UITextViewDelegate>

@property (strong, nonatomic) UIActionSheet *sheet;
@property (strong,nonatomic) UIAlertView *alert;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *deletePhotoButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *photoButtons;
@property (weak, nonatomic) IBOutlet UIButton *deleteGoodsButton;

@property (weak, nonatomic) IBOutlet UITextField *goodsNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *recommendSwitch;
@property (weak, nonatomic) IBOutlet UITextView *goodsDescriptionTextField;

- (IBAction)touchPhotoButton:(UIButton *)sender;
- (IBAction)touchDeletePhotoButton:(UIButton *)sender;
- (IBAction)touchAddTypeButton:(UIButton *)sender;
- (IBAction)touchOkButton:(UIBarButtonItem *)sender;
- (IBAction)touchDeleteGoodsButton:(UIButton *)sender;

@property (nonatomic,copy) NSString *lastChosenMediaType;
@property (nonatomic) NSInteger currentButtonIndex;
@property (nonatomic,strong) GoodsModel *model;
@property (nonatomic,strong) GoodsTypeEntity *needEditGoodsTypeEntity;

@end

@implementation NewGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLeftBarButtonItem];
    [self addObserverForNotifications:@[ADD_GOODS_NOTIFICATION,UPDATE_GOODS,DEL_GOODS]];
    
    self.goodsNameTextField.delegate = self;
    self.goodsDescriptionTextField.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setUp];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self setupForDismissKeyboard];
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBarHidden = NO;
    
    if (self.entity) {
        [self.deleteGoodsButton setHidden:NO];
    }else{
        [self.deleteGoodsButton setHidden:YES];
    }
    [self hideHUD];
}

- (IBAction)touchOkButton:(UIBarButtonItem *)sender {
    [self showHUDWithTitle:@"正在保存..."];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *site =[[NSMutableArray alloc] init];
    NSInteger length = 0;
    for (UIButton *button in self.photoButtons) {
        if (button.currentImage) {
            [site addObject:@(button.tag)];
            length++;
            ImageEntity *imageEntity = [ImageEntity createWithImage:button.currentImage];
            [mutableArray addObject:imageEntity];
        }
    }
    if (![mutableArray count]) {
        [self showtips:@"请添加至少一张图片"];
        return;
    }else if (!self.goodsNameTextField.text.length) {
        [self showtips:@"请填写商品名称"];
        return;
    }else if (!self.goodsDescriptionTextField.text.length) {
        [self showtips:@"请填写商品介绍"];
        return;
    }else if (!self.model.dataSource || [self.model.dataSource count]<1) {
        [self showtips:@"请添加商品类型"];
        return;
    }else{
        for (GoodsTypeEntity *typeEntity in self.model.dataSource) {
            //去除临时性的ID
            if (typeEntity.typeId.longValue < 0) {
                typeEntity.typeId = nil;
            }
        }
    }
    
    if (self.entity) {
        //修改比较
        for (int i=0; i<[self.entity.goods_url count]; i++) {
            for (UIButton *button in self.photoButtons) {
                if (button.tag == i) {
                    if (!button.currentImage) {
                        [site addObject:@(button.tag)];
                    }
                }
            }
        }
        
        [self showHUDWithTitle:@"修改商品..."];
        [self.model updateGoods:self.goodsNameTextField.text
                    isRecommend:self.recommendSwitch.isOn
                    description:self.goodsDescriptionTextField.text
                           site:site
                         length:length
                        goodsId:self.entity.goods_id
                         images:mutableArray
                       typeList:self.model.dataSource];

    }else{
        [self showHUDWithTitle:@"添加商品..."];
        [self.model addNewGoods:self.goodsNameTextField.text
                    isRecommend:self.recommendSwitch.isOn
                    description:self.goodsDescriptionTextField.text
                         images:mutableArray
                       typeList:self.model.dataSource];
    }
}

- (IBAction)touchDeleteGoodsButton:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:@"确定要删除吗?"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
    [alert show];
}

- (IBAction)touchPhotoButton:(UIButton *)sender
{
    [self showAlert:sender.tag];
}

- (IBAction)touchDeletePhotoButton:(UIButton *)sender
{
    [self deleteImage:sender.tag];
}

- (IBAction)touchAddTypeButton:(UIButton *)sender
{
    self.needEditGoodsTypeEntity = nil;
    [self performSegueWithIdentifier:[EditGoodsTypeViewController description] sender:nil];
}

- (void)setUp
{
    self.title = self.entity ? @"编辑商品" : @"上传新品";
    if (self.entity)
    {
        [self showHUDWithTitle:@"正在加载..."];
        NSInteger count = [self.entity.goods_url count];
        if (count)
        {
            for (int i=0; i<count; i++) {
                UIButton *button = [self.photoButtons objectAtIndex:i];
                UIButton *deleteButton = [self.deletePhotoButtons objectAtIndex:i];
                NSString *url = [self.entity.goods_url objectAtIndex:i];
                [button setDefaultLoadingImage];
                [button sd_setImageWithURL:[Util urlWithPath:url] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (image)
                    {
                        [deleteButton setHidden:NO];
                    }
                }];
            }
        }
        
        [self.goodsNameTextField setText:self.entity.goods_name];

        [self.goodsDescriptionTextField setText:self.entity.introduction];
        [self.recommendSwitch setOn:self.entity.is_recommend];
        
        self.model.dataSource = [self.entity.type mutableCopy];
        [self.tableView reloadData];
    }
    if (!self.model.dataSource) {
        self.model.dataSource = [NSMutableArray new];
    }
}

- (void)showAlert:(NSInteger)buttonIndex
{
    self.currentButtonIndex = buttonIndex;
    
    self.sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    
    // Show the sheet
    [self.sheet showInView:self.view];
}

- (void)deleteImage:(NSInteger)index
{
    UIButton *button = [self.photoButtons objectAtIndex:index];
    UIButton *deleteButton = [self.deletePhotoButtons objectAtIndex:index];
    [button setImage:nil forState:UIControlStateNormal];
    [deleteButton setHidden:YES];
}

- (void)receivedNotification:(NSNotification *)notification
{
    [self hideHUD];
    
    if ([notification.name isEqualToString: ADD_GOODS_NOTIFICATION]){
        [self showtips:@"添加成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if([notification.name isEqualToString: UPDATE_GOODS]){
        [self showtips:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else if([notification.name isEqualToString: DEL_GOODS]){
        [self showtips:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveUpViewForFrame:textView.frame];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self recoverView];
}
//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self moveUpViewForFrame:textField.frame];
}

- (void)moveUpViewForFrame:(CGRect)frame
{
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

- (void)recoverView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self  recoverView];
}

#pragma 删除确认
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
            if (self.entity.goods_id.length > 0) {
                [self.model delGoods:self.entity.goods_id];
            }
            break;
        default:
            break;
    }
}
#pragma 拍照选择模块

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self shootPiicturePrVideo];
            break;
        case 1:
            [self selectExistingPictureOrVideo];
            break;
        default:
            break;
    }
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo
{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.lastChosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.lastChosenMediaType isEqual:(NSString *) kUTTypeImage])
    {
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerEditedImage];
        //设置图片
        [[self.photoButtons objectAtIndex:self.currentButtonIndex] setImage:chosenImage forState:UIControlStateNormal];
        [[self.deletePhotoButtons objectAtIndex:self.currentButtonIndex] setHidden:NO];
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

#pragma mark table delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.model.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:[GoodsTypeCell description] forIndexPath:indexPath];
    if ([self.model.dataSource count])
    {
        GoodsTypeEntity *entity = [self.model.dataSource objectAtIndex:indexPath.item];
        cell.entity = entity;
        cell.delegate = self;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GoodsTypeEntity *goodsTypeEntity = [self.model.dataSource objectAtIndex:indexPath.row];
        
        [self.model.dataSource removeObject:goodsTypeEntity];
        [self.tableView reloadData];
    }
}

#pragma mark edit goods type delegate

- (void)didEditingGoodsType:(GoodsTypeEntity *)entity
{
    self.needEditGoodsTypeEntity = entity;
    [self performSegueWithIdentifier:[EditGoodsTypeViewController description] sender:nil];
}

- (void)didEditedGoodsType:(GoodsTypeEntity *)entity
{
    BOOL isEdit = NO;
    for (GoodsTypeEntity *goodsTypeEntity in self.model.dataSource) {
        if (goodsTypeEntity.typeId.integerValue == entity.typeId.integerValue) {
            goodsTypeEntity.typeName = entity.typeName;
            goodsTypeEntity.price = entity.price;
            goodsTypeEntity.stock = entity.stock;
            isEdit = YES;
            break;
        }
    }
    if (entity.typeId.longValue < 0 && !isEdit) {
        [self.model.dataSource addObject:entity];
    }
    [self.tableView reloadData];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:[EditGoodsTypeViewController description]]) {
        EditGoodsTypeViewController *vc = segue.destinationViewController;
        [vc setGoodsType:self.needEditGoodsTypeEntity];
        vc.delegate = self;
    }
}

#pragma mark getter&setter

- (GoodsModel *)model
{
    if (!_model) {
        _model = [[GoodsModel alloc] init];
    }
    return _model;
}

/**
 *  排序
 *
 *  @return 排序后的按钮组
 */
- (NSArray *)photoButtons
{
    _photoButtons = [_photoButtons sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
        if (obj1.tag < obj2.tag)
        {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    return _photoButtons;
}
- (NSArray *)deletePhotoButtons
{
    _deletePhotoButtons = [_deletePhotoButtons sortedArrayUsingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
        if (obj1.tag < obj2.tag)
        {
            return(NSComparisonResult)NSOrderedAscending;
        }else {
            return(NSComparisonResult)NSOrderedDescending;
        }
    }];
    return _deletePhotoButtons;
}

@end
