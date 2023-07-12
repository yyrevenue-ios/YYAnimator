//
//  YYTestViewController.swift
//  YYAnimator_Example
//
//  Created by yezhicheng on 2022/10/8.
//  Copyright © 2022 8474644. All rights reserved.
//

import UIKit
import YYAnimator

class YYTestViewController: UIViewController {
    
    var viewAnimatorBtn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var animationView = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    var label = UILabel(frame: CGRect(x: 160, y: 500, width: 70, height: 70))
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.configBtn()
        animationView.backgroundColor = UIColor.yellow;
        animationView.frame = CGRect(x: 160, y: 320, width: 70, height: 70)
         label.text = "3"
         label.backgroundColor = UIColor.red;
         self.view.addSubview(label)
        self.view.addSubview(animationView)
    }
    
    func configBtn() {
        viewAnimatorBtn.frame = CGRect(x: 0, y: self.view.bounds.size.height - 83, width: self.view.bounds.size.width, height: 83)
        viewAnimatorBtn.backgroundColor = UIColor.yellow
        viewAnimatorBtn.setTitle("StartAnimation", for: UIControlState.normal)
        viewAnimatorBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        self.view.addSubview(viewAnimatorBtn)
        viewAnimatorBtn.addTarget(self, action: #selector(self.viewAnimatorBtnDidClicked), for: UIControlEvents.touchUpInside)
    }
    
    @objc
    func viewAnimatorBtnDidClicked() {
//        animationView.yya.to(2, [.center: CGPoint(x: 300, y: 300), .scale: 2])
//        animationView.yya.to(2, [.repeats:1, .delay:3, .center: CGPoint(x: 300, y: 300), .scale: 2])
         animationView.yya.from(1, [.scale : 3])
         
         let data = YYAnimatorCountingNumberData()
         data.fromValue = 0
         data.toValue = 100
         let showNumLength = 3
         data.numberFormatBlock = {(numberValue: Double) -> String in
              let value = ceilf(powf(10, Float(showNumLength)) * Float(numberValue))
              return String(format: "%0.3f", value / powf(10, Float(showNumLength)))
         }
         label.yya.to(10, [.countingNumberData : data])
    }
}


