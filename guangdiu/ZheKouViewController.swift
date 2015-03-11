//
//  ZheKouViewController.swift
//  guangdiu
//
//  Created by Nick on 15/3/11.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit

class ZheKouViewController: UITableViewController {
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var segmentCtrl: UISegmentedControl!

  var tableData = [Item]()

  var pageNo = 1
  var isLoading = false
  var noData = false

  override func viewDidLoad() {
    super.viewDidLoad()

    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    getData(segement: 0)
  }
  
  func getData(segement type: Int) {
//    activityIndicator.startAnimating()
//    isLoading = true
//    var api = GuangDiuAPI()
//    var get: (Int, callback: (items: [Item], pageNo: Int) -> Void) -> ()
//    switch type {
//    case 0:
//      get = api.getShiShiZheKou
//    case 1:
//      get = api.getFengYunBang
//    case 2:
//      get = api.getJiuKuaiJiu
//    default:
//      return
//    }
//    get(pageNo) { (let items: [Item], let pageNo: Int) in
//      if items.count > 0 {
//        self.tableData += items
//        self.tableView.reloadData()
//      }
//      else {
//        self.noData = true
//      }
//      self.activityIndicator.stopAnimating()
//      self.isLoading = false
//    }
  }
  
  @IBAction func segmentChanged(sender: UISegmentedControl) {
    pageNo = 1
    noData = false
    tableData = [Item]()
    getData(segement: sender.selectedSegmentIndex)
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

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      // #warning Potentially incomplete method implementation.
      // Return the number of sections.
      return 0
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete method implementation.
      // Return the number of rows in the section.
      return tableData.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    cell = tableView.dequeueReusableCellWithIdentifier("DataCell") as? UITableViewCell
    if cell == nil {
      cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
    }
    
    if tableData.count > indexPath.row {
      let item = tableData[indexPath.row]
      let title = item.title.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
      let detail = item.detail.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
      let imgURL = NSURL(string: item.thumbnail)
      cell!.imageView?.sd_setImageWithURL(imgURL, placeholderImage: UIImage(named: "DefaultIcon"))
      cell!.textLabel?.text = title
      cell!.detailTextLabel?.lineBreakMode = .ByWordWrapping
      cell!.detailTextLabel?.numberOfLines = 6
      let content = detail
      let padding: CGFloat = 20
      let width = tableView.frame.size.width - padding * 2
      let size = CGSizeMake(width, CGFloat.max)
      let attrs = [NSFontAttributeName: UIFont(name: "Helvetica", size: 14)!]
      let frame = content.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil)
      cell!.detailTextLabel?.setHeight(frame.height + 1)
      cell!.detailTextLabel?.text = detail
    }
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    NSLog("User seleted \(indexPath.row).")
    var detailView = storyboard?.instantiateViewControllerWithIdentifier("DetaiView") as DetailViewController
    detailView.setItem(tableData[indexPath.row])
//    navigationController?.pushViewController(detailView, animated: true)
    
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

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using [segue destinationViewController].
      // Pass the selected object to the new view controller.
  }
  */

}
