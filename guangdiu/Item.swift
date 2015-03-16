//
//  Item.swift
//  guangdiu
//
//  Created by Nick on 15/3/16.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import Realm

class Item: RLMObject{
  
  dynamic var id = -1
  dynamic var title = ""
  dynamic var source = ""
  dynamic var time = ""
  dynamic var detail = ""
  dynamic var thumbnail = ""
  dynamic var mallPageURL = ""
  
  convenience init(id: Int, title: String, source: String, time: String, detail: String, thumbnail: String, mallPageURL: String) {
    self.init()
    self.id = id
    self.title = title
    self.source = source
    self.time = time
    self.detail = detail
    self.thumbnail = thumbnail
    self.mallPageURL = mallPageURL
  }
}
