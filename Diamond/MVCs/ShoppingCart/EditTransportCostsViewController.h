//
//  EditTransportCostsViewController.h
//  Diamond
//
//  Created by Leon Hu on 15/8/29.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"

@protocol EditTransportCostsDelegate <NSObject>

@optional
- (void)didEditTransportCosts:(NSInteger)distance price:(NSNumber *)price;

@end

/**
 *  编辑运费
 */
@interface EditTransportCostsViewController : BaseViewController

@property (nonatomic,weak) id<EditTransportCostsDelegate> delegate;

@property (nonatomic) NSInteger distance;
@property (nonatomic,strong) NSNumber *price;

@end
