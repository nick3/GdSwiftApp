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
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }

}
