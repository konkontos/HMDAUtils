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

public enum HMDAViewPosition<V: HMDAViewPositionable> {
    case above(V)
    case below(V)
    case atIndex(Int)
    case top
}

public protocol HMDAViewPositionable {
    associatedtype ViewType
}

#if canImport(UIKit)

extension UIView: HMDAViewPositionable {
    public typealias ViewType = UIView
}


public extension HMDAViewPositionable where Self: UIView {
    
    func added<V: UIView>(toView superview: V, positioning: HMDAViewPosition<V>) {
        
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

#endif



