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

public extension Int {
    
    var humanReadableFilesize: String {
        
        switch self {
            
        case ..<1024:
            return "\(self) bytes"
            
        case 1024..<1024*1024:
            return "\(self/1024) kb"
            
        case (1024*1024)..<(1024*1024*1024):
            return "\(self/(1024*1024)) mb"
        
        case (1024*1024*1024)...:
            return "\(self/(1024*1024*1024)) gb"
            
        default:
            return ""
        }
        
    }
    
}

public extension UInt64 {
    
    var inMB: Double {
        return Double(self) / Double(1024.0 * 1024.0)
    }
    
    var inGB: Double {
        return Double(self) / Double(1024.0 * 1024.0 * 1024.0)
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

