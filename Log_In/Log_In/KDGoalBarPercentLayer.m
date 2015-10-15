

#import "KDGoalBarPercentLayer.h"

#define toRadians(x) ((x)*M_PI / 180.0)
#define toDegrees(x) ((x)*180.0 / M_PI)
//#define innerRadius    65.5  
//#define outerRadius    70.5

@implementation KDGoalBarPercentLayer
@synthesize percent;

-(void)drawInContext:(CGContextRef)ctx {
    [self DrawRight:ctx];
    [self DrawLeft:ctx];
    
}
-(void)DrawRight:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = -toRadians(360 * percent);

    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:87.0/255.0 green:209.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor);
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    CGPathAddRelativeArc(path, NULL, center.x, center.y, 65.5/568.0*ScreenSize.size.height, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, 70.5/568.0*ScreenSize.size.height, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-65.5/568.0*ScreenSize.size.height);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

-(void)DrawLeft:(CGContextRef)ctx {
    CGPoint center = CGPointMake(self.frame.size.width / (2), self.frame.size.height / (2));
    
    CGFloat delta = toRadians(360 * (1-percent));

    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:252.0/255.0 green:55.0/255.0 blue:104.0/255.0 alpha:1.0].CGColor);
    
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextSetAllowsAntialiasing(ctx, YES);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGRect ScreenSize = [[UIScreen mainScreen] bounds];
    CGPathAddRelativeArc(path, NULL, center.x, center.y, 65.5/568.0*ScreenSize.size.height, -(M_PI / 2), delta);
    CGPathAddRelativeArc(path, NULL, center.x, center.y, 70.5/568.0*ScreenSize.size.height, delta - (M_PI / 2), -delta);
    CGPathAddLineToPoint(path, NULL, center.x, center.y-65.5/568.0*ScreenSize.size.height);
    
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    
    CFRelease(path);
}

@end
