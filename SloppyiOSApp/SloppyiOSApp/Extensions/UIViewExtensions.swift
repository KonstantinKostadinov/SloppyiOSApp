//
//  UIViewExtensions.swift
//  SloppyiOSApp
//
//  Created by Konstantin Kostadinov on 7.08.21.
//

import Foundation
import UIKit
import JGProgressHUD

//IB Inspectable extensions
extension UIView {
    func showProgressHUD() {
        JGProgressHUD().show(in: self)
    }

    func dismissProgressHUD() {
        for progressHuds in self.subviews where progressHuds is JGProgressHUD {
            (progressHuds as? JGProgressHUD)?.dismiss()
        }
    }

    func showError(error: String?) {
        self.dismissProgressHUD()
        let hud = JGProgressHUD()
        hud.textLabel.text = error
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.show(in: self)
        hud.dismiss(afterDelay: 3.0)
    }

    func showMessage(message: String?, delay: Double = 3.0, onDismiss: (() -> Void)? = nil) {
        self.dismissProgressHUD()
        let hud = JGProgressHUD()
        hud.textLabel.text = message
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.show(in: self)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            hud.dismiss()
            onDismiss?()
        }
    }

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
