//
//  ORScrollMenuView.swift
//  TencentVideoChannel
//
//  Created by 欧阳荣 on 2018/7/17.
//  Copyright © 2018 欧阳荣. All rights reserved.
//

import UIKit

let H_PRATIO = UIScreen.main.bounds.width / 375.0

class ORScrollMenuView: UIView {

    private let scrollView = UIScrollView()
    private let slider = UIView()
    private var currentTag = 0
    private let btnTag = 2018
    
    var tintClor: UIColor? {
        
        get {
            return slider.backgroundColor
        }
        
        set {
            self.slider.backgroundColor = newValue
        }
    }
    
    var titles:[String]? {
        didSet {
            self._or_setSubviews()
        }
    }
    
    var currentIndex :Int {
        get {
            return max(currentTag-btnTag, 0)
        }
    }
    
    var menuDidSelectedClosure:((Int)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        _or_initilaizeUI()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        _or_initilaizeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
    }
    
    private func _or_initilaizeUI() {
        
        scrollView.frame = self.bounds;
        scrollView.showsHorizontalScrollIndicator = false
        
        self.addSubview(scrollView)
        
        slider.backgroundColor = UIColor.orange;
        slider.bounds = CGRect(x: 0, y: 0, width: 18, height: 3);
        scrollView.addSubview(slider)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func _or_setSubviews() {
        
        if titles == nil || (titles?.count)! <= 0 {
            return
        }
        
        scrollView.subviews.forEach { (view) in
            if view is UIButton {
                view.removeFromSuperview()
            }
        }
        
        var width:CGFloat = 0.0;
        
        let fontSize = 18.0 * H_PRATIO;
        
        for (index, value) in self.titles!.enumerated() {
            
            let btw = NSString(string: value).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 10.0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)], context: nil).size.width + 30.0 * H_PRATIO;
            
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
                slider.center.y = btn.center.y + fontSize;
                _or_action_btn(btn: btn)
            }
            
            btn.addTarget(self, action: #selector(_or_action_btn(btn:)), for: .touchUpInside)
            width += btw;
        }
        
        scrollView.contentSize = CGSize(width: width, height: 0);
    }
    
    @objc private func _or_action_btn(btn:UIButton) {
        
        or_setSelectedIndex(index: btn.tag - btnTag, animated: true)
        
        if menuDidSelectedClosure != nil {
            menuDidSelectedClosure!(btn.tag - btnTag)
        }
    }
    
    private func _or_btnStateChanged(currentBtn: UIButton, lastBtn:UIButton?) {
        
        let fontSize = 18.0 * H_PRATIO
        
        self.slider.center.x = currentBtn.center.x
        currentBtn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: 2.3))
        currentBtn.isSelected = true
        if lastBtn != nil {
            lastBtn!.isSelected = false;
            lastBtn!.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    public func or_setSelectedIndex(index:Int, animated:Bool) {
        
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
                self._or_btnStateChanged(currentBtn: btn, lastBtn: lastBtn)
            }
        }else {
            _or_btnStateChanged(currentBtn: btn, lastBtn: lastBtn)
        }
        
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + inset, y: 0), animated: animated)

        currentTag = btn.tag
    }
    
}
