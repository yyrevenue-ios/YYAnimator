//
//  YYAnimatorExtension.swift
//  YYAnimator
//
//  Created by LinSean on 2022/10/14.
//

import Foundation

public struct YYAnimatorExtension {
    private let view: UIView
    var animator: YYAnimator
    var isProducing: Bool
    
    public init(_ view: UIView) {
        self.view = view
        self.isProducing = false
        self.animator = YYAnimator(view: view)
    }
    
    public mutating func addAnimation(_ duration: Double, _ params: YYAnimationParams) {
        if self.isProducing {
            self.animator.createNewGroup()
        } else {
            self.animator.createOneAnimation(withDuration: duration)
        }
        self.isProducing = true
        self.animator.updateCurrentAnimationDuration(duration)
        self.animator.updateCurrentAnimationIsReverse(false)
        self.animator.addAnimation(with: params)
    }
    
    public mutating func addNextAnimation(_ duration: Double, _ delay: Double, _ params: YYAnimationParams) {
        self.animator.createNewGroup()
        self.animator.updateCurrentAnimationDuration(duration)
        if (delay > 0) {
            self.animator.updateCurrentAnimationDelay(delay)
        }
        self.animator.updateCurrentAnimationIsReverse(false)
        self.animator.addAnimation(with: params)
    }
    
    public mutating func runAnimation(_ duration: Double, _ params: YYAnimationParams, _ isReverse: Bool) {
        self.animator.createOneAnimation(withDuration: duration);
        self.animator.updateCurrentAnimationIsReverse(false);
        self.animator.addAnimation(with: params)
        self.playAnimations()
    }
    
    public mutating func playAnimations() {
        self.isProducing = false
        self.animator.play()
    }
}

public extension UIView {
    private struct AssociatedKey {
        static var identifier: String = "YYAniamtionId"
    }
    
    var yya: YYAnimatorExtension {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKey.identifier) as? YYAnimatorExtension ?? nil {
                return obj
            } else {
                let obj = YYAnimatorExtension(self)
                obj.animator.finalCompeltion = { [weak self] in
                    self?.removeExtension()
                }
                objc_setAssociatedObject(self, &AssociatedKey.identifier, obj, .OBJC_ASSOCIATION_COPY_NONATOMIC)
                return obj
            }
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.identifier, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func removeExtension() {
        objc_setAssociatedObject(self, &AssociatedKey.identifier, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}
