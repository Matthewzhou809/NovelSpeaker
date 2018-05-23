//
//  EasyDialogs.swift
//  EasyDialogs
//
//  Created by Junior B. on 12.12.16.
//  Copyright © 2016 Bonto.ch.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import UIKit

fileprivate class EasyDialogCustomUITextField: UITextField {
    public var focusKeyboard: Bool = false
}

fileprivate class EasyDialogCustomUITextView: UITextView, UITextViewDelegate {
    public var heightMultiplier: CGFloat = 0.7
}

fileprivate func colorFromDecimalRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(
        red: red / 255.0,
        green: green / 255.0,
        blue: blue / 255.0,
        alpha: alpha
    )
}

fileprivate enum Side {
    case top
    case left
    case bottom
    case right
}

//@available(iOS 9.0, *)
fileprivate func applyLine(to view: UIView, on side: Side, color: UIColor = UIColor.lightGray) {
    let line = UIView(frame: .zero)
    line.backgroundColor = color
    line.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(line)
    
    switch side {
    case .top:
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                line.heightAnchor.constraint(equalToConstant: 0.5)])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.5)
            ])
        }
    case .right:
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                line.widthAnchor.constraint(equalToConstant: 0.5)])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.5)
                ])
        }
    case .bottom:
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                line.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
                line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                line.heightAnchor.constraint(equalToConstant: 0.5)])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.5)
                ])
        }
    case .left:
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activate([
                line.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                line.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                line.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
                line.widthAnchor.constraint(equalToConstant: 0.5)])
        } else {
            NSLayoutConstraint.activate([
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: line, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0.5)
                ])
        }
    }
}

public class EasyDialog: UIViewController {
    
    public struct Theme {
        let textColor: UIColor
        let titleColor: UIColor
        let titleFont: UIFont
        let textFont: UIFont
        let alertBackgroudColor: UIColor
        let cornerRadius: CGFloat
        let maskViewAlpha: CGFloat
        let separatorColor: UIColor
        let positiveButton: Button
        let destructiveButton: Button
        let regularButton: Button
        
        public init(textColor: UIColor = UIColor.black, textFont: UIFont = UIFont.systemFont(ofSize: 16.0), titleColor: UIColor = UIColor.black, titleFont: UIFont = UIFont.boldSystemFont(ofSize: 18.0), alertBackgroudColor: UIColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0), cornerRadius: CGFloat = 15.0, maskViewAlpha: CGFloat = 0.6, separatorColor: UIColor = UIColor.lightGray) {
            
            self.textColor = textColor
            self.titleColor = titleColor
            self.titleFont = titleFont
            self.textFont = textFont
            self.alertBackgroudColor = alertBackgroudColor
            self.cornerRadius = cornerRadius
            self.maskViewAlpha = maskViewAlpha
            self.separatorColor = separatorColor
            self.positiveButton = Theme.Button.positive
            self.destructiveButton = Theme.Button.destructive
            self.regularButton = Theme.Button.regular
        }
        
        public struct Button {
            let backgroundColor: UIColor
            let selectedBackgroundColor: UIColor
            let textColor: UIColor
            let font: UIFont
            
            public init(backgroundColor: UIColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0), selectedBackgroundColor: UIColor = UIColor(red: 230 / 255.0, green: 230 / 255.0, blue: 230 / 255.0, alpha: 1.0), textColor: UIColor = UIColor(red: 19 / 255.0, green: 144 / 255.0, blue: 255 / 255.0, alpha: 1.0), font: UIFont = UIFont.boldSystemFont(ofSize: 16.0)) {
                self.backgroundColor = backgroundColor
                self.selectedBackgroundColor = selectedBackgroundColor
                self.textColor = textColor
                self.font = font
            }
            
            static let positive = Button(backgroundColor: colorFromDecimalRGB(245, green: 245, blue: 245), selectedBackgroundColor: colorFromDecimalRGB(230, green: 230, blue: 230), textColor: colorFromDecimalRGB(19, green: 144, blue: 255), font: UIFont.boldSystemFont(ofSize: 16.0))
            
            static let destructive = Button(backgroundColor: colorFromDecimalRGB(245, green: 245, blue: 245), selectedBackgroundColor: colorFromDecimalRGB(230, green: 230, blue: 230), textColor: colorFromDecimalRGB(255, green: 59, blue: 48), font: UIFont.systemFont(ofSize: 16.0))
            
            static let regular = Button(backgroundColor: colorFromDecimalRGB(245, green: 245, blue: 245), selectedBackgroundColor: colorFromDecimalRGB(230, green: 230, blue: 230), textColor: colorFromDecimalRGB(19, green: 144, blue: 255), font: UIFont.systemFont(ofSize: 16.0))
            
        }
    }
    
    private class ActionWrapper {
        weak var sender: UIControl?
        let action: (EasyDialog) -> ()
        weak var dialog: EasyDialog? = nil
        
        init(sender: UIControl, action: @escaping (EasyDialog) -> (), event: UIControlEvents = .touchUpInside) {
            self.sender = sender
            self.action = action
            sender.addTarget(self, action: #selector(actionPerformed), for: event)
        }
        
        @objc private func actionPerformed() {
            guard let dialog = dialog else {
                fatalError("Something went wrong creating this dialog and the callback can't be performed")
            }
            
            action(dialog)
        }
    }
    
    public class Builder {
        
        public enum ButtonType {
            case destructive
            case positive
            case regular
        }
        
        public static var defaultTheme = Theme()
        
        /// The view controller to display the alert view
        weak var targetViewController: UIViewController?
        
        let theme: Theme
        
        private var views = [UIView]()
        private var buttons = [UIButton]()
        private var actions = [ActionWrapper]()
        
        public init(_ viewController: UIViewController, theme: Theme = defaultTheme) {
            targetViewController = viewController
            self.theme = theme
        }
        
        /// Set the title of the dialog
        public func title(title: String) -> Self {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.font = theme.titleFont
            label.textColor = theme.titleColor
            views.append(label)
            return self
        }
        
        /// Set the title of the dialog
        public func text(content: String) -> Self {
            return label(text: content, textAlignment: .center)
        }
        
        public func textView(content: String, heightMultiplier: CGFloat) -> Self {
            let textView = EasyDialogCustomUITextView()
            textView.text = content
            textView.isEditable = false
            textView.font = theme.textFont
            textView.textColor = theme.textColor
            textView.heightMultiplier = heightMultiplier
            views.append(textView)
            return self
        }
        
        public func label(text: String, textAlignment: NSTextAlignment = .left) -> Self {
            let label = UILabel()
            label.text = text
            label.textAlignment = textAlignment
            label.numberOfLines = 0
            label.textColor = theme.textColor
            label.font = theme.textFont
            views.append(label)
            return self
        }
        
        public func textField(tag: Int? = nil, placeholder: String? = nil, content: String? = nil, keyboardType: UIKeyboardType = .default, secure: Bool = false, focusKeyboard: Bool = false, borderStyle: UITextBorderStyle = .none) -> Self {
            let textField = EasyDialogCustomUITextField()
            textField.placeholder = placeholder
            textField.text = content
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = secure
            textField.focusKeyboard = focusKeyboard
            textField.borderStyle = borderStyle
            if let tag = tag {
                textField.tag = tag
            }
            applyLine(to: textField, on: .bottom)

            views.append(textField)
            return self
        }
        public func focusKeyboard(){
            for view in views {
                if let customUITextField = view as? EasyDialogCustomUITextField {
                    if customUITextField.focusKeyboard {
                        customUITextField.becomeFirstResponder()
                    }
                }
            }
        }
        
        public func addButton(tag: Int? = nil, title: String, type: ButtonType = .regular, callback: ((EasyDialog) -> ())?) -> Self {
            let button = UIButton(type: .custom)
            if let t = tag {
                button.tag = t
            }
            
            button.setTitle(title, for: .normal)
            
            var buttonTheme: Theme.Button
            switch type {
            case .regular:
                buttonTheme = theme.regularButton
            case .destructive:
                buttonTheme = theme.destructiveButton
            case .positive:
                buttonTheme = theme.positiveButton
            }
            
            button.setBackgroundImage(UIImage.imageWithColor(tintColor: buttonTheme.selectedBackgroundColor), for: .highlighted)
            button.setTitleColor(buttonTheme.textColor, for: .normal)
            button.titleLabel?.font = buttonTheme.font
            button.backgroundColor = buttonTheme.backgroundColor
            
            if let cb = callback {
                actions.append(ActionWrapper(sender: button, action: cb))
            }
            buttons.append(button)
            return self
        }
        
        public func space(ofSize size: CGFloat = 12.0) -> Self {
            let view = UIView()
            if #available(iOS 9.0, *) {
                view.heightAnchor.constraint(equalToConstant: size).isActive = true
            } else {
                // Fallback on earlier versions
                NSLayoutConstraint.activate([
                    NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: size)
                ])
            }
            views.append(view)
            return self
        }
        
        public func view(view: UIView) -> Self {
            views.append(view)
            return self
        }
        
        // MARK: Convenience Methods
        
        public func destructiveButton(title: String = "Cancel", animated: Bool = true) -> Self {
            return addButton(title: title, type: .destructive) { dialog in
                DispatchQueue.main.async {
                    dialog.dismiss(animated: animated)
                }
            }
        }
        
        public func positiveButton(title: String = "Cancel", animated: Bool = true, callback: @escaping ((EasyDialog) -> ())) -> Self {
            return addButton(title: title, type: .positive, callback: callback)
        }
        
        // MARK: Buiding
        
        public func build() -> EasyDialog {
            let dialog = EasyDialog()
            dialog.builder = self
            dialog.view.backgroundColor = UIColor(white: 0, alpha: theme.maskViewAlpha)
            
            dialog.modalPresentationStyle = .overCurrentContext
            dialog.modalTransitionStyle = .crossDissolve
            
            let baseView = UIView()
            dialog.view.addSubview(baseView)
            dialog.baseView = baseView
            dialog.views = views
            dialog.forTextViewConstraintArray = []
            dialog.forKeyboardConstraint = NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: dialog.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
            
            baseView.backgroundColor = theme.alertBackgroudColor
            baseView.translatesAutoresizingMaskIntoConstraints = false
            baseView.clipsToBounds = true
            baseView.layer.cornerRadius = theme.cornerRadius
            
            if #available(iOS 9.0, *) {
                NSLayoutConstraint.activate([
                    baseView.leadingAnchor.constraint(equalTo: dialog.view.leadingAnchor, constant: 24),
                    baseView.trailingAnchor.constraint(equalTo: dialog.view.trailingAnchor, constant: -24),
                    baseView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
                    baseView.centerXAnchor.constraint(equalTo: dialog.view.centerXAnchor),
                    // baseView.centerYAnchor.constraint(equalTo: dialog.view.centerYAnchor)
                    dialog.forKeyboardConstraint
                    ])
            } else {
                // Fallback on earlier versions
                NSLayoutConstraint.activate([
                    NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: dialog.view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 24),
                    NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: dialog.view, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: -24),
                    NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 1),
                    NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: dialog.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0),
                    //NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: dialog.view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
                    dialog.forKeyboardConstraint
                    ])
            }

            var previousView: UIView?
            func addViewToBaseView(view: UIView, index: Int, sideInset: CGFloat = 12.0) {
                view.translatesAutoresizingMaskIntoConstraints = false
                
                // set tag, if > 0 skip
                if view.tag == 0 {
                    view.tag = index + 1 // avoid 0 as tag
                }
                
                baseView.addSubview(view)
                
                if let view = view as? EasyDialogCustomUITextView {
                    let height = UIScreen.main.bounds.height
                    if let toplevelView = dialog.view {
                        let equal = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: toplevelView, attribute: .height, multiplier: view.heightMultiplier, constant: 0)
                        equal.priority = UILayoutPriority(rawValue: 999)
                        dialog.forTextViewConstraintArray.append(equal)
                        NSLayoutConstraint.activate([equal])
                        print("CONTENT height to: ", height)
                    }
                }
                
                if let pv = previousView {
                    var constant = CGFloat(12.0)

                    if let _ = pv as? UIButton, let _ = view as? UIButton {
                        constant = 0
                    } else if let _ = view as? UIButton {
                        constant = 24
                    }
                    
                    if #available(iOS 9.0, *) {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: pv.bottomAnchor, constant: constant),
                            view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: sideInset),
                            view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -sideInset),
                            view.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)])
                    } else {
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: pv, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: constant),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: sideInset),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: sideInset),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
                            ])
                    }
                } else {
                    if #available(iOS 9.0, *) {
                        NSLayoutConstraint.activate([
                            view.topAnchor.constraint(equalTo: baseView.topAnchor, constant: 24),
                            view.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: sideInset),
                            view.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -sideInset),
                            view.centerXAnchor.constraint(equalTo: baseView.centerXAnchor)])
                    } else {
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 24),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: sideInset),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: sideInset),
                            NSLayoutConstraint.init(item: view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0),

                            ])
                    }
                }
                
                previousView = view
            }
            
            
            for (index, view) in views.enumerated() {
                addViewToBaseView(view: view, index: index)
            }
            
            if buttons.count == 2 { // handle side by side buttons
                let left = buttons[0]
                let right = buttons[1]
                
                left.translatesAutoresizingMaskIntoConstraints = false
                right.translatesAutoresizingMaskIntoConstraints = false
                
                applyLine(to: left, on: .top, color: theme.separatorColor)
                applyLine(to: right, on: .top, color: theme.separatorColor)
                applyLine(to: left, on: .right, color: theme.separatorColor)
                
                baseView.addSubview(left)
                baseView.addSubview(right)
                
                let topView = previousView ?? baseView
                
                if #available(iOS 9.0, *) {
                    NSLayoutConstraint.activate([
                        left.heightAnchor.constraint(equalToConstant: 44.0),
                        left.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
                        left.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
                        left.trailingAnchor.constraint(equalTo: right.leadingAnchor, constant: 0),
                        left.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0)])
                    NSLayoutConstraint.activate([
                        right.heightAnchor.constraint(equalToConstant: 44.0),
                        right.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 24),
                        right.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
                        right.widthAnchor.constraint(equalTo: left.widthAnchor)])
                } else {
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint.init(item: left, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 44),
                        NSLayoutConstraint.init(item: left, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 24),
                        NSLayoutConstraint.init(item: left, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint.init(item: left, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: right, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint.init(item: left, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
                        ])
                    NSLayoutConstraint.activate([
                        NSLayoutConstraint.init(item: right, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 44),
                        NSLayoutConstraint.init(item: right, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: topView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 24),
                        NSLayoutConstraint.init(item: right, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.trailing, multiplier: 1.0, constant: 0),
                        NSLayoutConstraint.init(item: right, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: left, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0),
                        ])
                }
                
            } else if buttons.count > 0 { // single or more than 2 buttons
                for (index, button) in buttons.enumerated() {
                    applyLine(to: button, on: .top)
                    if #available(iOS 9.0, *) {
                        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
                    } else {
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 44)
                            ])
                    }
                    addViewToBaseView(view: button, index: views.count + index + 1, sideInset: 0)
                }
                if #available(iOS 9.0, *) {
                    previousView?.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: 0).isActive = true
                } else {
                    if(previousView != nil) {
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.init(item: previousView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
                            ])
                    }
                }
            } else {
                if #available(iOS 9.0, *) {
                    previousView?.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -24).isActive = true
                } else {
                    if(previousView != nil){
                        NSLayoutConstraint.activate([
                            NSLayoutConstraint.init(item: previousView!, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: baseView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: -24)
                        ])
                    }
                }
            }
            
            for action in actions {
                action.dialog = dialog
            }
            
            return dialog
        }
        
    }
    
    /// reference to the builder
    private var builder: Builder!
    private var baseView: UIView!
    private var views: [UIView]!
    private var forKeyboardConstraint: NSLayoutConstraint!
    private var forTextViewConstraintArray: [NSLayoutConstraint]!
    
    public func show() {
        builder.targetViewController?.present(self, animated: true, completion: {
            self.builder.focusKeyboard()
        })
    }
    
    // キーボードが開いた時にかなりあやしい感じでウィンドウのサイズを変更します。
    func keyboardWillShow(notification:Notification){
        if let dic = notification.userInfo {
            if let value = dic[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                // キーボードが出てきたときに余った表示領域の高さを手に入れます
                let height = UIScreen.main.bounds.height - value.cgRectValue.minY
                if forKeyboardConstraint != nil {
                    NSLayoutConstraint.deactivate([forKeyboardConstraint])
                }
                // 新しい中央の場所をそれっぽく設定します
                forKeyboardConstraint = NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: -height / 2)
                NSLayoutConstraint.activate([forKeyboardConstraint])
                // TextView は「ユーザが思い描いた感じで画面の大半を専有している」と仮定して、
                // その高さを縮めないとキーボードを表示したために画面外に追いやられる部分がある、と思い込んで、
                // とりあえず高さを 0.4倍 して表示しなおさせています。
                // つまり、TextView が複数あったり、TextView ではない View がいっぱいあったりすると、期待した感じで画面内に全ては収まりません。
                // TODO: つまり、本来ならこういう小手先のサイズ変更でなんとかするのではなく、
                // キーボードが当たっているViewがちゃんと表示される位置になるようにウィンドウを移動させるべきです。
                // でも、NotificationCenter からの UIKeyboardWillShow でのイベントには、
                // キーボードのフォーカスが当たったViewについての情報は得られないっぽいのと、
                // UITextViewDelegate による textViewShouldBeginEditing() イベントは NotificationCenter からのイベントよりも後に発生するようで、
                // キーボードが当たったViewがどのViewかを判定する方法が(このイベントハンドラの時点では)無いっぽい？
                // どうすれバインダー？('A`)
                if forTextViewConstraintArray != nil {
                    NSLayoutConstraint.deactivate(forTextViewConstraintArray)
                }
                forTextViewConstraintArray = []
                for view in views {
                    if let view = view as? EasyDialogCustomUITextView {
                        let layout = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: baseView, attribute: .height, multiplier: view.heightMultiplier * 0.4, constant: 0)
                        layout.priority = UILayoutPriority(rawValue: 999)
                        forTextViewConstraintArray.append(layout)
                    }
                }
                NSLayoutConstraint.activate(forTextViewConstraintArray)
                if let duration = dic[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                    UIView.animate(withDuration: duration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    func keyboardWillHide(notification:Notification){
        if let dic = notification.userInfo {
            if forKeyboardConstraint != nil {
                NSLayoutConstraint.deactivate([forKeyboardConstraint])
            }
            forKeyboardConstraint = NSLayoutConstraint.init(item: baseView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([forKeyboardConstraint])
            if forTextViewConstraintArray != nil {
                NSLayoutConstraint.deactivate(forTextViewConstraintArray)
            }
            forTextViewConstraintArray = []
            for view in views {
                if let view = view as? EasyDialogCustomUITextView {
                    let layout = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: baseView, attribute: .height, multiplier: view.heightMultiplier, constant: 0)
                    layout.priority = UILayoutPriority(rawValue: 999)
                    forTextViewConstraintArray.append(layout)
                }
            }
            NSLayoutConstraint.activate(forTextViewConstraintArray)
            if let duration = dic[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval {
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { notification in
            self.keyboardWillShow(notification: notification)
        }
        notificationCenter.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension UIImage {
    
    fileprivate static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
}