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

  override func awakeFromNib() {
      super.awakeFromNib()
    // Initialization code
    mallLabel.layer.cornerRadius = 5
    mallLabel.layer.backgroundColor = UIColor(red: 200.0/255, green: 200.0/255, blue: 200.0/255, alpha: 1.0).CGColor
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
