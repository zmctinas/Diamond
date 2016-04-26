//
//  FileManager.m
//  DrivingOrder
//
//  Created by Pan on 15/6/5.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (void)writeToFile:(NSString *)fileName withData:(NSData *)data;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    [data writeToFile:filePath atomically:YES];
}

+ (NSData *)readFromFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    return data;
}

+ (NSMutableDictionary *)readFromBundleFile:(NSString *)fileName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSMutableDictionary *readData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    return readData;
}

+ (BOOL)deleteFile:(NSString *)fileName
{
    BOOL result = YES;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] != YES) {
            result = NO;
        }
    }
    
    return result;
}
@end
