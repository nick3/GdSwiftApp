//
//  GuangDiuAPI.swift
//  GuangDiu
//
//  Created by Nick on 15/3/4.
//  Copyright (c) 2015年 Nick. All rights reserved.
//

import Foundation
import Alamofire
import Dollar
import SwiftTask

typealias Progress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
typealias AlamoFireTask = Task<Progress, String, NSError>

struct Item {
    var title: String
    var source: String
    var time: String
    var detail: String
    var thumbnail: String
    var mallPageURL: String
}

class GuangDiuAPI {
  let baseURI = "http://guangdiu.com/m"
  let loadDataPath = "/loaddata.php"
  let loadRankPath = "/loadrank.php"
  let loadCheapPath = "/loadcheap.php"
  let paramV = "1425537325223"
  
  func getLoadDataURL(let pageNo: Int) -> String {
      return "\(baseURI)\(loadDataPath)?v=\(paramV)&p=\(pageNo)"
  }
  func getLoadRankURL(let pageNo: Int) -> String {
      return "\(baseURI)\(loadRankPath)?v=\(paramV)&type=hot&p=\(pageNo)"
  }
  func getLoadCheapURL(let pageNo: Int) -> String {
      return "\(baseURI)\(loadCheapPath)?v=\(paramV)&p=\(pageNo)"
  }
  
  func getShiShiZheKou(let pageNo: Int, let callback: (items: [Item], pageNo: Int) -> Void) {
    let url = NSURL(string: getLoadDataURL(pageNo))
    let request = NSURLRequest(URL: url!)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, err) in
        if data != nil {
            if let html = NSString(data: data, encoding: NSUTF8StringEncoding) {
              let items = self.parseDataHTML(html)
              callback(items: items, pageNo: pageNo)
          }
        }
        else {
          callback(items: [Item](), pageNo: pageNo)
        }
        
    }
  }
  
  func getFengYunBang(let pageNo: Int, let callback: (items: [Item], pageNo: Int) -> Void) {
    let url = NSURL(string: getLoadRankURL(pageNo))
    let request = NSURLRequest(URL: url!)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, err) in
      if data != nil {
        if let html = NSString(data: data, encoding: NSUTF8StringEncoding) {
          let items = self.parseRankHTML(html)
          callback(items: items, pageNo: pageNo)
        }
      }
      else {
        callback(items: [Item](), pageNo: pageNo)
      }
      
    }
  }
  
  func getJiuKuaiJiu(let pageNo: Int, let callback: (items: [Item], pageNo: Int) -> Void) {
    let url = NSURL(string: getLoadCheapURL(pageNo))
    let request = NSURLRequest(URL: url!)
    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, err) in
      if data != nil {
        if let html = NSString(data: data, encoding: NSUTF8StringEncoding) {
          let items = self.parseCheapHTML(html)
          callback(items: items, pageNo: pageNo)
        }
      }
      else {
        callback(items: [Item](), pageNo: pageNo)
      }
      
    }
  }
  
  func parseDataHTML(let html: String) -> [Item] {
      var err: NSError?
      var parser = HTMLParser(html: html, error: &err)
      if err != nil {
          println(err)
          exit(1)
      }
      var bodyNode = parser.body
      var items = [Item]()
      if let divNodes = bodyNode?.findChildTagsAttr("div", attrName: "class", attrValue: "item") {
          for node in divNodes {
              let title = node.findChildTagAttr("a", attrName: "class", attrValue: "title")?.contents ?? ""
              let source = node.findChildTagAttr("div", attrName: "class", attrValue: "mallname")?.contents ?? ""
              let time = node.findChildTagAttr("span", attrName: "class", attrValue: "latesttime")?.contents ?? ""
              let detail = node.findChildTagAttr("div", attrName: "class", attrValue: "abstract")?.contents ?? ""
              let thumbnailNode = node.findChildTagAttr("a", attrName: "class", attrValue: "thumbnail")
              var mallPageURL = thumbnailNode?.getAttributeNamed("href") ?? ""
              var thumbnail = thumbnailNode?.findChildTag("img")?.getAttributeNamed("src") ?? ""
              
              if !Regex("^http://").test(mallPageURL) {
                  mallPageURL = baseURI + "/" + mallPageURL
              }
              if !Regex("^http://").test(thumbnail) {
                  thumbnail = baseURI + "/" + thumbnail
              }
              
              let item = Item(title: title, source: source, time: time, detail: detail, thumbnail: thumbnail, mallPageURL: mallPageURL)
              items.append(item)
          }
      }
      return items
  }
  
  func parseRankHTML(let html: String) -> [Item] {
    var err: NSError?
    var parser = HTMLParser(html: html, error: &err)
    if err != nil {
      println(err)
      exit(1)
    }
    var bodyNode = parser.body
    var items = [Item]()
    if let divNodes = bodyNode?.findChildTagsAttr("div", attrName: "class", attrValue: "rankitem") {
      for node in divNodes {
        let title = node.findChildTagAttr("a", attrName: "class", attrValue: "ranktitle")?.contents ?? ""
        let source = node.findChildTagAttr("div", attrName: "class", attrValue: "mallname")?.contents ?? ""
        let time = node.findChildTagAttr("span", attrName: "class", attrValue: "latesttime")?.contents ?? ""
        let detail = node.findChildTagAttr("div", attrName: "class", attrValue: "abstract")?.contents ?? ""
        let thumbnailNode = node.findChildTagAttr("a", attrName: "class", attrValue: "rankthumbnail")
        var mallPageURL = thumbnailNode?.getAttributeNamed("href") ?? ""
        var thumbnail = thumbnailNode?.findChildTag("img")?.getAttributeNamed("src") ?? ""
        
        if !Regex("^http://").test(mallPageURL) {
          mallPageURL = baseURI + "/" + mallPageURL
        }
        if !Regex("^http://").test(thumbnail) {
          thumbnail = baseURI + "/" + thumbnail
        }
        
        let item = Item(title: title, source: source, time: time, detail: detail, thumbnail: thumbnail, mallPageURL: mallPageURL)
        items.append(item)
      }
    }
    return items
  }
  
  func parseCheapHTML(let html: String) -> [Item] {
    var err: NSError?
    var parser = HTMLParser(html: html, error: &err)
    if err != nil {
      println(err)
      exit(1)
    }
    var bodyNode = parser.body
    var items = [Item]()
    if let divNodes = bodyNode?.findChildTagsAttr("div", attrName: "class", attrValue: "cheapitem") {
      for node in divNodes {
        let title = node.findChildTagAttr("a", attrName: "class", attrValue: "cheaptitle")?.contents ?? ""
        let source = node.findChildTagAttr("div", attrName: "class", attrValue: "mallname")?.contents ?? ""
        let time = node.findChildTagAttr("span", attrName: "class", attrValue: "latesttime")?.contents ?? ""
        let detail = node.findChildTagAttr("div", attrName: "class", attrValue: "abstract")?.contents ?? ""
        let thumbnailNode = node.findChildTagAttr("a", attrName: "class", attrValue: "cheapthumbnail")
        var mallPageURL = thumbnailNode?.getAttributeNamed("href") ?? ""
        var thumbnail = thumbnailNode?.findChildTag("img")?.getAttributeNamed("src") ?? ""
        
        if !Regex("^http://").test(mallPageURL) {
          mallPageURL = baseURI + "/" + mallPageURL
        }
        if !Regex("^http://").test(thumbnail) {
          thumbnail = baseURI + "/" + thumbnail
        }
        
        let item = Item(title: title, source: source, time: time, detail: detail, thumbnail: thumbnail, mallPageURL: mallPageURL)
        items.append(item)
      }
    }
    return items
  }
}

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
  
    init(_ pattern: String) {
        self.pattern = pattern
        var error: NSError?
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .CaseInsensitive, error: &error)!
    }
    
    func test(input: String) -> Bool {
        let matches = self.internalExpression.matchesInString(input, options: nil, range:NSMakeRange(0, countElements(input)))
        return matches.count > 0
    }
}