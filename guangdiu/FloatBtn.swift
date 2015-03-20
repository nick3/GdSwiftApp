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
    layer.cornerRadius = 22
    layer.borderWidth = 1
    let borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    layer.borderColor = borderColor.CGColor
    layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.3).CGColor
    layer.shadowOffset = CGSizeMake(0, 1)
    layer.shadowRadius = 2
    layer.shadowOpacity = 1
    addTarget(self, action: "onTouchDown:", forControlEvents: .TouchDown)
    addTarget(self, action: "onTouchUp:", forControlEvents: .TouchUpInside)
    hidden = true
  }
  
  deinit {
    removeTarget(self, action: "onTouchUp:", forControlEvents: .TouchUpInside)
    removeTarget(self, action: "onTouchDown:", forControlEvents: .TouchDown)
  }
  
  override init() {
    super.init()
    configBtn()
  }

  required override init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configBtn()
  }
  
  func onTouchDown(sender: FloatBtn) {
    UIView.animateWithDuration(NSTimeInterval(0.1), animations: { () -> Void in
      self.layer.shadowOffset = CGSizeMake(0, 0)
      self.layer.shadowOpacity = 0
      let translate = CGAffineTransformMakeTranslation(0, 2)
      self.transform = translate
    })
  }
  
  func onTouchUp(sender: FloatBtn) {
    UIView.animateWithDuration(NSTimeInterval(0.1), animations: { () -> Void in
      self.layer.shadowOffset = CGSizeMake(0, 1)
      self.layer.shadowOpacity = 1
      let translate = CGAffineTransformMakeTranslation(0, 0)
      self.transform = translate
    })
  }
  
  func show(duration: CGFloat = 1.0, delay: CGFloat = 0.0, complete: () -> ()) {
    hidden = false
    animation = "fadeInUp"
    curve = "easeInBack"
    x = 0
    y = 0
    self.duration = duration
    self.delay = delay
    animateNext(complete)
  }
  
  func hide(duration: CGFloat = 1.0, delay: CGFloat = 0.0, complete: () -> ()) {
    animation = "fadeOut"
    curve = "easeInBack"
    x = 0
    y = 60
    self.duration = duration
    self.delay = delay
    animateNext {
      self.hidden = true
      complete()
    }
  }
}
