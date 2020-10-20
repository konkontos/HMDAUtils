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

public enum HMDAViewPosition {
    case above(HMDALayoutViewType)
    case below(HMDALayoutViewType)
    case atIndex(Int)
    case top
}

#if canImport(UIKit)

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

#if canImport(AppKit)

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
    
    subscript(index: Int) -> UIView? {
        self.viewWithTag(index)
    }

    func removeConstraints(forView childView: HMDALayoutViewType) {
        
        var constraintsToBeRemoved = [NSLayoutConstraint]()
        
        for constraint in constraints {
            
            if (constraint.firstItem as? HMDALayoutViewType) == self || (constraint.secondItem as? HMDALayoutViewType) == self {
                constraintsToBeRemoved.append(constraint)
            }
            
        }
        
        self.removeConstraints(constraintsToBeRemoved)
    }
    
}
