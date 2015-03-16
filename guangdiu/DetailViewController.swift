//
//  DetailViewController.swift
//  GuangDiu
//
//  Created by Nick on 15/3/5.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIWebViewDelegate {
    
  @IBOutlet weak var webView: UIWebView!
  var item: Item = Item()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = item.title
    
    if let url = NSURL(string: item.mallPageURL) {
      var request = NSURLRequest(URL: url)
      webView.loadRequest(request)
    }
//    navigationController?.hidesBarsOnSwipe = true
    
    // Do any additional setup after loading the view.
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
}
