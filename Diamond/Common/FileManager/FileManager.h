//
//  FileManager.h
//  DrivingOrder
//
//  Created by Pan on 15/6/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (void)writeToFile:(NSString *)fileName withData:(NSData *)data;

+ (NSData *)readFromFile:(NSString *)fileName;

+ (BOOL)deleteFile:(NSString *)fileName;

+ (NSMutableDictionary *)readFromBundleFile:(NSString *)fileName;
@end
