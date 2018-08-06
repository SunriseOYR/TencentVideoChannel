//
//  ORChannelViewModel.swift
//  TencentVideoChannel
//
//  Created by OrangesAL on 2018/8/6.
//  Copyright © 2018年 欧阳荣. All rights reserved.
//

import UIKit

class ORChannelViewModel: NSObject {

    var dataSource:[ORChannelsModel]! = [ORChannelsModel]()
    let titles:[String]! = ["大IP", "HOT", "衍生", "影视综", "游戏", "搞笑", "生活", "体育", "时尚", "音乐", "育儿", "旅游", "视听体验", "其他", "默认"]
    var canMove:Bool = false
    
    private func _or_initDataSource() {
        
    }
    
    private func _or_cache() -> Any? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/or_chanle_path.dat")
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path!)
    }
    
    private func _or_save() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/or_chanle_path.dat")
        NSKeyedArchiver.archiveRootObject(self.dataSource, toFile: path!)
    }
}

class ORChannelsModel: NSObject, NSCoding {
    
    var title:String!
    var chanels:[String]! = [String]()
    
    init(aTitle:String!, aCount:Int) {
        self.title = aTitle
        for index in 0...aCount {
            let str:String = aTitle + String(format: "%02d", index)
            self.chanels.append(str)
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.title, forKey: "title")
        aCoder.encode(self.chanels, forKey: "chanels")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: "title") as! String
        self.chanels = aDecoder.decodeObject(forKey: "chanels") as! [String]
    }
}
