//
//  LimitedSpecialModel.h
//  Diamond
//
//  Created by Leon Hu on 15/8/17.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseModel.h"
#import "RequestEntity.h"

@interface LimitedSpecialModel : BaseModel

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)giveMeLastestData;

- (void)giveMeNextData;

- (void)addPromotion:(NSArray *)goodsIds discount:(NSNumber *)discount startTime:(NSDate *)startTime stopTime:(NSDate *)stopTime;

- (void)delPromotionAtIndexPath:(NSIndexPath *)indexPath;

@end
