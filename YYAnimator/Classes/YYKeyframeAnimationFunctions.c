//
//  YYKeyframeAnimationFunctions.c
//  LSAnimator
//
//  Created by LinSean on 2022/5/10.
//

#include "YYKeyframeAnimationFunctions.h"
#include <math.h>
#include <stdlib.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"

// t: current time, b: begInnIng value, c: change In value, d: duration
double YYKeyframeAnimationFunctionLinear(double t, double b, double c, double d) {
    return c*(t/=d) + b;
}

double YYKeyframeAnimationFunctionEaseIn(double t, double b, double c, double d) {
    return c*(t/=d)*t + b;
}

double YYKeyframeAnimationFunctionEaseOut(double t, double b, double c, double d) {
    return -c *(t/=d)*(t-2) + b;
}

double YYKeyframeAnimationFunctionEaseInOut(double t, double b, double c, double d) {
    if ((t/=d/2) < 1) return c/2*t*t + b;
    return -c/2 * ((--t)*(t-2) - 1) + b;
}

double YYKeyframeAnimationFunctionEaseOutBack(double t, double b, double c, double d) {
    const double s = 1.70158;
    return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
}

double YYKeyframeAnimationFunctionEaseOutElastic(double t, double b, double c, double d) {
    double s=1.70158, p=0, a=c;
    if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
    if (a < fabs(c)) { a=c; s=p/4; }
    else s = p/(2*M_PI) * asin (c/a);
    return a*pow(2,-10*t) * sin( (t*d-s)*(2*M_PI)/p ) + c + b;
}

double YYKeyframeAnimationFunctionEaseOutBounce(double t, double b, double c, double d) {
    if ((t/=d) < (1/2.75)) {
        return c*(7.5625*t*t) + b;
    } else if (t < (2/2.75)) {
        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
    } else if (t < (2.5/2.75)) {
        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
    } else {
        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
    }
}

#pragma clang diagnostic pop
