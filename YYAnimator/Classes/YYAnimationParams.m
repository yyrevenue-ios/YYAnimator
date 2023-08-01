//
//  YYAnimationParams.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYAnimationParams.h"

@implementation YYAnimatorCustomizedData

- (instancetype)initWithProperty:(YYAnimatorCustomProperty)property values:(NSArray *)values keyTimes:(NSArray *)keyTimes
{
    self = [super init];
    if (self) {
        self.property = property;
        self.values = [values mutableCopy];
        self.keyTimes = [keyTimes mutableCopy];
    }
    return self;
}

- (NSString *)keyPath
{
    switch (self.property) {
        case YYAnimatorCustomPropertyCenter:
            return @"position";
        case YYAnimatorCustomPropertyWidth:
            return @"bounds.size.width";
        case YYAnimatorCustomPropertyHeight:
            return @"bounds.size.height";
        case YYAnimatorCustomPropertYYcale:
            return @"transform.scale";
        case YYAnimatorCustomPropertyAlpha:
            return @"opacity";
        case YYAnimatorCustomPropertyOriginX:
            return @"position.x";
        case YYAnimatorCustomPropertyOriginY:
            return @"position.y";
        case YYAnimatorCustomPropertyRotation:
            return @"transform.rotation.z";
    }
    return @"";
}

@end


@implementation YYAnimationParams

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.moveXY = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.origin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.center = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.frame = CGRectMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
        self.alpha = -1.0;
        self.scale = -1.0;
        self.rotateAngle = CGFLOAT_MAX;
        self.topConstraint = CGFLOAT_MAX;
        self.bottomConstraint = CGFLOAT_MAX;
        self.leftConstraint = CGFLOAT_MAX;
        self.rightConstraint = CGFLOAT_MAX;
        self.leadingConstraint = CGFLOAT_MAX;
        self.trailingConstraint = CGFLOAT_MAX;
        self.centerXConstraint = CGFLOAT_MAX;
        self.centerYConstraint = CGFLOAT_MAX;
        self.originX = CGFLOAT_MAX;
        self.originY = CGFLOAT_MAX;
        self.countingNumberValue = CGFLOAT_MAX;
    }
    return self;
}


- (BOOL)isMoveXYValid
{
    return !CGPointEqualToPoint(self.moveXY, CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

- (BOOL)isOriginValid
{
    return !CGPointEqualToPoint(self.origin, CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

- (BOOL)isSizeValid
{
    return !CGSizeEqualToSize(self.size, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

- (BOOL)isCenterValid
{
    return !CGPointEqualToPoint(self.center, CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

- (BOOL)isFrameValid
{
    return !CGRectEqualToRect(self.frame, CGRectMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX));
}

- (BOOL)isValidPoint:(CGPoint)point
{
    return !CGPointEqualToPoint(self.moveXY, CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX));
}

+ (NSString *)existedKey:(NSArray *)keYY inDictionary:(NSDictionary *)dict
{
    for (NSString *key in keYY) {
        if (dict[key]) {
            return key;
        }
    }
    return nil;
}

+ (UIBezierPath *)bezierFromParam:(id)object option:(YYBezierOption)option
{
    if ([object isKindOfClass:UIBezierPath.class]) {
        return object;
    } else if ([object isKindOfClass:NSArray.class]) {
        NSArray *points = (NSArray *)object;
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint lastPoint = [self pointFromParam:[points firstObject]];
        [path moveToPoint:lastPoint];
        if (option == YYBezierOptionThrough) {
            for (int index = 1; index < points.count; index++) {
                CGPoint curPoint = [self pointFromParam:[points objectAtIndex:index]];
                CGPoint controlP1 = CGPointMake((lastPoint.x + curPoint.x) / 2.0 , lastPoint.y);
                CGPoint controlP2 = CGPointMake((lastPoint.x + curPoint.x) / 2.0 , curPoint.y);
                [path addCurveToPoint:curPoint controlPoint1:controlP1 controlPoint2:controlP2];
                lastPoint = curPoint;
            }
        } else if (option == YYBezierOptionCubic) {
            for (int index = 0; index < ((points.count -1) / 3); index++) {
                CGPoint curPoint = [self pointFromParam:[points objectAtIndex:index * 3 + 3]];
                CGPoint controlP1 = [self pointFromParam:[points objectAtIndex:(index * 3 + 1)]];
                CGPoint controlP2 = [self pointFromParam:[points objectAtIndex:(index * 3 + 2)]];
                [path addCurveToPoint:curPoint controlPoint1:controlP1 controlPoint2:controlP2];
            }
        } else {
            for (int index = 0; index < ((points.count - 1) / 2); index++) {
                CGPoint curPoint = [self pointFromParam:[points objectAtIndex:index * 2 + 2]];
                CGPoint controlP1 = [self pointFromParam:[points objectAtIndex:(index * 2 + 1)]];
                [path addQuadCurveToPoint:curPoint controlPoint:controlP1];
            }
        }
        return path;
    }
    return nil;;
}

+ (CGPoint)pointFromParam:(id)param
{
    if ([param isKindOfClass:NSValue.class]) {
        return [param CGPointValue];
    } else if ([param isKindOfClass:NSString.class]) {
        NSString *string = param;
        NSArray *arr = [string componentsSeparatedByString:@","];
        return CGPointMake([arr.firstObject floatValue], [arr.lastObject floatValue]);
    }
    return CGPointZero;
}


@end

@implementation YYAnimatorCountingNumberData

@end
