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

public protocol HMDAViewPositionable {
    
    func addSubview(_ view: HMDAViewPositionable)
    func insertSubview(_ view: HMDAViewPositionable, at viewIndex: Int)
    func insertSubview(_ view: HMDAViewPositionable, aboveSubview relativeView: HMDAViewPositionable)
    func insertSubview(_ view: HMDAViewPositionable, belowSubview relativeView: HMDAViewPositionable)
    
    func added(toView superview: HMDAViewPositionable, positioning: HMDAViewPosition)
    
}

public enum HMDAViewPosition {
    case above(HMDAViewPositionable)
    case below(HMDAViewPositionable)
    case atIndex(Int)
    case top
}

public extension HMDAViewPositionable {

    func addSubview<V: HMDAViewPositionable>(_ view: V) {
        view.addSubview(self)
    }
    
    func insertSubview<V: HMDAViewPositionable>(_ view: V, at viewIndex: Int) {
        view.insertSubview(self, at: viewIndex)
    }
    
    func insertSubview<V: HMDAViewPositionable>(_ view: V, aboveSubview relativeView: V) {
        view.insertSubview(self, aboveSubview: relativeView)
    }
    
    func insertSubview<V: HMDAViewPositionable>(_ view: V, belowSubview relativeView: V) {
        view.insertSubview(self, belowSubview: relativeView)
    }
    
    
    #if canImport(UIKit)
    @available(iOS 9.0, tvOS 9.0, *)
    func added(toView superview: HMDAViewPositionable, positioning: HMDAViewPosition) {
        
        switch positioning {
        
        case .top:
            superview.addSubview(self)
            
        case .atIndex(let viewIndex):
            superview.insertSubview(self, at: viewIndex)
            
        case .above(let relativeView):
            superview.insertSubview(self, aboveSubview: relativeView)
            
        case .below(let relativeView):
            superview.insertSubview(self, belowSubview: relativeView)
        
        }
        
    }
    #endif
    
    #warning("FIX macOS (NSView) implementations")
    
    #if canImport(AppKit)
    @available(macOS 11.0, *)
    func added(toView superview: HMDAViewPositionable, positioning: HMDAViewPosition) {
        
        switch positioning {
        
        case .top:
            superview.addSubview(self)
            
        case .atIndex(let viewIndex):
            superview.insertSubview(self, at: viewIndex)
            
        case .above(let relativeView):
            superview.insertSubview(self, aboveSubview: relativeView)
            
        case .below(let relativeView):
            superview.insertSubview(self, belowSubview: relativeView)
        
        }
        
    }
    #endif
    
}

#if canImport(UIKit)

extension UIView: HMDAViewPositionable {}
    
#endif

