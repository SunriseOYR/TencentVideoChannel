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
    
    private let tintColor = UIColor.init(red: 245.0/255.0, green: 244.0/255.0, blue: 247.0/255.0, alpha: 1)
    private let menuHeight:CGFloat = 50.0;
    
    private let menuIdentifer = "menuChannelIdf"
    private let normalIdentifer = "normalChannelIdf"
    
    private let viewModel:ORChannelViewModel = ORChannelViewModel()
    
    private var menuView :ORScrollMenuView!
    
    var isDraging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = tintColor
        
        collectionView.register(UINib.init(nibName: "ORNormalChannelHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: normalIdentifer)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: menuIdentifer)

        let gesture = UILongPressGestureRecognizer.init(target: self, action: #selector(_or_actionLongPressGesture(gesture:)))
        collectionView.addGestureRecognizer(gesture);
//        Selector.init(stringLiteral: _or)
        
        let menuY:CGFloat = UIScreen.main.bounds.height > 800 ? 75 + 24 : 75
        
        menuView  = ORScrollMenuView(frame: CGRect(x: 0, y: menuY, width: self.view.bounds.width, height: menuHeight))
        menuView.titles = viewModel.titles;
        menuView.backgroundColor = tintColor
        
        self.view.addSubview(menuView)
        menuView.isHidden = true;
        
        menuView.menuDidSelectedClosure = {[unowned self](index:Int) in
            self.collectionViewOffsetAjustMenuWithIndex(index: index)
        }
        
    }

    @objc private func _or_actionLongPressGesture(gesture:UILongPressGestureRecognizer) {
        
        let point = gesture.location(in: collectionView);
        let indexPath = collectionView.indexPathForItem(at: point)
        
        if indexPath == nil {
            return;
        }
        
        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath!)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func collectionViewOffsetAjustMenuWithIndex(index:Int) {
        
        isDraging = false;
        
        let indexPath = IndexPath(item: 0, section: index + 1)
        let attr = self.collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        let offsetY = indexPath.section == 1 ? attr?.frame.minY : (attr?.frame.minY)! - self.menuHeight
        
        self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY!), animated: true)
    }
    
    //MARK: - UICollectionViewDataSource && UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.dataSource[section].chanels.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ORChannelCell = collectionView.dequeueReusableCell(withReuseIdentifier: "channelCellIdf", for: indexPath) as! ORChannelCell
        cell.titleL.text = viewModel.dataSource[indexPath.section].chanels[indexPath.item]
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
                    view = ORScrollMenuView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: menuHeight))
                    view?.titles = viewModel.titles;
                    view?.tag = 2019;
                    header.addSubview(view!);
                    view?.menuDidSelectedClosure = {[unowned self](index:Int) in
                        self.collectionViewOffsetAjustMenuWithIndex(index: index)
                        self.menuView.or_setSelectedIndex(index: index, animated: true)
                    }
                }
                
                view?.or_setSelectedIndex(index: menuView.currentIndex, animated: false)
                
                return header;
            }
            
            let header:ORNormalChannelHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: normalIdentifer, for: indexPath) as! ORNormalChannelHeader;
            header.titleL.text = viewModel.dataSource[indexPath.section].title
            return header;
            
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 && viewModel.canMove == true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.or_moveItemAtIndex(sourceIndex: sourceIndexPath.item, destinationIndex: destinationIndexPath.item)
    }
    
    //MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if collectionView.visibleCells.count == 0 {
            return;
        }
        
        let indexPath = IndexPath(item: 0, section: 1);
        let attr = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: indexPath)
        
        if scrollView.contentOffset.y < ((attr?.frame.origin.y)! ) {
            menuView.isHidden = true;
            collectionView.backgroundColor = tintColor;
            return;
        }
        
        collectionView.backgroundColor = UIColor.init(red: 241.0/255.0, green: 240.0/255.0, blue: 246.0/255.0, alpha: 1)
        menuView.isHidden = false;
        
        if isDraging == false {
            return;
        }
        
        let currentIndexPath = IndexPath(item: 0, section: menuView.currentIndex + 1);
        let currentAttr = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: currentIndexPath)
        
        if scrollView.contentOffset.y + menuHeight < (currentAttr?.frame.minY)! {
            menuView.or_setSelectedIndex(index: menuView.currentIndex - 1, animated: true);
        }else {
            let nextIndexPath = IndexPath(item: 0, section: menuView.currentIndex + 2);
            
            if nextIndexPath.section > viewModel.dataSource.count-1 {
                return;
            }
            
            let nextAttr = collectionView.layoutAttributesForSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: nextIndexPath)
            if nextAttr != nil && scrollView.contentOffset.y + menuHeight > (nextAttr?.frame.minY)!{
                menuView.or_setSelectedIndex(index: menuView.currentIndex + 1, animated: true)
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDraging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDraging = false;
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 80);
        }
        if section == 1 {
            return CGSize(width: 0, height: menuHeight);
        }
        return CGSize(width: 0, height: 50);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let insetLeft = 15.0 * H_PRATIO
        
        if section == 0 {
            return UIEdgeInsetsMake(0, insetLeft, insetLeft, insetLeft)
        }
        if section == 1 {
            
            return UIEdgeInsetsMake(insetLeft, insetLeft, 0, insetLeft)
        }
        
        if section == viewModel.dataSource.count - 1 {
            return UIEdgeInsetsMake(0, insetLeft, 10, insetLeft)
        }
        
        return UIEdgeInsetsMake(0, insetLeft, 0, insetLeft)
    }

}

