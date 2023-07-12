//
//  YYKeyframeAnimationFunctions.h
//  LSAnimator
//
//  Created by LinSean on 2022/5/10.
//

#ifndef YYKeyframeAnimationFunctions_h
#define YYKeyframeAnimationFunctions_h

typedef double (*YYKeyframeAnimationFunction)(double, double, double, double);

double YYKeyframeAnimationFunctionLinear(double t, double b, double c, double d);

double YYKeyframeAnimationFunctionEaseIn(double t, double b, double c, double d);
double YYKeyframeAnimationFunctionEaseOut(double t, double b, double c, double d);
double YYKeyframeAnimationFunctionEaseInOut(double t, double b, double c, double d);

double YYKeyframeAnimationFunctionEaseOutBack(double t, double b, double c, double d);
double YYKeyframeAnimationFunctionEaseOutElastic(double t, double b, double c, double d);
double YYKeyframeAnimationFunctionEaseOutBounce(double t, double b, double c, double d);

#endif /* YYKeyframeAnimationFunctions_h */
