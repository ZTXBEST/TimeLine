//
//  ViewController.m
//  TimeLineDemo
//
//  Created by 赵天旭 on 2017/1/11.
//  Copyright © 2017年 ZTX. All rights reserved.
//

#import "ViewController.h"
#import "TimeLineView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSArray *times = @[@"2017-01-11",@"mon",@"tue",@"wed",@"thr",@"fri",@"sat"];
    NSArray *descriptions = @[@"这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这",@"state 1",@"state 2",@"state 3",@"state 4",@"very very long and very very detailed description 0f state 5",@"这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这这",@"state 7"];
    TimeLineView *timeline = [[TimeLineView alloc] initWithTimeArray:times
                                                           andTimeDescriptionArray:descriptions
                                                                  andCurrentStatus:4
                                                                          andFrame:CGRectMake(50, 120, self.view.frame.size.width - 30, 200)];
    timeline.center = self.view.center;
    [self.view addSubview:timeline];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
