//
//  ZheKouViewCell.swift
//  guangdiu
//
//  Created by Nick on 15/3/12.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import UIKit

class ZheKouViewCell: UITableViewCell {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descLabel: UILabel!
  @IBOutlet weak var favBtn: UIButton!
  @IBOutlet weak var imgView: UIImageView!
  @IBOutlet weak var mallLabel: UILabel!
  @IBOutlet weak var siteLabel: UILabel!
  
  var cellOriginData: Item?
  let db = DB()
  

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    mallLabel.layer.cornerRadius = 5
    mallLabel.layer.backgroundColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1.0).CGColor
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setCellData(item: Item) {
    cellOriginData = item
    let title = item.title
    let detail = item.detail
    let imgURL = NSURL(string: item.thumbnail)
    imgView.sd_setImageWithURL(imgURL, placeholderImage: UIImage(named: "DefaultIcon"))
    titleLabel.text = title
    descLabel.text = detail
    descLabel.sizeToFit()
    mallLabel.text = item.source
    siteLabel.text = item.site
    let isFaved = db.isThisItemFaved(item)
    if isFaved {
      favBtn.selected = true
    }
    else {
      favBtn.selected = false
    }
  }

  @IBAction func onFavBtnTapped(sender: UIButton) {
//    println("FAV!")
    if let item = cellOriginData {
      if favBtn.selected {
        db.removeFav(item)
      }
      else {
        db.addFav(item)
      }
    }
  }
}
