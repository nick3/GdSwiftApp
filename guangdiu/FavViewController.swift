//
//  FavViewController.swift
//  guangdiu
//
//  Created by Nick on 15/3/16.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit
import Realm

class FavViewController: UITableViewController {
  let db = DB()
  var tableData = FavItem.allObjects().sortedResultsUsingProperty("favTime", ascending: false)
  var estimatedRowHeightCache: [String: CGFloat]?
  var notificationToken: RLMNotificationToken?
  var selectedIndex = -1

  override func viewDidLoad() {
    super.viewDidLoad()

      // Uncomment the following line to preserve selection between presentations
      // self.clearsSelectionOnViewWillAppear = false

      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    tableView.tableFooterView = UIView()
    clearsSelectionOnViewWillAppear = false
    tableView.rowHeight = UITableViewAutomaticDimension
    
    notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
      self.tableView.reloadData()
    }
    
    tableView.reloadData()
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
  
  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Potentially incomplete method implementation.
      // Return the number of sections.
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete method implementation.
      // Return the number of rows in the section.
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
    if let favItem = data as? FavItem {
      let item = Item(item: favItem)
      cell?.setCellData(item)
    }
    if !self.isEstimatedRowHeightInCache(indexPath) {
      let cellSize = cell!.systemLayoutSizeFittingSize(CGSizeMake(view.frame.size.width, 0), withHorizontalFittingPriority:1000.0, verticalFittingPriority:50.0)
      putEstimatedCellHeightToCache(indexPath, height: cellSize.height)
    }
    return cell!
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
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedIndex = indexPath.row
    performSegueWithIdentifier("FavGoDetail", sender: self)
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
    }
  }
}
