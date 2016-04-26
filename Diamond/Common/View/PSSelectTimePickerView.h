//
//  PSSelectTimePickerView.h
//  Diamond
//
//  Created by Leon Hu on 15/8/13.
//  Copyright (c) 2015年 Pan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSSelectTimePickerView;

@protocol PSSelectTimePickerViewDelegate<NSObject>

- (void)selectChanged;

@end

@interface PSSelectTimePickerView : UIPickerView

@property (nonatomic,copy) NSString *openTime;
@property (nonatomic,copy) NSString *closeTime;

@property (nonatomic, weak) id<PSSelectTimePickerViewDelegate> selectTimePickerdelegate;

@end
