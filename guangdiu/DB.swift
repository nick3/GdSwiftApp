//
//  StoreController.swift
//  guangdiu
//
//  Created by Nick on 15/3/16.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import Realm

class DB {
  
  let realm = RLMRealm.defaultRealm()
  
  func saveItems(items: [Item]) -> [Item] {
    var addItems = [Item]()
    for item in items {
      let result = Item.objectsWhere("id=\(item.id)")
      if result.count == 0 {
        addItems.append(item)
      }
    }
    if addItems.count > 0 {
      realm.beginWriteTransaction()
      realm.addObjects(addItems)
      realm.commitWriteTransaction()
    }
    return addItems
  }
  
  func loadItems() -> RLMResults {
    let items = Item.allObjects()
    return items
  }
  
  func clearItems() {
    realm.beginWriteTransaction()
    realm.deleteObjects(loadItems())
    realm.commitWriteTransaction()
  }
}

extension RLMResults {
  func toArray() -> [RLMObject] {
    var array = [RLMObject]()
    for result in self {
      array.append(result)
    }
    return array
  }
}
