
//
//  ShadowView.m
//  系统原生扫码
//
//  Created by 邹 on 16/10/18.
//  Copyright © 2016年 邹. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView ()

@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ShadowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        // 图片下方附上
        self.lineView  = [[UIImageView alloc] init];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self addSubview:self.lineView];
        
    }
    return self;
}

-(void)playAnimation{
    
    [UIView animateWithDuration:2.4 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height + self.showSize.height) / 2, self.showSize.width, 2);
        
    } completion:^(BOOL finished) {
        self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    }];
}
- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.lineView .frame = CGRectMake((self.frame.size.width - self.showSize.width) / 2, (self.frame.size.height - self.showSize.height) / 2, self.showSize.width, 2);
    
    
    if (!_timer) {
        
        [self playAnimation];
        
        /* 自动播放 */
        self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(playAnimation) userInfo:nil repeats:YES];
        
    }
    
}

-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 整体颜色
    CGContextSetRGBFillColor(ctx, 0.15, 0.15, 0.15, 0.6);
    CGContextFillRect(ctx, rect);   //draw the transparent layer
    
    //中间清空矩形框
    CGRect clearDrawRect = CGRectMake((rect.size.width - self.showSize.width) / 2, (rect.size.height - self.showSize.height) / 2, self.showSize.width, self.showSize.height);
    CGContextClearRect(ctx, clearDrawRect);
    
    //边框
    CGContextStrokeRect(ctx, clearDrawRect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);  //颜色
    CGContextSetLineWidth(ctx, 0.5);             //线宽
    CGContextAddRect(ctx, clearDrawRect);       //矩形
    CGContextStrokePath(ctx);
    
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
    
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect{
    
    float cornerWidth = 4.0;
    
    float cornerLong = 16.0;
    
    //画四个边角 线宽
    CGContextSetLineWidth(ctx, cornerWidth);
    
    //颜色
    CGContextSetRGBStrokeColor(ctx, 83 /255.0, 239/255.0, 111/255.0, 1);//绿色
    
    //左上角
    CGPoint poinsTopLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + cornerLong)};
    
    CGPoint poinsTopLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + cornerWidth/2)};
    
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    
    //左下角
    CGPoint poinsBottomLeftA[] = {CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height - cornerLong),
        CGPointMake(rect.origin.x + cornerWidth/2, rect.origin.y + rect.size.height)};
    
    CGPoint poinsBottomLeftB[] = {CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + cornerLong, rect.origin.y + rect.size.height - cornerWidth/2)};
    
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    
    //右上角
    CGPoint poinsTopRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + cornerWidth/2 )};
    
    CGPoint poinsTopRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y),
        CGPointMake(rect.origin.x + rect.size.width- cornerWidth/2, rect.origin.y + cornerLong)};
    
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerWidth/2, rect.origin.y+rect.size.height - cornerLong),
        CGPointMake(rect.origin.x- cornerWidth/2 + rect.size.width, rect.origin.y +rect.size.height )};
    
    CGPoint poinsBottomRightB[] = {CGPointMake(rect.origin.x+ rect.size.width - cornerLong, rect.origin.y + rect.size.height - cornerWidth/2),
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - cornerWidth/2 )};
    
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    
    
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
