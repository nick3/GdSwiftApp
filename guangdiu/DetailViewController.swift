//
//  DetailViewController.swift
//  GuangDiu
//
//  Created by Nick on 15/3/5.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit
import TUSafariActivity

class DetailViewController: UIViewController, UIWebViewDelegate {
  
  @IBOutlet weak var backBtn: FloatBtn!
  @IBOutlet weak var refreshBtn: FloatBtn!
  @IBOutlet weak var shareBtn: FloatBtn!
  @IBOutlet weak var favBtn: FloatBtn!
  
  var floatBtns: [FloatBtn]?
  @IBOutlet weak var webView: UIWebView!
  var item: Item = Item()
  let db = DB()
  
  var isMoreBtnsShown = false
  var isFloatBtnsMoving = false
  var floatBtnsMovingStates: [Bool] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    title = item.title
    floatBtns = [backBtn, refreshBtn, shareBtn, favBtn]
    
    if let url = NSURL(string: item.mallPageURL) {
      var request = NSURLRequest(URL: url)
      webView.loadRequest(request)
    }
//    navigationController?.hidesBarsOnSwipe = true
    
    // Do any additional setup after loading the view.
  }
  
  override func viewDidLayoutSubviews() {
    let viewFrame = view.frame
    var index = 0
    let y = viewFrame.height - 40
    let widthPercent: Float = 1.0
    let viewWidth = Float(viewFrame.width)
    let xInterval = (viewWidth + 32) * widthPercent / 5.0
    for btn in floatBtns! {
      let xOffset = xInterval * Float(++index)
      let startXOffset = viewWidth * (1.0 - widthPercent) - 16
      let x = CGFloat(startXOffset + xOffset)
      btn.center = CGPointMake(x, y)
    }
    configEachFloatBtn()
  }

  func configEachFloatBtn() {
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  
  func setItem(let item: Item!) {
    self.item = item
  }
  
  func setFloatBtnMoving(state: Bool) {
    if state {
      floatBtnsMovingStates.append(state)
    }
    else {
      if floatBtnsMovingStates.count > 0 {
        floatBtnsMovingStates.removeLast()
      }
      else {
        isFloatBtnsMoving = false
      }
    }
    if floatBtnsMovingStates.count > 0 {
      isFloatBtnsMoving = true
    }
    else {
      isFloatBtnsMoving = false
    }
  }
  
  @IBAction func moreBtnPressed(sender: UIBarButtonItem) {
    if !isFloatBtnsMoving {
      var index = 0
      if isMoreBtnsShown {
        for btn in floatBtns! {
          setFloatBtnMoving(true)
          btn.hide(duration: 0.3, delay: 0.1 * CGFloat(index++)) {
            self.setFloatBtnMoving(false)
          }
        }
        isMoreBtnsShown = false
      }
      else {
        for btn in floatBtns! {
          setFloatBtnMoving(true)
          btn.show(duration: 0.5, delay: 0.1 * CGFloat(index++)) {
            self.setFloatBtnMoving(false)
          }
        }
        isMoreBtnsShown = true
      }
    }
  }
  
  @IBAction func shareBtnPressed(sender: FloatBtn) {
    moreBtnPressed(UIBarButtonItem())
    var sharingItems = [AnyObject]()
    if let url = webView.request?.URL {
      sharingItems.append(item.mallPageURL)
      sharingItems.append(url)
    }
    let activity = TUSafariActivity()
    let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [activity])
    presentViewController(activityViewController, animated: true, completion: nil)
  }
  @IBAction func webBackBtnPressed(sender: FloatBtn) {
    moreBtnPressed(UIBarButtonItem())
    webView.reload()
  }
  @IBAction func webRefreshBtnPressed(sender: FloatBtn) {
    moreBtnPressed(UIBarButtonItem())
    webView.goBack()
  }
  @IBAction func favBtnPressed(sender: FloatBtn) {
    UIView.animateWithDuration(NSTimeInterval(0.2), animations: { () -> Void in
      if self.favBtn.selected {
        self.db.removeFav(self.item)
        self.favBtn.layer.borderColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1).CGColor
        self.favBtn.backgroundColor = UIColor.whiteColor()
        self.favBtn.selected = false
      }
      else {
        self.db.addFav(self.item)
        self.favBtn.layer.borderColor = UIColor(red:0.84, green:0.1, blue:0.38, alpha:1).CGColor
        self.favBtn.backgroundColor = UIColor(red:0.91, green: 0.11, blue:0.38, alpha:1)
        self.favBtn.selected = true
      }
    })
    moreBtnPressed(UIBarButtonItem())
  }
}
