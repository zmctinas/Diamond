//
//  ShopTypeView.h
//  Diamond
//
//  Created by Pan on 15/7/20.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopTypeView;
@protocol ShopTypeViewDelegate <NSObject>

- (void)didMoveToPage:(NSUInteger)page;

- (void)didTouchType:(NSInteger)type;

@end


@interface ShopTypeView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<ShopTypeViewDelegate> pageDelegate;


@end
