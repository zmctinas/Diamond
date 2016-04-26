//
//  AddToShopCartMenu.m
//  Diamond
//
//  Created by Leon Hu on 15/9/15.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "PSAddToShopCartMenu.h"
#import "UIImageView+WebCache.h"
#import "ShopCartModel.h"
#import "ShopCartEntity.h"
#import "UIImageView+Category.h"

@interface PSAddToShopCartMenu()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *promotionPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsStockLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *typeScrollView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

- (IBAction)touchCloseButton:(UIButton *)sender;
- (IBAction)touchCallSellerButton:(UIButton *)sender;
- (IBAction)touchMinusCountButton:(UIButton *)sender;
- (IBAction)touchAddCountButton:(UIButton *)sender;
- (IBAction)touchSubmitButton:(UIButton *)sender;

@property (nonatomic, strong) WaresEntity *entity;
@property (nonatomic,strong) ShopCartModel *model;
@property (nonatomic,strong) GoodsTypeEntity *goodsTypeEntity;

/**
 *  购买的数量
 */
@property (nonatomic) NSInteger buyCount;

@end


@implementation PSAddToShopCartMenu

+ (PSAddToShopCartMenu *)initView
{
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:[PSAddToShopCartMenu description] owner:nil options:nil];
    for (UIView *view in views)
    {
        if ([view isKindOfClass:[PSAddToShopCartMenu class]])
        {
            PSAddToShopCartMenu *menu = (PSAddToShopCartMenu *)view;
            [menu setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
            [menu setAlpha:0];
            return menu;
        }
    }
    return nil;
}

- (void)setCurrentEntity:(WaresEntity *)waresEntity
{
    @try {
        self.entity = waresEntity;
        if (self.entity) {
            self.buyCount = 1;
            [self.goodsImageView setDefaultLoadingImage];
            [self.goodsImageView sd_setImageWithURL:[Util urlWithPath:[self.entity.goods_url objectAtIndex:0]]];
            [self.goodsNameLabel setText:self.entity.goods_name];
            if (self.entity.is_promotion) {
                [self.goodsPriceLabel setHidden:NO];
                NSString *goodsPrice = [NSString stringWithFormat:@"￥%.2f",self.entity.goods_price.doubleValue];
                NSAttributedString *attr=  [Util deleteLineStyleString:goodsPrice];
                [self.goodsPriceLabel setAttributedText:attr];
            }else{
                [self.goodsPriceLabel setHidden:YES];
            }
            [self.promotionPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",self.entity.promotion_price.doubleValue]];
            
            int buttonHeight = 30;
            CGFloat w = 0;//保存前一个button的宽以及前一个button距离屏幕边缘的距离
            CGFloat h = (self.typeScrollView.frame.size.height - buttonHeight) / 2;//用来控制button距离父视图的高
            NSMutableArray *typeWhichHasStack = [NSMutableArray new];
            for (GoodsTypeEntity *goodsTypeEntity in self.entity.type) {
                if (goodsTypeEntity.stock > 0) {
                    [typeWhichHasStack addObject:goodsTypeEntity];
                }
            }
            //动态添加按钮
            for (int i=0; i<[typeWhichHasStack count]; i++) {
                GoodsTypeEntity *goodsTypeEntity = [typeWhichHasStack objectAtIndex:i];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.tag = goodsTypeEntity.typeId.integerValue;
                [button addTarget:self action:@selector(touchTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                //根据计算文字的大小
                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
                CGFloat length = [goodsTypeEntity.typeName boundingRectWithSize:CGSizeMake(self.typeScrollView.frame.size.width, self.typeScrollView.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
                //为button赋值
                NSString *title = goodsTypeEntity.typeName;
                if (title.length > 7) {
                    title = [NSString stringWithFormat:@"%@...",[title substringWithRange:NSMakeRange(0,6)]];
                }
                [button setTitle:title forState:UIControlStateNormal];
                //设置button的frame
                button.frame = CGRectMake(10 + w, h, length + 15 , buttonHeight);
                [button setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_xuanzhekuang"] forState:UIControlStateNormal];
                w = button.frame.size.width + button.frame.origin.x;
                [self.typeScrollView addSubview:button];
            }
            //设置scrollview可滑动
            [self.typeScrollView setContentSize:CGSizeMake(w+10, self.typeScrollView.frame.size.height)];
            self.typeScrollView.showsHorizontalScrollIndicator = NO;
            //默认选中第一项
            if ([self.entity.type count])
            {
                GoodsTypeEntity *select = [self.entity.type objectAtIndex:0];
                [self selectType:select];
                for (UIView *v in self.typeScrollView.subviews) {
                    if([v isKindOfClass:[UIButton class]]){
                        UIButton *button = (UIButton *)v;
                        if (button.tag == select.typeId.integerValue) {
                            [button setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_bg"] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        }else{
                            [button setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_xuanzhekuang"] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)show{
    [self setVisibility:YES];
}

- (void)hide{
    [self setVisibility:NO];
}

- (IBAction)touchCloseButton:(UIButton *)sender
{
    [self setVisibility:NO];
}

- (IBAction)touchCallSellerButton:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(ShopCartMenu:didTouchContactSellerButton:)])
    {
        [self.delegate ShopCartMenu:self didTouchContactSellerButton:sender];
    }
}

- (IBAction)touchMinusCountButton:(UIButton *)sender
{
    if (self.buyCount>1) {
        self.buyCount--;
    }
}

- (IBAction)touchAddCountButton:(UIButton *)sender
{
    if (self.buyCount < self.goodsTypeEntity.stock) {
        self.buyCount++;
    }
}

- (void)touchTypeClicked:(UIButton *)sender {
    //设置选中状态
    for (UIView *v in self.typeScrollView.subviews) {
        if([v isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)v;
            [button setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_xuanzhekuang"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    [sender setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_bg"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置数据
    for (GoodsTypeEntity *typeEntity in self.entity.type) {
        if (typeEntity.typeId.integerValue == sender.tag) {
            self.buyCount = 1;
            [self selectType:typeEntity];
            break;
        }
    }
}

- (IBAction)touchSubmitButton:(UIButton *)sender
{
    if (self.buyNow)
    {
        if ([self.delegate respondsToSelector:@selector(buyNow:count:)])
        {
            [self.delegate buyNow:self.goodsTypeEntity count:self.buyCount];
        }
    }
    else
    {
        [self.model addToShopCart:self.goodsTypeEntity.typeId.integerValue count:self.buyCount];
        [self setVisibility:NO];
        if ([self respondsToSelector:@selector(didAddedShopCart)]) {
            [self.delegate didAddedShopCart];
        }
    }
}

- (void)setVisibility:(BOOL)isShow{
    if(isShow)
    {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:0
                         animations:^{
                             [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                         }];
    }else
    {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:0
                         animations:^{
                             [self setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (void)selectType:(GoodsTypeEntity *)typeEntity
{
    self.goodsTypeEntity = typeEntity;
    [self.countLabel setText:[NSString stringWithFormat:@"%ld",(long)self.buyCount]];
    [self.goodsStockLabel setText:[NSString stringWithFormat:@"库存%ld件",(long)self.goodsTypeEntity.stock]];
    double price = [self.goodsTypeEntity.price doubleValue];
    double nowPrice = self.entity.is_promotion ? (price * [self.entity.discount doubleValue]) / 10 : price;
    [self.promotionPriceLabel setText:[NSString stringWithFormat:@"￥%.2lf",nowPrice]];
    if (self.entity.is_promotion) {
        [self.goodsPriceLabel setHidden:NO];
        NSString *goodsPrice = [NSString stringWithFormat:@"￥%.2f",self.goodsTypeEntity.price.doubleValue];
        NSAttributedString *attr=  [Util deleteLineStyleString:goodsPrice];
        [self.goodsPriceLabel setAttributedText:attr];
    }else{
        [self.goodsPriceLabel setHidden:YES];
    }
    
    
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self setVisibility:YES];
}

#pragma mark delegate



#pragma mark getter&setter

- (void)setBuyCount:(NSInteger)buyCount
{
    _buyCount = buyCount;
    [self.countLabel setText:[NSString stringWithFormat:@"%ld",(long)_buyCount]];
}

- (ShopCartModel *)model
{
    if (!_model) {
        _model = [[ShopCartModel alloc] init];
    }
    return _model;
}

@end
