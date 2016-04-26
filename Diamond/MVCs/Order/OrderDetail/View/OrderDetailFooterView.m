//
//  OrderDetailFooterView.m
//  Diamond
//
//  Created by Pan on 15/9/2.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "OrderDetailFooterView.h"
#import "OrderDetailEntity.h"
#define CONSTANT_WITH_ARROW 27.0
#define CONSTANT_WITHOUT_ARROR 12.0

@interface OrderDetailFooterView ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIButton *postageArrowButton;
@property (weak, nonatomic) IBOutlet UILabel *postTypeLabel;/**< 配送方式*/
@property (weak, nonatomic) IBOutlet UILabel *leftPostageLabel;/**< 运费*/
@property (weak, nonatomic) IBOutlet UILabel *rightPostageLabel;/**< 运费 OR 修改运费*/

@property (weak, nonatomic) IBOutlet UILabel *totleFeeLabel;/**< 合计*/
@property (weak, nonatomic) IBOutlet UITextField *remarkTextField;/**< 备注textField*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postTypeRightConstraint;/**< 配送方式的右边距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageRightConstraint;/**< 运费的右边距*/
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;/**< 划线的旧价格*/
- (IBAction)touchEditPostageButton:(UIButton *)sender;

- (IBAction)touchPostTypeButton:(UIButton *)sender;

@property (nonatomic) BOOL enableEditPostage;
@property (weak, nonatomic) NSString *oldPrice;
@property (strong, nonatomic) NSAttributedString *oldPriceAttString;

@end

@implementation OrderDetailFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.remarkTextField.delegate = self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setupPostageLabel];
    [self setupPostTypeLabel];
    [self setupTotleFeeLabel];
    
    self.postTypeLabel.text = self.entity.deliveryTypeString;
    self.remarkTextField.text = self.entity.introduction;
}

- (void)setupTotleFeeLabel
{
    if (self.entity.old_total_fee)
    {
        //如果卖家编辑过价格
        self.oldPrice = [NSString stringWithFormat:@"￥%.2f",[self.entity.old_total_fee doubleValue]];
        self.oldPriceLabel.attributedText = self.oldPriceAttString;
    }
    else
    {
        //如果卖家没有编辑过价格
        self.oldPriceLabel.text = @"";
    }
    self.totleFeeLabel.text =  [NSString stringWithFormat:@"￥%.2f",[self.entity.total_fee doubleValue]];
}

- (void)setupPostTypeLabel
{
    //在未付款且订单拥有者为卖家的情况下 允许修改此订单的运费
    _postTypeRightConstraint.constant = self.enableEditPostType ? CONSTANT_WITH_ARROW : CONSTANT_WITHOUT_ARROR;
    [self.arrowButton setHidden:!self.enableEditPostType];
    self.postTypeLabel.text = self.entity.deliveryTypeString;
}


- (void)setupPostageLabel
{
    //在未付款且订单拥有者为卖家的情况下 允许修改此订单的运费
    _postageRightConstraint.constant = self.enableEditPostage ? CONSTANT_WITH_ARROW : CONSTANT_WITHOUT_ARROR;
    [self.leftPostageLabel setHidden:!self.enableEditPostage];
    [self.postageArrowButton setHidden:!self.enableEditPostage];
    NSString *postage = [NSString stringWithFormat:@"￥%.2lf",[self.entity.delivery_fee doubleValue]];
    if (self.enableEditPostage)
    {
        self.rightPostageLabel.text = @"编辑运费";
        self.leftPostageLabel.text = postage;
    }
    else
    {
        self.rightPostageLabel.text = postage;
    }
}

- (void)setOrderType:(OrderDetailType)orderType
{
    _orderType = orderType;
    BOOL hidden = (orderType == OrderDetailTypeNormal) ? YES : NO;
    [self.arrowButton setHidden:hidden];
    [self.remarkTextField setEnabled:!hidden];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (IBAction)touchEditPostageButton:(UIButton *)sender {
    if (self.entity.status == OrderStatusUnpay && self.owner == OrderOwnerSeller)
    {
        if ([self.delegate respondsToSelector:@selector(didTouchEditPostageButton)])
        {
            [self.delegate didTouchEditPostageButton];
        }
    }
}

- (IBAction)touchPostTypeButton:(UIButton *)sender;
{
    if (self.orderType == OrderDetailTypeCommit)
    {
        if ([self.delegate respondsToSelector:@selector(didTouchPostTypeButton)])
        {
            [self.delegate didTouchPostTypeButton];
        }
    }
}

- (BOOL)enableEditPostage
{
    return (self.owner == OrderOwnerSeller && self.entity.status == OrderStatusUnpay);
}

- (BOOL)enableEditPostType
{
    return (self.owner == OrderOwnerBuyer && self.entity.status == OrderStatusWaitCommit);
}


- (void)setOldPrice:(NSString *)oldPrice
{
    NSUInteger length = [oldPrice length];
    NSRange allRange = NSMakeRange(0, length);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:oldPrice];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:allRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    
    _oldPriceAttString = attri;
    _oldPrice = oldPrice;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(didTouchRetrunKeyWithInputWords:)])
    {
        [self.delegate didTouchRetrunKeyWithInputWords:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
