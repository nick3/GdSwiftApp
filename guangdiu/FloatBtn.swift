//
//  FloatBtn.swift
//  guangdiu
//
//  Created by Nick on 15/3/19.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit
import Spring

class FloatBtn: SpringButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

  func configBtn() {
    layer.cornerRadius = 18
    layer.borderWidth = 1
    let borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    layer.borderColor = borderColor.CGColor
    layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.3).CGColor
    layer.shadowOffset = CGSizeMake(0, 1)
    layer.shadowRadius = 2
    layer.shadowOpacity = 1
    hidden = true
  }
  
  override init() {
    super.init()
    configBtn()
  }

  required override init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configBtn()
  }
  
  func show(duration: CGFloat = 1.0, delay: CGFloat = 0.0) {
    hidden = false
    animation = "fadeInUp"
    curve = "spring"
    self.duration = duration
    self.delay = delay
    animate()
  }
}
