//
//  ShopDetailView.h
//  Diamond
//
//  Created by Pan on 15/7/31.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSCarouselView.h"
@class Shop;

@protocol ShopDetalViewDelegate <NSObject>

- (void)didTouchCallButton;

@end

@interface ShopDetailView : UICollectionReusableView

@property (nonatomic, strong) Shop *shop;
@property (nonatomic) BOOL isPreview;
@property (weak, nonatomic) id<ShopDetalViewDelegate> delegate;


@end
