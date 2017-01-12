//
//  TimeLineView.m
//  TimeLineDemo
//
//  Created by 赵天旭 on 2017/1/11.
//  Copyright © 2017年 ZTX. All rights reserved.
//

#import "TimeLineView.h"
#import "UIView+extension.h"

const float BETTWEEN_LABEL_OFFSET = 20;
const float LINE_WIDTH = 2.0;
const float CIRCLE_RADIUS = 3.0;
const float INITIAL_PROGRESS_CONTAINER_WIDTH = 20.0;
const float PROGRESS_VIEW_CONTAINER_LEFT = 51.0;
const float VIEW_WIDTH = 225.0;

@interface TimeLineView()<CAAnimationDelegate>
{
    BOOL didStopAnimation;
    NSMutableArray *layers;
    NSMutableArray *circleLayers;
    int layerCounter;
    int circleCounter;
    CGFloat timeOffset;
    CGFloat leftWidth;
    CGFloat rightWidth;
    
    CGFloat viewWidth;
}


@property(nonatomic, strong) UIView *progressView;
@property(nonatomic, strong) UIView *timeView;
@property(nonatomic, strong) UIView *progressDescriptionView;

@property(nonatomic, strong) NSMutableArray *labelDscriptionsArray;
@property(nonatomic, strong) NSMutableArray *sizes;

@end


@implementation TimeLineView


- (NSMutableArray *)labelDscriptionsArray {
    if (!_labelDscriptionsArray) {
        _labelDscriptionsArray = [[NSMutableArray alloc] init];
    }
    return _labelDscriptionsArray;
}

- (NSMutableArray *)sizes {
    if (!_sizes) {
        _sizes = [[NSMutableArray alloc] init];
    }
    return _sizes;
}


- (id)initWithTimeArray:(NSArray *)time andTimeDescriptionArray:(NSArray *)timeDescriptions andCurrentStatus:(int)status andFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _viewHeight = 75.0;
        
        self.timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 51, 258)];
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(51, 0, 23, 258)];
        self.progressDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(74, 0, 271, 258)];
        
        [self addSubview:self.progressView];
        [self addSubview:self.timeView];
        [self addSubview:self.progressDescriptionView];
        
        
        [self addTimeDescriptionLabels:timeDescriptions andTime:time currentStatus:status];
        [self setNeedsUpdateConstraints];
        [self addProgressBasedOnLabels:self.labelDscriptionsArray currentStatus:status];
        [self addTimeLabels:time currentStatus:status];

    }
    return self;
}

- (void)addTimeLabels:(NSArray *)time currentStatus:(int)currentStatus {

    CGFloat totlaHeight = 6;
    int i = 0;
    for (NSString *timeDescription in time) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.timeView.width, 30)];
        label.text = timeDescription;
        label.numberOfLines = 0;
        label.textColor = i < currentStatus ? [UIColor blackColor] : [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [label sizeToFit];
        [self.timeView addSubview:label];
        
        UILabel *descrLabel = self.labelDscriptionsArray[i];
        label.rightTop = CGPointMake(self.timeView.width, descrLabel.top);
        
        totlaHeight += (label.height + BETTWEEN_LABEL_OFFSET);
        
        [self.labelDscriptionsArray addObject:label];
        i++;
    }
    
    _viewHeight = totlaHeight;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)addProgressBasedOnLabels:(NSArray *)labels currentStatus:(int)currentStatus {
    int i = 0;
    CGFloat betweenLineOffset = 0;
    CGFloat totlaHeight = 8;
    CGPoint lastpoint;
    CGFloat yCenter;
    UIColor *strokeColor;
    CGPoint toPoint;
    CGPoint fromPoint;
    circleLayers = [[NSMutableArray alloc] init];
    layers = [[NSMutableArray alloc] init];
    
    for (UILabel *label in labels) {
        
        strokeColor = i < currentStatus ? [UIColor orangeColor] : [UIColor lightGrayColor];
        yCenter = totlaHeight;
        
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [self configureBezierCircle:circle withCenterY:yCenter];
        
        CAShapeLayer *circleLayer = [self getLayerWithCircle:circle andStrokeColor:strokeColor];
        [circleLayers addObject:circleLayer];

        CAShapeLayer *grayStaticCircleLayer = [self getLayerWithCircle:circle andStrokeColor:[UIColor lightGrayColor]];
        [self.progressView.layer addSublayer:grayStaticCircleLayer];

        if (i > 0) {
            fromPoint = lastpoint;
            toPoint = CGPointMake(lastpoint.x, yCenter - CIRCLE_RADIUS);
            lastpoint = CGPointMake(lastpoint.x, yCenter + CIRCLE_RADIUS);
            
            UIBezierPath *line = [self getLineWithStartPoint:fromPoint endPoint:toPoint];
            CAShapeLayer *lineLayer = [self getLayerWithLine:line andStrokeColor:strokeColor];
            [layers addObject:lineLayer];

            CAShapeLayer *grayStaticLineLayer = [self getLayerWithLine:line andStrokeColor:[UIColor lightGrayColor]];
            [self.progressView.layer addSublayer:grayStaticLineLayer];
        } else {
            lastpoint = CGPointMake(self.progressView.width/2.0, yCenter + CIRCLE_RADIUS);
        }
        
        betweenLineOffset = BETTWEEN_LABEL_OFFSET;
        totlaHeight += (label.height + betweenLineOffset);
        i++;
    }
    
    [self startAnimatingLayers:circleLayers forStatus:currentStatus];
    
}

- (void)addTimeDescriptionLabels:(NSArray *)timeDescriptions andTime:(NSArray *)time currentStatus:(int)currentStatus {
    
    CGFloat totlaHeight = 6;
    
    UILabel *tempLabel = nil;
    int i =0;
    for (NSString *timeDescription in timeDescriptions) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.progressDescriptionView.width, 30)];
        label.text = timeDescription;
        label.numberOfLines = 0;
        label.textColor = i < currentStatus ? [UIColor blackColor] : [UIColor grayColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14.0];
        [label setPreferredMaxLayoutWidth:self.progressDescriptionView.width-7];
        [label sizeToFit];
        
        [self.progressDescriptionView addSubview:label];
        if (tempLabel == nil) {
            label.leftTop = CGPointMake(7, 0);
        }
        else {
            label.leftTop = CGPointMake(7, tempLabel.bottom+BETTWEEN_LABEL_OFFSET);
        }
        
        totlaHeight += (label.height + BETTWEEN_LABEL_OFFSET);
        
        [self.labelDscriptionsArray addObject:label];
        tempLabel = label;
        i++;
    }
    _viewHeight = totlaHeight;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];

}

- (CAShapeLayer *)getLayerWithLine:(UIBezierPath *)line andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    lineLayer.path = line.CGPath;
    lineLayer.strokeColor = strokeColor.CGColor;
    lineLayer.fillColor = nil;
    lineLayer.lineWidth = LINE_WIDTH;
    
    return lineLayer;
}

- (UIBezierPath *)getLineWithStartPoint:(CGPoint)start endPoint:(CGPoint)end {
    UIBezierPath *line = [UIBezierPath bezierPath];
    [line moveToPoint:start];
    [line addLineToPoint:end];
    
    return line;
}

- (CAShapeLayer *)getLayerWithCircle:(UIBezierPath *)circle andStrokeColor:(UIColor *)strokeColor {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = circle.CGPath;
    circleLayer.frame = self.progressView.bounds;
    circleLayer.strokeColor = strokeColor.CGColor;
    circleLayer.fillColor = nil;
    circleLayer.lineWidth = LINE_WIDTH;
    circleLayer.lineJoin = kCALineJoinBevel;
    
    return circleLayer;
}

- (void)configureBezierCircle:(UIBezierPath *)circle withCenterY:(CGFloat)centerY {
    [circle addArcWithCenter:CGPointMake(self.progressView.width/2, centerY)
                      radius:CIRCLE_RADIUS
                  startAngle:M_PI_2
                    endAngle:-M_PI_2
                   clockwise:YES];
    [circle addArcWithCenter:CGPointMake(self.progressView.width/2, centerY)
                      radius:CIRCLE_RADIUS
                  startAngle:-M_PI_2
                    endAngle:M_PI_2
                   clockwise:YES];
}

- (void)startAnimatingLayers:(NSArray *)layersToAnimate forStatus:(int)currentStatus {
    float circleTimeOffset = 1;
    circleCounter = 0;
    int i = 1;
    
    if (currentStatus == layersToAnimate.count) {

        for (CAShapeLayer *cilrclLayer in layersToAnimate) {
            [self.progressView.layer addSublayer:cilrclLayer];
        }
        for (CAShapeLayer *lineLayer in layers) {
            [self.progressView.layer addSublayer:lineLayer];
        }
    } else {

        for (CAShapeLayer *cilrclLayer in layersToAnimate) {
            [self.progressView.layer addSublayer:cilrclLayer];
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation.duration = 0.2;
            animation.beginTime = [cilrclLayer convertTime:CACurrentMediaTime() fromLayer:nil] + circleTimeOffset;
            animation.fromValue = [NSNumber numberWithFloat:0.0f];
            animation.toValue   = [NSNumber numberWithFloat:1.0f];
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            circleTimeOffset += .4;
            [cilrclLayer setHidden:YES];
            [cilrclLayer addAnimation:animation forKey:@"strokeCircleAnimation"];
            if (i == currentStatus && i != [layersToAnimate count]) {
                CABasicAnimation *strokeAnim = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
                strokeAnim.fromValue         = (id) [UIColor orangeColor].CGColor;
                strokeAnim.toValue           = (id) [UIColor clearColor].CGColor;
                strokeAnim.duration          = 1.0;
                strokeAnim.repeatCount       = HUGE_VAL;
                strokeAnim.autoreverses      = NO;
                [cilrclLayer addAnimation:strokeAnim forKey:@"animateStrokeColor"];
            }
            i++;
        }
    }
}


- (void)animationDidStart:(CAAnimation *)anim {
    if (circleCounter < circleLayers.count) {
        if (anim == [circleLayers[circleCounter] animationForKey:@"strokeCircleAnimation"]) {
            [circleLayers[circleCounter] setHidden:NO];
            circleCounter++;
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (layerCounter >= layers.count) {
        return;
    }
    CAShapeLayer *lineLayer = layers[layerCounter];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.200;
    
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue   = [NSNumber numberWithFloat:1.0f];
    animation.fillMode = kCAFillModeForwards;
    
    [self.progressView.layer addSublayer:lineLayer];
    [lineLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    layerCounter++;
    
}


- (void)updateConstraints {
//    self.timeView.height = _viewHeight;
//    self.progressView.height = _viewHeight;
    self.progressDescriptionView.height = _viewHeight;
    
    [super updateConstraints];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
