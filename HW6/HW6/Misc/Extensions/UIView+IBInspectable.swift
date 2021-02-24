//
//  UIView+IBInspectable.swift
//  task_2
//
//  Created by Aliona Starunska on 24.12.2020.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            return layer.borderColor?.uiColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
}

extension UITextField{
    @IBInspectable var placeholderColor: UIColor {
            get {
                guard let currentAttributedPlaceholderColor = attributedPlaceholder?.attribute(NSAttributedString.Key.foregroundColor,
                                                                                               at: 0, effectiveRange: nil) as? UIColor else {
                    return UIColor.clear
                }
                return currentAttributedPlaceholderColor
            }
            set {
                guard let currentAttributedString = attributedPlaceholder else { return }
                let attributes = [NSAttributedString.Key.foregroundColor : newValue]

                attributedPlaceholder = NSAttributedString(string: currentAttributedString.string, attributes: attributes)
            }
        }
}

private extension CGColor {
    
    var uiColor: UIKit.UIColor {
        return UIKit.UIColor(cgColor: self)
    }
}

