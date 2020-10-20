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
public typealias HMDALayoutViewType = UIView
#endif

#if canImport(AppKit)
public typealias HMDALayoutViewType = NSView
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
    
    func added<V: HMDALayoutViewType>(toView superview: V, positioning: HMDAViewPosition<V>) {
        
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

#if canImport(AppKit)

extension NSView: HMDAViewPositionable {
    public typealias ViewType = NSView
}

public extension HMDAViewPositionable where Self: NSView {
    
    func added<V: HMDALayoutViewType>(toView superview: V, positioning: HMDAViewPosition<V>) {
        
        switch positioning {
        
        case .top:
            superview.addSubview(self)
            
        case .atIndex:
            superview.addSubview(self)
            
        case .above(let relativeView):
            superview.addSubview(self, positioned: .above, relativeTo: relativeView)
            
        case .below(let relativeView):
            superview.addSubview(self, positioned: .below, relativeTo: relativeView)
        
        }
        
    }
    
}
#endif
