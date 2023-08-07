//
//  YYAnimatorDictInterface.swift
//  YYAnimator
//
//  Created by LinSean on 2022/10/15.
//

import Foundation

extension YYAnimatorExtension {
    
    public mutating func from(_ duration: Double, _ params: [YYAnimator.ParamKey: Any]) {
        let animationParams = self.produceAnimationParams(params)
        self.runAnimation(duration, animationParams, true)
    }

    public mutating func to(_ duration: Double, _ params: [YYAnimator.ParamKey: Any]) {
        let animationParams = self.produceAnimationParams(params)
        self.runAnimation(duration, animationParams, false)
    }
    
    public mutating func add(_ duration: Double, _ params: [YYAnimator.ParamKey: Any]) {
        let animationParams = self.produceAnimationParams(params)
        self.addAnimation(duration, animationParams)
    }
    
    public mutating func then(_ duration: Double, _ params: [YYAnimator.ParamKey: Any]) {
        let animationParams = self.produceAnimationParams(params)
        self.addNextAnimation(duration, 0, animationParams)
    }
    
    public mutating func thenAfter(_ duration: Double, _ delay: Double, _ params: [YYAnimator.ParamKey: Any]) {
        let animationParams = self.produceAnimationParams(params)
        self.addNextAnimation(duration, delay, animationParams)
    }
    
    private func produceAnimationParams(_ params: [YYAnimator.ParamKey: Any]) -> YYAnimationParams {
        let animationParams = YYAnimationParams()
        var customizedDict = [String: Any]()
        customizedDict[YYAnimator.ParamKey.time.rawValue] = params[YYAnimator.ParamKey.time]
        
        switch params[.moveX] {
        case let intMoveX as Int:
            animationParams.moveX = Double(intMoveX)
        case let doubleMoveX as Double:
            animationParams.moveX = doubleMoveX
        case let doubleMoveX as Array<Any>:
            customizedDict[YYAnimator.ParamKey.moveX.rawValue] = doubleMoveX
        case let doubleMoveX as String:
            customizedDict[YYAnimator.ParamKey.moveX.rawValue] = doubleMoveX
        default:
            ()
        }
        
        switch params[.moveY] {
        case let intMoveY as Int:
            animationParams.moveY = Double(intMoveY)
        case let doubleMoveY as Double:
            animationParams.moveY = doubleMoveY
        case let doubleMoveY as Array<Any>:
            customizedDict[YYAnimator.ParamKey.moveY.rawValue] = doubleMoveY
        case let doubleMoveY as String:
            customizedDict[YYAnimator.ParamKey.moveY.rawValue] = doubleMoveY
        default:
            ()
        }
        
        if let moveXY = params[.moveXY] as? CGPoint {
            animationParams.moveXY = moveXY
        }
        if let moveXY = params[.moveXY] as? Array<Any> {
            customizedDict[YYAnimator.ParamKey.moveXY.rawValue] = moveXY
        }
        if let moveXY = params[.moveXY] as? String {
            customizedDict[YYAnimator.ParamKey.moveXY.rawValue] = moveXY
        }
        
        switch params[.originX] {
        case let intOriginX as Int:
            animationParams.originX = Double(intOriginX)
        case let doubleOriginX as Double:
            animationParams.originX = doubleOriginX
        case let doubleOriginX as Array<Any>:
            customizedDict[YYAnimator.ParamKey.originX.rawValue] = doubleOriginX
        case let doubleOriginX as String:
            customizedDict[YYAnimator.ParamKey.originX.rawValue] = doubleOriginX
        default:
            ()
        }
        
        switch params[.originY] {
        case let intOriginY as Int:
            animationParams.originY = Double(intOriginY)
        case let doubleOriginY as Double:
            animationParams.originY = doubleOriginY
        case let doubleOriginY as Array<Any>:
            customizedDict[YYAnimator.ParamKey.originY.rawValue] = doubleOriginY
        case let doubleOriginY as String:
            customizedDict[YYAnimator.ParamKey.originX.rawValue] = doubleOriginY
        default:
            ()
        }
        
        if let origin = params[.origin] as? CGPoint {
            animationParams.origin = origin
        }
        if let origin = params[.origin] as? Array<Any> {
            customizedDict[YYAnimator.ParamKey.origin.rawValue] = origin
        }
        if let origin = params[.origin] as? String {
            customizedDict[YYAnimator.ParamKey.origin.rawValue] = origin
        }

        if let size = params[.size] as? CGSize {
            animationParams.size = size
        }
        if let size = params[.size] as? Array<Any> {
            customizedDict[YYAnimator.ParamKey.size.rawValue] = size
        }
        if let size = params[.size] as? String {
            customizedDict[YYAnimator.ParamKey.size.rawValue] = size
        }
        
        if let center = params[.center] as? CGPoint {
            animationParams.center = center
        }
        if let center = params[.center] as? Array<Any> {
            customizedDict[YYAnimator.ParamKey.center.rawValue] = center
        }
        if let center = params[.center] as? String {
            customizedDict[YYAnimator.ParamKey.center.rawValue] = center
        }
        
        if let customizedData = params[.customizedData] as? YYAnimatorCustomizedData {
            animationParams.customizedData = customizedData
        }

        if let frame = params[.frame] as? CGRect {
            animationParams.frame = frame
        }

        switch params[.rotateAngle] {
        case let intAngle as Int:
            animationParams.rotateAngle = Double(intAngle)
        case let doubleAngle as Double:
            animationParams.rotateAngle = doubleAngle
        case let doubleAngle as Array<Any>:
            customizedDict[YYAnimator.ParamKey.rotateAngle.rawValue] = doubleAngle
        case let doubleAngle as String:
            customizedDict[YYAnimator.ParamKey.rotateAngle.rawValue] = doubleAngle
        default:
            ()
        }

        switch params[.alpha] {
        case let intAlpha as Int:
            animationParams.alpha = Double(intAlpha)
        case let doubleAlpha as Double:
            animationParams.alpha = doubleAlpha
        case let doubleAlpha as Array<Any>:
            customizedDict[YYAnimator.ParamKey.alpha.rawValue] = doubleAlpha
        case let doubleAlpha as String:
            customizedDict[YYAnimator.ParamKey.alpha.rawValue] = doubleAlpha
        default:
            ()
        }
    
        switch params[.scale] {
        case let intScale as Int:
            animationParams.scale = Double(intScale)
        case let doubleScale as Double:
            animationParams.scale = doubleScale
        case let doubleScale as Array<Any>:
            customizedDict[YYAnimator.ParamKey.scale.rawValue] = doubleScale
        case let doubleScale as String:
            customizedDict[YYAnimator.ParamKey.scale.rawValue] = doubleScale
        default:
            ()
        }
        
        if let repeats = params[.repeats] as? UInt {
            animationParams.repeat = repeats
        }

        switch params[.delay] {
        case let intDelay as Int:
            animationParams.delay = Double(intDelay)
        case let doubleDelay as Double:
            animationParams.delay = doubleDelay
        default:
            ()
        }
        
        switch params[.width] {
        case let intWidth as Int:
            animationParams.width = Double(intWidth)
        case let doubleWidth as Double:
            animationParams.width = doubleWidth
        case let doubleWidth as Array<Any>:
            customizedDict[YYAnimator.ParamKey.width.rawValue] = doubleWidth
        case let doubleWidth as String:
            customizedDict[YYAnimator.ParamKey.width.rawValue] = doubleWidth
        default:
            ()
        }

        switch params[.addWidth] {
        case let intWidth as Int:
            animationParams.adjustWidth = Double(intWidth)
        case let doubleWidth as Double:
            animationParams.adjustWidth = doubleWidth
        case let doubleWidth as Array<Any>:
            customizedDict[YYAnimator.ParamKey.addWidth.rawValue] = doubleWidth
        case let doubleWidth as String:
            customizedDict[YYAnimator.ParamKey.addWidth.rawValue] = doubleWidth
        default:
            ()
        }
        
        switch params[.height] {
        case let intHeight as Int:
            animationParams.height = Double(intHeight)
        case let doubleHeight as Double:
            animationParams.height = doubleHeight
        case let doubleHeight as Array<Any>:
            customizedDict[YYAnimator.ParamKey.height.rawValue] = doubleHeight
        case let doubleHeight as String:
            customizedDict[YYAnimator.ParamKey.height.rawValue] = doubleHeight
        default:
            ()
        }
        
        switch params[.addHeight] {
        case let intHeight as Int:
            animationParams.adjustHeight = Double(intHeight)
        case let doubleHeight as Double:
            animationParams.adjustHeight = doubleHeight
        case let doubleHeight as Array<Any>:
            customizedDict[YYAnimator.ParamKey.addHeight.rawValue] = doubleHeight
        case let doubleHeight as String:
            customizedDict[YYAnimator.ParamKey.addHeight.rawValue] = doubleHeight
        default:
            ()
        }
        
        switch params[.damping] {
        case let intDamping as Int:
            animationParams.springDamping = Double(intDamping)
        case let doubleDamping as Double:
            animationParams.springDamping = doubleDamping
        default:
            ()
        }
        
        switch params[.initialVelocity] {
        case let intVelocity as Int:
            animationParams.springVelocity = Double(intVelocity)
        case let doubleVelocity as Double:
            animationParams.springVelocity = doubleVelocity
        default:
            ()
        }
        
        switch params[.topConstraint] {
        case let intTopConstant as Int:
            animationParams.topConstraint = Double(intTopConstant)
        case let doubleTopConstant as Double:
            animationParams.topConstraint = doubleTopConstant
        default:
            ()
        }
        
        switch params[.bottomConstraint] {
        case let intBottomConstant as Int:
            animationParams.bottomConstraint = Double(intBottomConstant)
        case let doubleBottomConstant as Double:
            animationParams.bottomConstraint = doubleBottomConstant
        default:
            ()
        }
        
        switch params[.leftConstraint] {
        case let intLeftConstant as Int:
            animationParams.leftConstraint = Double(intLeftConstant)
        case let doubleLeftConstant as Double:
            animationParams.leftConstraint = doubleLeftConstant
        default:
            ()
        }
        
        switch params[.rightConstraint] {
        case let intRightConstant as Int:
            animationParams.rightConstraint = Double(intRightConstant)
        case let doubleRightConstant as Double:
            animationParams.rightConstraint = doubleRightConstant
        default:
            ()
        }
        
        switch params[.leadingConstraint] {
        case let intLeadingConstant as Int:
            animationParams.leadingConstraint = Double(intLeadingConstant)
        case let doubleLeadingConstant as Double:
            animationParams.leadingConstraint = doubleLeadingConstant
        default:
            ()
        }
        
        switch params[.trailingConstraint] {
        case let intTrailingConstant as Int:
            animationParams.trailingConstraint = Double(intTrailingConstant)
        case let doubleTrailingConstant as Double:
            animationParams.trailingConstraint = doubleTrailingConstant
        default:
            ()
        }
        
        switch params[.widthConstraint] {
        case let intWidthConstant as Int:
            animationParams.widthConstraint = Double(intWidthConstant)
        case let doubleWidthConstant as Double:
            animationParams.widthConstraint = doubleWidthConstant
        default:
            ()
        }
        
        switch params[.heightConstraint] {
        case let intHeightConstant as Int:
            animationParams.heightConstraint = Double(intHeightConstant)
        case let doubleHeightConstant as Double:
            animationParams.heightConstraint = doubleHeightConstant
        default:
            ()
        }
        
        switch params[.centerXConstraint] {
        case let intCenterXConstant as Int:
            animationParams.centerXConstraint = Double(intCenterXConstant)
        case let doubleCenterXConstant as Double:
            animationParams.centerXConstraint = doubleCenterXConstant
        default:
            ()
        }
        
        switch params[.centerYConstraint] {
        case let intCenterYConstant as Int:
            animationParams.centerYConstraint = Double(intCenterYConstant)
        case let doubleCenterYConstant as Double:
            animationParams.centerYConstraint = doubleCenterYConstant
        default:
            ()
        }
        
        if let springOptions = params[.springOptions] as? UInt {
            animationParams.springOptions = springOptions
        }
        
        if let anchor = params[.anchor] as? YYAnimationAnchor {
            animationParams.anchor = anchor
        }

        if let option = params[.animationOption] as? YYAnimationOption {
            animationParams.animationOption = option
        }

        if let preHandleBlock = params[.preAnimationBlock] as? ()->Void {
            animationParams.preAnimationBlock = preHandleBlock
        }

        if let postHandleBlock = params[.postAnimationBlock] as? ()->Void {
            animationParams.postAnimationBlock = postHandleBlock
        }
        
        if let countingNumberData = params[.countingNumberData] as? YYAnimatorCountingNumberData {
            animationParams.countingNumberData = countingNumberData
        }
        
        switch params[.countingNumberValue] {
        case let intCountingNumberValue as Int:
            animationParams.countingNumberValue = Double(intCountingNumberValue)
        case let doubleCountingNumberValue as Double:
            animationParams.countingNumberValue = doubleCountingNumberValue
        default:
            ()
        }
        if customizedDict.count > 0 {
            animationParams.customizedParamData = customizedDict
        }
        return animationParams
    }
    
}

extension YYAnimator {
    public struct ParamKey: Hashable, Equatable, RawRepresentable {
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        public var rawValue: String
    }
}

extension YYAnimator.ParamKey {
    public static let time: YYAnimator.ParamKey = .init(rawValue: "time")
    // 水平位移
    public static let moveX: YYAnimator.ParamKey = .init(rawValue: "moveX")
    // 垂直位移
    public static let moveY: YYAnimator.ParamKey = .init(rawValue: "moveY")
    // 水平&垂直位移
    public static let moveXY: YYAnimator.ParamKey = .init(rawValue: "moveXY")
    // originX
    public static let originX: YYAnimator.ParamKey = .init(rawValue: "originX")
    // originY
    public static let originY: YYAnimator.ParamKey = .init(rawValue: "originY")
    // origin
    public static let origin: YYAnimator.ParamKey = .init(rawValue: "origin")
    // size
    public static let size: YYAnimator.ParamKey = .init(rawValue: "size")
    // center
    public static let center: YYAnimator.ParamKey = .init(rawValue: "center")
    // 自定义center
    public static let customizedData: YYAnimator.ParamKey = .init(rawValue: "customizedData")
    // frame - 为支持动画的平滑移动，frame的origin会根据size进行调整
    public static let frame: YYAnimator.ParamKey = .init(rawValue: "frame")
    // 旋转角度
    public static let rotateAngle: YYAnimator.ParamKey = .init(rawValue: "rotateAngle")
    // 透明度
    public static let alpha: YYAnimator.ParamKey = .init(rawValue: "alpha")
    // 放大倍数
    public static let scale: YYAnimator.ParamKey = .init(rawValue: "scale")
    // 重复次数
    public static let repeats: YYAnimator.ParamKey = .init(rawValue: "repeats")
    // 延迟执行时间
    public static let delay: YYAnimator.ParamKey = .init(rawValue: "delay")
    // 宽度
    public static let width: YYAnimator.ParamKey = .init(rawValue: "width")
    // 高度
    public static let height: YYAnimator.ParamKey = .init(rawValue: "height")
    // 增加或减少宽度
    public static let addWidth: YYAnimator.ParamKey = .init(rawValue: "addWidth")
    // 增加或减少高度
    public static let addHeight: YYAnimator.ParamKey = .init(rawValue: "addHeight")
    // 弹性参数damping
    public static let damping: YYAnimator.ParamKey = .init(rawValue: "damping")
    // 弹性参数intialVelocity
    public static let initialVelocity: YYAnimator.ParamKey = .init(rawValue: "initialVelocity")
    // 弹性参数options
    public static let springOptions: YYAnimator.ParamKey = .init(rawValue: "springOptions")
    // 动画开始前回调
    public static let preAnimationBlock: YYAnimator.ParamKey = .init(rawValue: "preAnimationBlock")
    // 动画结束后回调
    public static let postAnimationBlock: YYAnimator.ParamKey = .init(rawValue: "postAnimationBlock")
    // 动画过程控制
    public static let animationOption: YYAnimator.ParamKey = .init(rawValue: "animationOption")
    // 顶部约束
    public static let topConstraint: YYAnimator.ParamKey = .init(rawValue: "topConstraint")
    // 低部约束
    public static let bottomConstraint: YYAnimator.ParamKey = .init(rawValue: "bottomConstraint")
    // 左边约束
    public static let leftConstraint: YYAnimator.ParamKey = .init(rawValue: "leftConstraint")
    // 右边约束
    public static let rightConstraint: YYAnimator.ParamKey = .init(rawValue: "rightConstraint")
    // 前边约束
    public static let leadingConstraint: YYAnimator.ParamKey = .init(rawValue: "leadingConstraint")
    // 后边约束
    public static let trailingConstraint: YYAnimator.ParamKey = .init(rawValue: "trailingConstraint")
    // 宽度约束
    public static let widthConstraint: YYAnimator.ParamKey = .init(rawValue: "widthConstraint")
    // 高度约束
    public static let heightConstraint: YYAnimator.ParamKey = .init(rawValue: "heightConstraint")
    // centerX约束
    public static let centerXConstraint: YYAnimator.ParamKey = .init(rawValue: "centerXConstraint")
    // centerY约束
    public static let centerYConstraint: YYAnimator.ParamKey = .init(rawValue: "centerYConstraint")
    // 锚点
    public static let anchor: YYAnimator.ParamKey = .init(rawValue: "anchor")
    // 数字动画对象
    public static let countingNumberData: YYAnimator.ParamKey = .init(rawValue: "countingNumberData")
    // 数字动画目标value
    public static let countingNumberValue: YYAnimator.ParamKey = .init(rawValue: "countingNumberValue")
    
}
