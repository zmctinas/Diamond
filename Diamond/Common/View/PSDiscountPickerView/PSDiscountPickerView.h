//
//  PSDiscountPickerView.h
//  Diamond
//
//  Created by Leon Hu on 15/8/19.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSDiscountPickerView;

@protocol PSDiscountPickerViewDelegate <NSObject>

- (void)discountValueChanged:(NSNumber *)value text:(NSString *)text;

@end

@interface PSDiscountPickerView : UIPickerView

@property (nonatomic, weak) id<PSDiscountPickerViewDelegate> discountPickerDelegate;

@end
