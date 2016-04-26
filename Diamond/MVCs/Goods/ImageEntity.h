//
//  ImageEntity.h
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "BaseEntity.h"

@interface ImageEntity : BaseEntity
/**
 *  图片的Base64值
 */
@property (nonatomic,strong) NSString *image;
/**
 *  图片的后缀名
 */
@property (nonatomic,strong) NSString *imageExt;

+ (instancetype)createWithImage:(id)image;

@end
