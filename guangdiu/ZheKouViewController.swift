//
//  ZheKouViewController.swift
//  guangdiu
//
//  Created by Nick on 15/3/11.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit
import SwiftTask
import Realm

class ZheKouViewController: UITableViewController {
  @IBOutlet weak var segmentCtrl: UISegmentedControl!
  
  let api = GuangDiuAPI()
  let db = DB()
  var tableData = Item.allObjects().sortedResultsUsingProperty("id", ascending: false)
  var estimatedRowHeightCache: [String: CGFloat]?
  var notificationToken: RLMNotificationToken?

  var pageNo = 1
  var isLoading = false
  var noData = false
  var selectedIndex = -1

  override func viewDidLoad() {
    super.viewDidLoad()
    println(RLMRealm.defaultRealm().path)
    
    tableView.tableFooterView = UIView()

    // Uncomment the following line to preserve selection between presentations
    clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    tableView.rowHeight = UITableViewAutomaticDimension
    
    notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
      self.tableView.reloadData()
    }
    
    tableView.reloadData()

    if let refreshCtrl = refreshControl {
      tableView.contentOffset = CGPointMake(0, -refreshCtrl.frame.size.height)
      refreshCtrl.beginRefreshing()
      getData(segement: 0, sender: refreshControl, clearDB: true)
    }
  }
  
  func getData(segement type: Int, sender: UIRefreshControl? = nil, clearDB: Bool = false) {
    isLoading = true
    api.getShiShiZheKou(pageNo).success { (items) -> [Item] in
      if items.count > 0 {
        if let refreshCtrl = sender {
          if clearDB {
            self.db.clearItems()
          }
          refreshCtrl.endRefreshing()
        }
        let addItems = self.db.saveItems(items)
        self.estimatedRowHeightCache = [:]
      }
      else {
        self.noData = true
      }
      self.isLoading = false
      return items
    }
  }
  
  func getEstimatedCellHeightFromCache(indexPath: NSIndexPath, defaultHeight: CGFloat) -> CGFloat {
    initEstimatedRowHeightCacheIfNeeded()
    if let estimatedHeight = estimatedRowHeightCache?["\(indexPath.row)"] {
      return estimatedHeight
    }
    else {
      return defaultHeight
    }
  }
  
  func isEstimatedRowHeightInCache(indexPath: NSIndexPath) -> Bool {
    if getEstimatedCellHeightFromCache(indexPath, defaultHeight: 0) > 0 {
      return true
    }
    else {
      return false
    }
  }
  
  func initEstimatedRowHeightCacheIfNeeded() {
    if estimatedRowHeightCache == nil {
      estimatedRowHeightCache = [:]
    }
  }
  
  func putEstimatedCellHeightToCache(indexPath: NSIndexPath, height: CGFloat) {
    initEstimatedRowHeightCacheIfNeeded()
    estimatedRowHeightCache!["\(indexPath.row)"] = height
  }
  
  @IBAction func segmentChanged(sender: UISegmentedControl) {
    pageNo = 1
    noData = false
//    tableData = [Item]()
    getData(segement: sender.selectedSegmentIndex)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func scrollViewDidScroll(scrollView: UIScrollView) {
    let offset = scrollView.contentOffset
    let bounds = scrollView.bounds
    let size = scrollView.contentSize
    let inset = scrollView.contentInset
    let y = offset.y + bounds.size.height - inset.bottom
    let h = size.height
    let reload_distance: CGFloat = 10
    if y > h + reload_distance {
      if !noData && !isLoading {
        pageNo++
        getData(segement: segmentCtrl.selectedSegmentIndex)
      }
    }
  }

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Potentially incomplete method implementation.
      // Return the number of sections.
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let count = tableData.count
    return Int(count)
  }
  
  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return getEstimatedCellHeightFromCache(indexPath, defaultHeight: 120)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ZheKouViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("DataCell") as? ZheKouViewCell
    if cell == nil {
      let nib = NSBundle.mainBundle().loadNibNamed("ZheKouCell", owner: self, options: nil)
      cell = nib[0] as? ZheKouViewCell
    }
    let data: AnyObject! = tableData[UInt(indexPath.row)]
    if let item  = data as? Item {
      cell?.setCellData(item)
    }
    if !self.isEstimatedRowHeightInCache(indexPath) {
      let cellSize = cell!.systemLayoutSizeFittingSize(CGSizeMake(view.frame.size.width, 0), withHorizontalFittingPriority:1000.0, verticalFittingPriority:50.0)
      putEstimatedCellHeightToCache(indexPath, height: cellSize.height)
    }
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedIndex = indexPath.row
    performSegueWithIdentifier("GoDetail", sender: self)
//    navigationController?.showViewController(<#vc: UIViewController#>, sender: <#AnyObject!#>)
  }
  
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
  
  override func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.contentView.backgroundColor = UIColor(red:0.29, green:0.6, blue:0.22, alpha:0.2)
    cell?.backgroundColor = UIColor(red:0.29, green:0.6, blue:0.22, alpha:0.2)
  }
  
  override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
    var cell = tableView.cellForRowAtIndexPath(indexPath)
    cell?.contentView.backgroundColor = UIColor.whiteColor()
    cell?.backgroundColor = UIColor.whiteColor()
  }
  
  @IBAction func onRefresh(sender: UIRefreshControl) {
    getData(segement: 0, sender: sender)
  }

  /*
  // Override to support conditional editing of the table view.
  override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the specified item to be editable.
      return true
  }
  */

  /*
  // Override to support editing the table view.
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
      if editingStyle == .Delete {
          // Delete the row from the data source
          tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      } else if editingStyle == .Insert {
          // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
      }    
  }
  */

  /*
  // Override to support rearranging the table view.
  override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

  }
  */

  /*
  // Override to support conditional rearranging of the table view.
  override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
      // Return NO if you do not want the item to be re-orderable.
      return true
  }
  */

  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
    let detailView = segue.destinationViewController as DetailViewController
    if selectedIndex >= 0 {
      detailView.setItem(tableData[UInt(selectedIndex)] as Item)
//      detailView.hidesBottomBarWhenPushed = true
    }
  }

}
