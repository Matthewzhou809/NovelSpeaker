//
//  FloatingButton.swift
//  NovelSpeaker
//
//  Created by 飯村卓司 on 2018/12/21.
//  Copyright © 2018 IIMURA Takuji. All rights reserved.
//

import UIKit

class FloatingButton: UIView, UIScrollViewDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var button: UIButton!
    
    // ボタンが押された時に呼び出される関数
    var buttonClickedFunc:(()->Void)?
    // スクロールしていない時の UIScrollbar の場所
    var scrollViewStartPoint:CGPoint = CGPoint(x: -1, y: -1)
    // これ以上のスクロールがなされたら消える
    let maxScrollHeight = 300.0
    
    @objc public static func createNewFloatingButton() -> FloatingButton? {
        let nib = UINib.init(nibName: "FloatingButton", bundle: nil)
        var view = nib.instantiate(withOwner: self, options: nil)
        if view.count <= 0 {
            return nil
        }
        if let view = view[0] as? FloatingButton {
            return view
        }
        return nil
    }
        
    @IBAction func buttonClicked(_ sender: Any) {
        if let f = buttonClickedFunc {
            f()
        }
    }
    
    func layoutBottom(parentView:UIView) {
        let view = parentView
        self.view.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -16.0).isActive = true
        self.view.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 8.0).isActive = true
        self.view.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -8.0).isActive = true
        self.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 1.0).isActive = true
    }
    func layoutTop(parentView:UIView) {
        let view = parentView
        self.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16.0).isActive = true
        self.view.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 8.0).isActive = true
        self.view.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: -8.0).isActive = true
        self.view.heightAnchor.constraint(greaterThanOrEqualToConstant: 1.0).isActive = true
    }
    
    @objc public func assignToView(view:UIView, text:String, animated:Bool, buttonClicked:@escaping () -> Void){
        view.addSubview(self.view)
        layoutBottom(parentView: view)
        self.view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        self.view.layer.cornerRadius = 5
        self.view.layer.masksToBounds = false
        self.view.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowRadius = 5
        buttonClickedFunc = buttonClicked
        button.setTitle(text, for: .normal)
        if animated {
            showAnimate()
        }
    }
    
    @objc public func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    @objc public func hideAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }) { (finished) in
            if finished {
                self.view.removeFromSuperview()
            }
        }
    }
    
    @objc public func hide(){
        if self.view != nil && self.view.superview != nil {
            self.view.removeFromSuperview()
        }
    }
    
    @objc public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollHeight = abs(Double(scrollViewStartPoint.y) - Double(scrollView.contentOffset.y))
        if scrollHeight > self.maxScrollHeight {
            if self.view != nil && self.view.superview != nil {
                self.view.removeFromSuperview()
            }
            return
        }
        let affineSize = CGFloat(0.3 * scrollHeight / self.maxScrollHeight)
        self.view.transform = CGAffineTransform(scaleX: 1 + affineSize, y: 1 + affineSize)
        let alpha = CGFloat(1 - scrollHeight / self.maxScrollHeight)
        self.view.alpha = alpha
        print("affineSize:", affineSize)
        print("alpha:", alpha)
    }
}
