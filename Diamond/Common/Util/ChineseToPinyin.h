//
//  ChineseToPinyin.h
//  DrivingOrder
//
//  Created by Pan on 15/5/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *) pinyinFromChineseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 

@end