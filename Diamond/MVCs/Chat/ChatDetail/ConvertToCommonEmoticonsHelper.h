//
//  ConvertToCommonEmoticonsHelper.h
//  Diamond
//
//  Created by Pan on 15/7/11.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertToCommonEmoticonsHelper : NSObject
+ (NSString *)convertToCommonEmoticons:(NSString *)text;
+ (NSString *)convertToSystemEmoticons:(NSString *)text;
@end
