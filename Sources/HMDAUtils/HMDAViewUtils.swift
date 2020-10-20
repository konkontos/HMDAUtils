//
//  HMDAViewUtils.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 20/10/20.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)

public enum HMDAViewPosition {
    case above(UIView)
    case below(UIView)
    case atIndex(Int)
    case top
}

public protocol HMDAViewPositionable {
    func addSubview(_ view: UIView)
    func insertSubview(_ view: UIView, at viewIndex: Int)
    func insertSubview(_ view: UIView, aboveSubview relativeView: UIView)
    func insertSubview(_ view: UIView, belowSubview relativeView: UIView)
    
    func added(toView superview: UIView, positioning: HMDAViewPosition)
}

public extension UIView {
    
    func added(toView superview: UIView, positioning: HMDAViewPosition) {
        
        switch positioning {
        
        case .top:
            superview.addSubview(self)
            
        case .atIndex(let index):
            superview.insertSubview(self, at: index)
            
        case .above(let relativeView):
            superview.insertSubview(self, aboveSubview: relativeView)
            
        case .below(let relativeView):
            superview.insertSubview(self, belowSubview: relativeView)
        
        }
        
    }
    
}

//extension UIView: HMDAViewPositionable {}

#endif
