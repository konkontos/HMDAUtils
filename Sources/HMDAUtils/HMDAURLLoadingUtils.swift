//
//  HMDAURLLoadingUtils.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 19/10/20.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public class HMDAURL {
    
}

public extension HMDAURL {

    class GlobalURLSession: URLSession {
        
        public static let sharedInstance = URLSession(configuration: HMDAURL.GlobalURLSession.sessionConfig)
        
        public static let timeout = 60
        
        public class var sessionConfig: URLSessionConfiguration {
            let sessionCache = URLCache(memoryCapacity: 1 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: "http_cache")
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = sessionCache
            sessionConfig.timeoutIntervalForRequest = Double(timeout)
            sessionConfig.requestCachePolicy = NSURLRequest.CachePolicy.returnCacheDataElseLoad
            
            return sessionConfig
        }
        
    }
    
}


