//
//  WareDetailViewController.h
//  Diamond
//
//  Created by Pan on 15/8/3.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseViewController.h"
#import "WaresEntity.h"

@interface WareDetailViewController : BaseViewController

@property (nonatomic, strong) WaresEntity *ware;
/**
 *  是否为本人预览
 */
@property (nonatomic) BOOL isPreview;

@end
