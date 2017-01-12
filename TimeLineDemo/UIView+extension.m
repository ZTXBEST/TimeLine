//
//  UIView+extension.m
//  ProjectFramework
//
//  Created by Glife on 16/3/2.
//  Copyright © 2016年 Glife. All rights reserved.
//
#import "UIView+extension.h"

@implementation UIView (extension)
//top
-(void)setTop:(CGFloat)top{
    CGRect frame=self.frame;
    if (self.frame.origin.y==top) {
        return;
    }
    frame.origin=CGPointMake(frame.origin.x, top);
    self.frame=frame;
}

-(CGFloat)top{
    return self.frame.origin.y;
}

//bottom
-(void)setBottom:(CGFloat)bottom{
    CGRect frame=self.frame;
    if (self.frame.origin.y+self.frame.size.height==bottom) {
        return;
    }
    frame.origin=CGPointMake(frame.origin.x, bottom-self.frame.size.height);
    self.frame=frame;
}

-(CGFloat)bottom{
    return self.frame.origin.y+self.frame.size.height;
}

//left
-(void)setLeft:(CGFloat)left{
    CGRect frame=self.frame;
    if (self.frame.origin.x==left) {
        return;
    }
    frame.origin=CGPointMake(left,self.frame.origin.y);
    self.frame=frame;
}

-(CGFloat)left{
    return self.frame.origin.x;
}

//right
-(void)setRight:(CGFloat)right{
    CGRect frame=self.frame;
    if (self.frame.origin.x+self.frame.size.width==right) {
        return;
    }
    frame.origin=CGPointMake(right-self.frame.size.width,self.frame.origin.y);
    self.frame=frame;
}

-(CGFloat)right{
    return self.frame.origin.x+self.frame.size.width;
}

//x
-(void)setX:(CGFloat)x{
    CGRect frame=self.frame;
    if (self.frame.origin.x==x) {
        return;
    }
    frame.origin=CGPointMake(x, frame.origin.y);
    self.frame=frame;
}

-(CGFloat)x{
    return self.frame.origin.x;
}

//y
-(void)setY:(CGFloat)y{
    CGRect frame=self.frame;
    if (self.frame.origin.y==y) {
        return;
    }
    frame.origin=CGPointMake(frame.origin.x, y);
    self.frame=frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}

//width
-(void)setWidth:(CGFloat)width{
    CGRect frame=self.frame;
    if (self.frame.size.width==width) {
        return;
    }
    frame.size=CGSizeMake(width, frame.size.height);
    self.frame=frame;
}

-(CGFloat)width{
    return self.bounds.size.width;
}

//height
-(void)setHeight:(CGFloat)height{
    CGRect frame=self.frame;
    if (self.frame.size.height==height) {
        return;
    }
    frame.size=CGSizeMake(frame.size.width, height);
    self.frame=frame;
}

-(CGFloat)height{
    return self.bounds.size.height;
}

//size
-(void)setSize:(CGSize)size{
    CGRect frame=self.frame;
    if (CGSizeEqualToSize(frame.size, size)) {
        return;
    }
    frame.size=size;
    self.frame=frame;
}

-(CGSize)size{
    return self.bounds.size;
}

//leftTop
-(void)setLeftTop:(CGPoint)leftTop{
    if (CGPointEqualToPoint(self.frame.origin, leftTop)) {
        return;
    }
    CGRect frame=self.frame;
    frame.origin=leftTop;
    self.frame=frame;
}

-(CGPoint)leftTop{
    return self.frame.origin;
}

//leftCenter
-(void)setLeftCenter:(CGPoint)leftCenter{
    CGPoint leftTop=self.leftTop;
    leftTop.x=leftCenter.x;
    leftTop.y=leftCenter.y-self.height/2.0;
    [self setLeftTop:leftTop];
}

-(CGPoint)leftCenter{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y+self.height/2.0);
}

//leftBottom
-(void)setLeftBottom:(CGPoint)leftBottom{
    CGPoint leftTop=self.leftTop;
    leftTop.x=leftBottom.x;
    leftTop.y=leftBottom.y-self.height;
    [self setLeftTop:leftTop];
}

-(CGPoint)leftBottom{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y+self.height);
}

//topCenter
-(void)setTopCenter:(CGPoint)topCenter{
    CGPoint leftTop=self.leftTop;
    leftTop.x=topCenter.x-self.width/2.0;
    leftTop.y=topCenter.y;
    [self setLeftTop:leftTop];
}

-(CGPoint)topCenter{
    return CGPointMake(self.frame.origin.x+self.width/2.0, self.frame.origin.y);
}

//bottomCenter
-(void)setBottomCenter:(CGPoint)bottomCenter{
    CGPoint leftTop=self.leftTop;
    leftTop.x=bottomCenter.x-self.width/2.0;
    leftTop.y=bottomCenter.y-self.height;
    [self setLeftTop:leftTop];
}

-(CGPoint)bottomCenter{
    return CGPointMake(self.frame.origin.x+self.width/2.0, self.frame.origin.y+self.height);
}

//rightTop
-(void)setRightTop:(CGPoint)rightTop{
    CGPoint leftTop=self.leftTop;
    leftTop.x=rightTop.x-self.width;
    leftTop.y=rightTop.y;
    [self setLeftTop:leftTop];
}

-(CGPoint)rightTop{
    return CGPointMake(self.frame.origin.x+self.width, self.frame.origin.y);
}

//rightCenter
-(void)setRightCenter:(CGPoint)rightCenter{
    CGPoint leftTop=self.leftTop;
    leftTop.x=rightCenter.x-self.width;
    leftTop.y=rightCenter.y-self.height/2.0;
    [self setLeftTop:leftTop];
}

-(CGPoint)rightCenter{
    return CGPointMake(self.frame.origin.x+self.width, self.frame.origin.y+self.height/2.0);
}

//rightBottom
-(void)setRightBottom:(CGPoint)rightBottom{
    CGPoint leftTop=self.leftTop;
    leftTop.x=rightBottom.x-self.width;
    leftTop.y=rightBottom.y-self.height;
    [self setLeftTop:leftTop];
}

-(CGPoint)rightBottom{
    return CGPointMake(self.frame.origin.x+self.width, self.frame.origin.y+self.height);
}

//Top的圆角
- (void)drawBorderWithTopCorner:(UIView *)view withCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//Bottom的圆角
- (void)drawBorderWithBottomCorner:(UIView *)view withCornerRadius:(CGFloat)radius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//drawBorder
-(void)drawBorder:(CGFloat)width color:(UIColor *)color{
    if (color==nil) {
        color=[UIColor redColor];
    }
    else if (width==0){
        width=1.0;
    }
    self.layer.borderWidth =width;
    self.layer.borderColor=color.CGColor;
}

//debugWithColor
-(void)debugWithColor:(UIColor *)color{
    [self drawBorder:1.0 color:color];
}

-(UILabel *)addLable:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    UILabel *lable=[[UILabel alloc]init];
    lable.text=text;
    lable.font=font;
    lable.textColor=color;
    [lable sizeToFit];
    [self addSubview:lable];
    return lable;
}


- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"\n leftTop:%@\n leftCenter:%@\n leftBottom:%@\n topCenter:%@\n bottomCenter:%@\n rightTop:%@\n rightCenter:%@\n rightBottom:%@\n",NSStringFromCGPoint(self.leftTop),NSStringFromCGPoint(self.leftCenter),NSStringFromCGPoint(self.leftBottom),NSStringFromCGPoint(self.topCenter),NSStringFromCGPoint(self.bottomCenter),NSStringFromCGPoint(self.rightTop),NSStringFromCGPoint(self.rightCenter),NSStringFromCGPoint(self.rightBottom)];
}


-(id)copyWithZone:(NSZone *)zone{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}
@end
