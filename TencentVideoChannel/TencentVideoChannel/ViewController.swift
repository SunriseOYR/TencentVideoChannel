//
//  ViewController.swift
//  TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/17.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let menuIdentifer = "menuChannelIdf"
    private let normalIdentifer = "normalChannelIdf"
    
    private let datasource = ["大IP", "HOT", "衍生", "影视综", "游戏", "搞笑", "生活", "体育", "时尚", "音乐", "育儿", "旅游", "视听体验", "其他", "默认"]
    
    private var menuView :ORScrollMenuView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.groupTableViewBackground
        collectionView.register(UINib.init(nibName: "ORNormalChannelHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: normalIdentifer)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: menuIdentifer)

        menuView  = ORScrollMenuView(frame: CGRect(x: 0, y: 75, width: self.view.bounds.width, height: 50), titles: datasource)
        menuView.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(menuView);
        menuView.isHidden = true;
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == datasource.count - 1 {
            return 30;
        }
        
        return section == 0 ? 21 : Int(arc4random() % 11 + 3)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datasource.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ORChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCellIdf", for: indexPath) as! ORChannelCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            
            if indexPath.section == 0 {
                let header:ORMyChannelHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "myChannelIdf", for: indexPath) as! ORMyChannelHeader;
                return header;
            }
            
            if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: menuIdentifer, for: indexPath);
                
                var view:ORScrollMenuView? = header.viewWithTag(2019) as? ORScrollMenuView;
                if view == nil {
                    view = ORScrollMenuView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 50), titles: datasource)
                    view?.tag = 2019;
                    header.addSubview(view!);
                }
                
                return header;
            }
            
            let header:ORNormalChannelHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: normalIdentifer, for: indexPath) as! ORNormalChannelHeader;
            header.titleL.text = datasource[indexPath.section - 1];
            return header;
            
        }
        return UICollectionReusableView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        

        let indexPath = IndexPath(item: 0, section: 1);
        let attr = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        
        if scrollView.contentOffset.y >= ((attr?.frame.origin.y)! ) {
            menuView.isHidden = false;
        }else {
            menuView.isHidden = true;
        }
        
        let sectionIndexPath = IndexPath(item: 0, section: menuView.currentIndex + 1);
        let sectionAttr = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: sectionIndexPath)
        
        if scrollView.contentOffset.y + 50 > (sectionAttr?.frame.maxY)! {
            collectionView.indexPathForItem(at: <#T##CGPoint#>)
        }
        
        menuView.setSelectedIndex(index: indexPath.section-1, animated: true);
        
        
    }
    
    /* ---- UICollectionViewDelegateFlowLayout -- */
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 80);
        }
        return CGSize(width: 0, height: 50);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let insetLeft = 15.0 * UIScreen.main.bounds.width / 375.0
        
        if section == 0 {
            return UIEdgeInsetsMake(0, insetLeft, insetLeft, insetLeft)
        }
        if section == 1 {
            return UIEdgeInsetsMake(insetLeft, insetLeft, 0, insetLeft)
        }
        
        return UIEdgeInsetsMake(0, insetLeft, 0, insetLeft)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

