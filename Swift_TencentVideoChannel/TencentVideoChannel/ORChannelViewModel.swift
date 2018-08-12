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
    
    private var _titles:[String]! = ["大IP", "HOT", "衍生", "影视综", "游戏", "搞笑", "生活", "体育", "时尚", "音乐", "育儿", "旅游", "视听体验", "其他", "默认"]
    var titles:[String]! {
        get {
            return _titles
        }
    }
    
    var canMove:Bool = false
    
    override init() {
        super.init()
        _or_initDataSource()
    }
    
    public func or_moveItemAtIndex(sourceIndex:Int, destinationIndex:Int) {
        var chanels = dataSource.first?.chanels;
        let obj = chanels![sourceIndex]
        chanels?.remove(at: sourceIndex)
        chanels?.insert(obj, at: destinationIndex)
        dataSource.first?.chanels = chanels
        self._or_save()
    }
    
    private func _or_initDataSource() {
        
        var model:ORChannelsModel? = _or_cache() as? ORChannelsModel
        if model == nil {
            model = ORChannelsModel(aTitle: "我的频道", aCount: 21)
        }
        dataSource.append(model!)
        
        for title in _titles {
            let count = arc4random() % 11 + 3
            dataSource.append(ORChannelsModel(aTitle: title, aCount: Int(count)))
        }
        self.canMove = true
    }
    
    private func _or_cache() -> Any? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/or_chanle_path.dat")
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: path!)
    }
    
    private func _or_save() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/or_chanle_path.dat")
        NSKeyedArchiver.archiveRootObject(self.dataSource.first ?? ORChannelsModel(aTitle: "我的频道", aCount: 21), toFile: path!)
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
