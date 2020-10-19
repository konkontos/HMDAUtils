//
//  HMDAConveniences.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 16/10/20.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

fileprivate extension ByteCountFormatter {

    static var commonFormatter: ByteCountFormatter {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        formatter.isAdaptive = false
        
        return formatter
    }
    
    static func commonFormatter(for units:  ByteCountFormatter.Units) -> ByteCountFormatter {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = units
        formatter.countStyle = .file
        formatter.isAdaptive = false
        
        return formatter
    }
    
}

public extension FixedWidthInteger {
    
    var humanReadableFilesize: String {
        ByteCountFormatter.commonFormatter.string(fromByteCount: Int64(self))
    }
    
}

public extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
    
}

public extension FloatingPoint {
    
    var degreesToRadians: Self { return self * .pi / 180 }
    
    var radiansToDegrees: Self { return self * 180 / .pi }
    
    var whole: Self { return modf(self).0 }
    
    var fraction: Self { return modf(self).1 }
    
}

public extension CGFloat {
    
    var asDouble: Double {
        return Double(self)
    }
    
    var asFloat: Float {
        return Float(self)
    }
    
}

public extension Double {
    
    var asCGFloat: CGFloat {
        return CGFloat(self)
    }
    
}

