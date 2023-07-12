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

@end

@implementation YYAnimatorCountingNumberData

@end
