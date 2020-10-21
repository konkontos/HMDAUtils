//
//  HMDAViewUtils.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 20/10/20.
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(macOS)
import AppKit
#endif

#if os(iOS) || os(tvOS)
public typealias HMDALayoutViewType = UIView
#endif

#if os(macOS)
public typealias HMDALayoutViewType = NSView
#endif

public enum HMDAViewPosition {
    case above(HMDALayoutViewType)
    case below(HMDALayoutViewType)
    case atIndex(Int)
    case top
}

#if os(iOS) || os(tvOS)
public extension HMDALayoutViewType {
    func added(toView superview: HMDALayoutViewType, positioning: HMDAViewPosition) -> Self {
        
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
        
        return self
    }
}
#endif

#if os(macOS)
public extension HMDALayoutViewType {
    
    func added(toView superview: HMDALayoutViewType, positioning: HMDAViewPosition) -> Self {
        
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
        
        return self
    }
    
}
#endif


public extension HMDALayoutViewType {
    
    subscript(index: Int) -> HMDALayoutViewType? {
        self.viewWithTag(index)
    }

    func removeConstraints(forView childView: HMDALayoutViewType) {
        
        var constraintsToBeRemoved = [NSLayoutConstraint]()
        
        for constraint in constraints {
            
            if (constraint.firstItem as? HMDALayoutViewType) == self || (constraint.secondItem as? HMDALayoutViewType) == self {
                constraintsToBeRemoved.append(constraint)
            }
            
        }
        
        NSLayoutConstraint.deactivate(constraintsToBeRemoved)
    }
    
}

public extension Sequence where Element == HMDALayoutViewType {
    
    func with(tag: Int) -> HMDALayoutViewType? {
        
        self.filter { (subview) -> Bool in
            subview.tag == tag
        }.first
        
    }
    
}
