//
//  UIView+Extensions.swift
//  MVVM-C
//
//  Created by SonHoang on 10/15/20.
//  Copyright © 2020 LttIOS. All rights reserved.
//

import Foundation

import UIKit

// swiftlint:disable valid_ibinspectable superfluous_disable_command
extension UIView {
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            self.frame.size.height = newValue
        }
    }
    
    @IBInspectable var viewBorderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var viewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var viewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    public class func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    public class func loadNib<T: UIView>() -> T! {
        let name = String(describing: self)
        let bundle = Bundle(for: T.self)
        guard let xib = bundle.loadNibNamed(name, owner: nil, options: nil)?.first as? T else {
            fatalError("Cannot load nib named `\(name)`")
        }
        return xib
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else {
            return UIView()
        }
        return view
    }
    
    func changeViewAlpha(alpha: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = alpha
        }
    }
    
    func addFadeAnimation(duration: Double) {
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = duration
        layer.add(transition, forKey: nil)
    }
    
    func addGardientLayerAndStartAnimation(duration: Double,
                                           animationDelegate delegate: CAAnimationDelegate? = nil,
                                           backgroundColor color: UIColor) {
        let gardientLayer = createGardient(withDuration: duration,
                                           animationDelegate: delegate,
                                           backgroundColor: color)
        layer.mask = gardientLayer
    }
    
    private func createGardient(withDuration duration: Double = 3.0,
                                animationDelegate delegate: CAAnimationDelegate? = nil,
                                backgroundColor color: UIColor = .white) -> CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [color.cgColor, UIColor.clear.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: -1.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let gradientAnimation = CABasicAnimation(keyPath: "startPoint")
        gradientAnimation.fromValue = gradientLayer.startPoint
        gradientAnimation.toValue = gradientLayer.endPoint
        gradientAnimation.duration = duration
        gradientAnimation.delegate = delegate
        
        gradientLayer.add(gradientAnimation, forKey: "startPoint")
                
        return gradientLayer
    }
    
}
