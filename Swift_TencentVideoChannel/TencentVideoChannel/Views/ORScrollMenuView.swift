//
//  ORScrollMenuView.swift
//  TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/17.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

import UIKit

let H_PRDIO = UIScreen.main.bounds.width / 375.0

class ORScrollMenuView: UIView {

    private let scrollView = UIScrollView()
    private let slider = UIView()
    private var currentTag = 2018
    private let btnTag = 2018
    
    var tintClor: UIColor? {
        
        get {
            return slider.backgroundColor
        }
        
        set {
            self.slider.backgroundColor = newValue
        }
    }
    
    var titles:[String]! 
    
    var menuDidSelectedClosure:((Int)->Void)?;
    
    var currentIndex :Int {
        get {
            return max(currentTag-btnTag, 0)
        }
    }
    
    init(frame: CGRect, titles:[String]) {
        super.init(frame: frame)
        self.titles = titles
        initilaizeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initilaizeUI() {
        
        scrollView.frame = self.bounds;
        scrollView.showsHorizontalScrollIndicator = false
        
        self.addSubview(scrollView)
        
        slider.backgroundColor = UIColor.orange;
        slider.bounds = CGRect(x: 0, y: 0, width: 18, height: 3);
        scrollView.addSubview(slider)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        var width:CGFloat = 0.0;
        
        let intence = 30.0 * H_PRDIO;
        let fontSize = 18.0 * H_PRDIO;

        
        for (index, value) in self.titles.enumerated() {
            
            let btw = NSString(string: value).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 10.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)], context: nil).size.width + intence;
            
            let btn = UIButton.init(type: .custom)
            
            btn.frame = CGRect(x: width, y: 0, width: btw, height: self.bounds.height-5);
            
            btn.setTitle(value, for: .normal);
            btn.setTitleColor(UIColor.darkGray, for: .normal);
            btn.setTitleColor(UIColor.orange, for: .selected);
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            
            btn.tag = index + btnTag
            
            scrollView.addSubview(btn)
            
            if index == 0 {
                slider.center.x = btn.center.x
                slider.frame.origin.y = btn.center.y + fontSize - 2;
                action_btn(btn: btn)
            }
            
            btn.addTarget(self, action: #selector(action_btn(btn:)), for: .touchUpInside)
            width += btw;
        }
        
        scrollView.contentSize = CGSize(width: width, height: 0);
        
    }
    
    @objc private func action_btn(btn:UIButton) {
        
        setSelectedIndex(index: btn.tag - btnTag, animated: true)
        
        if menuDidSelectedClosure != nil {
            menuDidSelectedClosure!(btn.tag - btnTag)
        }
    }
    
    private func btnStateChanged(currentBtn: UIButton, lastBtn:UIButton?) {
        
        let fontSize = 18.0 * UIScreen.main.bounds.width / 375.0
        
        self.slider.center.x = currentBtn.center.x
        currentBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 2.3))
        currentBtn.isSelected = true
        if lastBtn != nil {
            lastBtn!.isSelected = false;
            lastBtn!.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    public func setSelectedIndex(index:Int, animated:Bool) {
        
        if index == currentTag - btnTag {
            return;
        }
        
        let btn: UIButton = scrollView.viewWithTag(index + btnTag) as! UIButton
        
        let lastBtn: UIButton? = scrollView.viewWithTag(currentTag) as? UIButton
        
        //计算偏移
        let btnCenter = scrollView.convert(btn.center, to: self)
        var inset = btnCenter.x - self.bounds.width / 2.0;

        if inset > 0 {
            let maxInset = scrollView.contentSize.width - scrollView.contentOffset.x - self.bounds.width;
            inset = min(inset, maxInset)
            inset = max(inset, 0)
        }else {
            let minInset = -scrollView.contentOffset.x;
            inset = max(inset, minInset);
            inset = min(inset, 0);
        }
        
        if animated {
            UIView .animate(withDuration: 0.25) {
                self.btnStateChanged(currentBtn: btn, lastBtn: lastBtn)
            }
        }else {
            btnStateChanged(currentBtn: btn, lastBtn: lastBtn)
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + inset, y: 0), animated: animated)

        currentTag = btn.tag
    }
    
}
