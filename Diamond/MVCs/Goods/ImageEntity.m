//
//  ImageEntity.m
//  Diamond
//
//  Created by Leon Hu on 15/8/9.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "ImageEntity.h"
#import "Util.h"
#import "UIImage+Scale.h"

@implementation ImageEntity

+ (instancetype)createWithImage:(id)image
{
    ImageEntity *entity = [[ImageEntity alloc] init];
    if([image isKindOfClass:[UIImage class]]){
        //缩小后生成String
        UIImage *tmp = [image transformWithMaxWidthOrHeight:IMAGE_MAX_WIDTH_OR_HEIGHT];
        entity.image = [Util base64StringWithImage:tmp];
    }else if([image isKindOfClass:[NSString class]]){
        entity.image = image;
    }
    entity.imageExt = @"png";
    return entity;
}

@end
