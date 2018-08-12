//
//  ORMyChannelHeader.swift
//  TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/17.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

import UIKit

class ORMyChannelHeader: UICollectionReusableView {
    @IBOutlet weak var sortDescriptionL: UILabel!
    @IBOutlet weak var sortSwitch: UISwitch!
    
    var switchChanged:((Bool)->Void)?
    
    
    @IBAction func action_sortSwitch(_ sender: UISwitch) {
        if switchChanged != nil {
            switchChanged!(sender.isOn)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.sortSwitch.transform = CGAffineTransform.init(scaleX: 0.7, y: 0.7)
    }
}
