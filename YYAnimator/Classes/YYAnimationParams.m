//
//  YYAnimationParams.m
//  YYAnimator
//
//  Created by LinSean on 2022/5/10.
//

#import "YYAnimationParams.h"
#import "UIView+TweenStudio.h"

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
        self.moveX = CGFLOAT_MAX;
        self.moveY = CGFLOAT_MAX;
        self.moveXY = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.origin = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.center = CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX);
        self.frame = CGRectMake(CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX, CGFLOAT_MAX);
        self.width = CGFLOAT_MAX;
        self.height = CGFLOAT_MAX;
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

+ (NSArray *)customizedTimesForKey:(NSString *)key param:(NSDictionary *)customizedParamData animDuration:(NSTimeInterval)duration reverse:(BOOL)reverse
{
    NSString *timeKey = YYATime(key);
    NSArray *resultTimes;
    if ([customizedParamData objectForKey:timeKey]) {
        resultTimes = [YYAnimationParams numValuesFromParam:[customizedParamData objectForKey:timeKey] offset:0 reverse:NO];
    }
    if (!resultTimes && [customizedParamData objectForKey:YYATime]) {
        resultTimes = [YYAnimationParams numValuesFromParam:[customizedParamData objectForKey:YYATime] offset:0 reverse:NO];
    }
    
    if (resultTimes) {
        __block BOOL isPercent = YES;
        [resultTimes enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj floatValue] > 1) {
                isPercent = NO;
                *stop = YES;
            }
        }];
        NSMutableArray *keyTimes = [NSMutableArray arrayWithCapacity:resultTimes.count];
        for (NSNumber *time in resultTimes) {
            CGFloat tmp = (isPercent || duration == 0) ? [time floatValue] : ([time floatValue] / duration);
            if (reverse) {
                [keyTimes insertObject:@(1 - tmp) atIndex:0];
            } else {
                [keyTimes addObject:@(tmp)];
            }
        }
        return keyTimes;
    }
    return nil;
}

+ (NSArray *)numValuesFromParam:(id)object offset:(CGFloat)offset reverse:(BOOL)reverse
{
    if (!object) {
        return nil;
    }
    NSMutableArray *numValues = [NSMutableArray array];
    if ([object isKindOfClass:NSString.class]) {
        object = [(NSString *)object componentsSeparatedByString:@","];
    }
    if ([object isKindOfClass:NSArray.class]) {
        NSArray *values = (NSArray *)object;
        for (int index = 0; index < values.count; index ++) {
            if ([values[index] respondsToSelector:@selector(floatValue)]) {
                if (reverse) {
                    [numValues insertObject:@([values[index] floatValue] + offset) atIndex:0];
                } else {
                    [numValues addObject:@([values[index] floatValue] + offset)];
                }
            }
        }
    }
    return numValues.count > 1 ? numValues : nil;
}

+ (NSArray *)pointValuesFromParam:(id)object offset:(CGPoint)offsetPoint reverse:(BOOL)reverse
{
    if (!object) {
        return nil;
    }
    NSMutableArray *numValues = [NSMutableArray array];
    if ([object isKindOfClass:NSString.class]) {
        object = [(NSString *)object componentsSeparatedByString:@";"];
    }
    if ([object isKindOfClass:NSArray.class]) {
        NSArray *values = (NSArray *)object;
        for (int index = 0; index < values.count; index ++) {
            CGPoint point = [self pointFromParam:values[index]];
            point.x += offsetPoint.x;
            point.y += offsetPoint.y;
            if (reverse) {
                [numValues insertObject:[NSValue valueWithCGPoint:point] atIndex:0];
            } else {
                [numValues addObject:[NSValue valueWithCGPoint:point]];
            }
        }
    }
    return numValues.count > 1 ? numValues : nil;
}

+ (NSArray *)sizeValuesFromParam:(id)object offset:(CGSize)offsetSize reverse:(BOOL)reverse
{
    if (!object) {
        return nil;
    }
    NSMutableArray *numValues = [NSMutableArray array];
    if ([object isKindOfClass:NSString.class]) {
        object = [(NSString *)object componentsSeparatedByString:@";"];
    }
    if ([object isKindOfClass:NSArray.class]) {
        NSArray *values = (NSArray *)object;
        for (int index = 0; index < values.count; index ++) {
            CGSize size = [self sizeFromParam:values[index]];
            size.width += offsetSize.width;
            size.height += offsetSize.height;
            if (reverse) {
                [numValues insertObject:[NSValue valueWithCGSize:size] atIndex:0];
            } else {
                [numValues addObject:[NSValue valueWithCGSize:size]];
            }
        }
    }
    return numValues.count > 1 ? numValues : nil;
}


+ (CGPoint)pointFromParam:(id)object
{
    if ([object isKindOfClass:NSValue.class]) {
        return [object CGPointValue];
    } else if ([object isKindOfClass:NSString.class]) {
        NSString *string = object;
        NSArray *arr = [string componentsSeparatedByString:@","];
        return CGPointMake([arr.firstObject floatValue], [arr.lastObject floatValue]);
    }
    return CGPointZero;
}


+ (CGSize)sizeFromParam:(id)object
{
    if ([object isKindOfClass:NSValue.class]) {
        return [object CGSizeValue];
    } else if ([object isKindOfClass:NSString.class]) {
        NSString *string = object;
        NSArray *arr = [string componentsSeparatedByString:@","];
        return CGSizeMake([arr.firstObject floatValue], [arr.lastObject floatValue]);
    }
    return CGSizeZero;
}


@end

@implementation YYAnimatorCountingNumberData

@end
