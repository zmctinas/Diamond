//
//  ChooseShopTypeViewController.h
//  Diamond
//
//  Created by Pan on 15/8/10.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@protocol ChooseShopTypeDelegate<NSObject>

@optional
- (void)didShopTypeSelected:(NSArray *)catIds text:(NSString *)text;

@end

@interface ChooseShopTypeViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id<ChooseShopTypeDelegate> delegate;

@property (nonatomic,strong) NSArray *selectedItems;

@end
