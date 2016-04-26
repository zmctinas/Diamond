//
//  Util.m
//  DrivingOrder
//
//  Created by Pan on 15/5/30.
//  Copyright (c) 2015年 Pan. All rights reserved.
//
#import "Util.h"
#import "URLConstant.h"
#import "CommonCrypto/CommonDigest.h"
#import "ShopEnum.h"


static const double EARTH_RADIUS = 6378.245;//地球半径


@implementation Util

+ (NSString *)stringFormDate:(NSDate *)date WithFormater:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"zh_CN"];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFormDate:(NSDate *)date
{
    return [Util stringFormDate:date WithFormater:DefaultDateFormat];
}

+ (NSString *)base64StringWithImage:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *base64Str = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64Str;
}

+ (NSDate *)dateFromString:(NSString*)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:DefaultDateFormat];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"zh_CN"];
    NSDate *date=[formatter dateFromString:string];
    return date;
}

/**
 *  NSString值为Unicode格式的字符串编码(如\\u7E8C)转换成中文
 *
 *  @param unicodeStr
 *
 *  @return
 */
+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    if (!IS_NULL(unicodeStr))
    {
        NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
        NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
        NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
        return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
    }
    else
    {
        return nil;
    }
}

+ (NSString *)md5:(NSString *)src
{
    const char *cStr = [src UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}



+ (NSString *)stringWithoutLastCharacter:(NSString *)aString;
{
    if (IS_NULL(aString))
    {
        return nil;
    }
    NSString *resultString = [aString substringWithRange:NSMakeRange(0, [aString length] - 1)];
    return resultString;
}


+ (NSString *)stringWithDistance:(double)distance
{
    NSString *disString = (distance  > 1000)
    ? ([NSString stringWithFormat:@"距离 %.1lfkm",distance  / 1000])
    : ([NSString stringWithFormat:@"距离 %dm",(int)distance]);
    return disString;
}

+ (NSString *)urlStringWithPath:(NSString *)path
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@",IMAGE_BASEURL,DAIMANG,path];
    return urlString;
}

+ (NSURL *)urlWithPath:(NSString *)path
{
    NSString *urlString = [self urlStringWithPath:path];
    return [NSURL URLWithString:urlString];
}

+ (NSAttributedString *)deleteLineStyleString:(NSString *)string
{
    NSUInteger length = [string length];
    NSRange allRange = NSMakeRange(0, length);
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:allRange];
    [attri addAttribute:NSStrikethroughColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    [attri addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(LIGHT_GRAY) range:allRange];
    
    return attri;
}

+ (NSString *)priceStringWithPrice:(CGFloat)price
{
//    return (price < 10000) ? [NSString stringWithFormat:@"￥%.2f",price] : [NSString stringWithFormat:@"￥%.1f万",(price / 10000)];
    return [NSString stringWithFormat:@"￥%.2f",price];
}

+ (void)callWithPhoneNumber:(NSString *)phoneNumber
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]];
}

+ (BOOL)evaluatePhoneNumber:(NSString *)phoneNumber
{
    NSString *regex = @"^1([38]\\d{2}|4[57]\\d{1}|5[0-35-9]\\d{1}|70[059])\\d{7}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    return isMatch;
}

+ (double)distanceBetweenLocation:(CLLocation *)location AndLocation:(CLLocation *)otherLocation;
{
    return GetDistance(location.coordinate.latitude,
                       location.coordinate.longitude,
                       otherLocation.coordinate.latitude,
                       otherLocation.coordinate.longitude);
}

double rad(double d)
{
    return d * M_PI / 180.0;
}

double GetDistance(double lat1, double lng1, double lat2, double lng2)
{
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    double a = radLat1 - radLat2;
    double b = rad(lng1) - rad(lng2);
    
    double s = 2 * asin(sqrt(pow(sin(a/2),2) + cos(radLat1) * cos(radLat2)* pow(sin(b/2),2)));
    s = s * EARTH_RADIUS;
    s = round(s * 10000) / 10000;
    return s;
}

+ (NSString *)countDownStringWithDate:(NSDate *)date
{
    if (!date)
    {
        return nil;
    }
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    if (interval <= 0 ) {
        return nil;
    }
    
    NSInteger day = interval / 86400;
    //剩余
    NSInteger residue = ((int)interval % 86400);
    NSInteger hour =  residue / 3600;
    residue = residue % 3600;
    NSInteger min = residue /60;
    NSInteger second = residue % 60;
    
    NSMutableString *str = [NSMutableString new];
    
    if (day > 0) {
        [str appendFormat:@"%ld天",(long)day];
    }
    if(hour > 9){
        [str appendFormat:@"%ld",(long)hour];
    }else{
        [str appendFormat:@"0%ld",(long)hour];
    }
    if(min > 9){
        [str appendFormat:@":%ld",(long)min];
    }else{
        [str appendFormat:@":0%ld",(long)min];
    }
    if (day <= 0) {//当显示天数的时候,不显示秒数
        if(second>9){
            [str appendFormat:@":%ld",(long)second];
        }else{
            [str appendFormat:@":0%ld",(long)second];
        }
    }
    [str insertString:@"剩余" atIndex:0];
    return str;
}

+ (NSString *)shareUrlWithShopId:(NSNumber *)shopId
{
    return [SHARE_URL stringByAppendingString:shopId.stringValue];
}

+ (NSString *)shopTitleWithType:(NSInteger)type
{
    switch (type)
    {
        case 0:
            return @"全部";
        case 1:
            return @"精品服饰";
        case 2:
            return @"时尚鞋靴";
        case 3:
            return @"箱包配件";
        case 4:
            return @"手机数码";
        case 5:
            return @"妈咪宝贝";
        case 6:
            return @"日用百货";
        case 7:
            return @"珠宝配饰";
        case 8:
            return @"运动户外";
        case 9:
            return @"家电办公";
        case 10:
            return @"美食茶酒";
        case 11:
            return @"护肤彩妆";
        case 12:
            return @"家具建材";
        case 13:
            return @"家居家纺";
        case 14:
            return @"花鸟文娱";
        case 15:
            return @"动漫游戏";
        case 100:
            return @"新铺开张";
        case 101:
            return @"热销铺子";
        case 1000:
            return @"官方活动";
        default: return nil;
    }
}
@end
