//
//  GoodsCell.m
//  Diamond
//
//  Created by Leon Hu on 15/7/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "GoodsCell.h"
#import "GoodsModel.h"
#import "URLConstant.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Category.h"

@interface GoodsCell()

//@property (weak, nonatomic) IBOutlet UIImage *imageUrl;
//@property (nonatomic,strong) NSString *goodsDescription;
//@property (nonatomic,strong) NSString *price;
//@property (nonatomic,strong) NSString *collectCount;
//@property (nonatomic,strong) NSString *addTime;

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsDescription;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *collectCount;
@property (weak, nonatomic) IBOutlet UILabel *addTime;
- (IBAction)touchEditButton:(UIButton *)sender;
- (IBAction)touchOnButton:(UIButton *)sender;

@property (nonatomic,strong) GoodsModel *model;

@end

@implementation GoodsCell 



- (IBAction)touchEditButton:(UIButton *)sender {
    
}

- (IBAction)touchOnButton:(UIButton *)sender {
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.goods)
    {
        [self setImageForImageView];
        self.goodsDescription.text = self.goods.introduction;
        self.price.text = [NSString stringWithFormat:@"%@", self.goods.goods_price];
        self.collectCount.text = [NSString stringWithFormat:@"%ld",(long)self.goods.collec];
//        NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//        fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//        fmt.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
//        NSString* dateString = [fmt stringFromDate:self.goods.end_time];
//        [self.addTime setText:dateString];
        
        [self.addTime setText:self.goods.end_time];
    }
}

- (void)setImageForImageView
{
    if (self.goods.goods_url.length > 0)
    {
        NSURL *url = [Util urlWithPath:self.goods.goods_url];
        //先加载Loading画面
        [self.goodsImage setDefaultLoadingImage];
        [self.goodsImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"shop_pic_bg_jiazai"]];
    }
    else
    {
        [self.goodsImage setImage:[UIImage imageNamed:@"shop_pic_bg_jiazai"]];
    }
}

- (GoodsModel *)model
{
    if (!_model) {
        _model = [[GoodsModel alloc] init];
    }
    return _model;
}

@end
