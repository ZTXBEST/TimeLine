//
//  TimeLineView.h
//  TimeLineDemo
//
//  Created by 赵天旭 on 2017/1/11.
//  Copyright © 2017年 ZTX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineView : UIView

@property(nonatomic, assign)CGFloat viewHeight;

- (id)initWithTimeArray:(NSArray *)time andTimeDescriptionArray:(NSArray *)timeDescriptions andCurrentStatus:(int)status andFrame:(CGRect)frame;

@end
