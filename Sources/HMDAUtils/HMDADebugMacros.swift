//
//  HMDADebugNewMacros.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 28/06/2018.
//

import Foundation

#if canImport(os)
import os
#endif

public enum OSLogPromptCharacter: String {
    case debug = "📢"
    case error = "❗️"
    case info = "🔵"
}

#if canImport(os) && DEBUG

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(_ argStr: String) {
    os_log("📢 DEBUG: %@", log: OSLog.default, type: .debug, argStr)
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(_ argStr: String) {
    os_log("❗️ ERROR: %@", log: OSLog.default, type: .default, argStr)
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(_ argStr: String) {
    os_log("🔵 INFO: %@", log: OSLog.default, type: .info, argStr)
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "📢 DEBUG: %@", log: OSLog.default, type: .debug, args)
    } else {
        os_log(format ?? "📢 DEBUG: %@", log: logger!, type: .debug, args)
    }
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "❗️ ERROR: %@", log: OSLog.default, type: .default, args)
    } else {
        os_log(format ?? "❗️ ERROR: %@", log: logger!, type: .default, args)
    }
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "🔵 INFO: %@", log: OSLog.default, type: .info, args)
    } else {
        os_log(format ?? "🔵 INFO: %@", log: logger!, type: .info, args)
    }
    
}

#elseif canImport(os) && DEBUG_ERROR

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(_ argStr: String) {
    os_log("❗️ ERROR: %@", log: OSLog.default, type: .default, argStr)
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "❗️ ERROR: %@", log: OSLog.default, type: .default, args)
    } else {
        os_log(format ?? "❗️ ERROR: %@", log: logger!, type: .default, args)
    }
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

#elseif canImport(os) && DEBUG_INFO

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(_ argStr: String) {
    os_log("🔵 INFO: %@", log: OSLog.default, type: .info, argStr)
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
    if logger == nil {
        os_log(format ?? "🔵 INFO: %@", log: OSLog.default, type: .info, args)
    } else {
        os_log(format ?? "🔵 INFO: %@", log: logger!, type: .info, args)
    }
    
}

#elseif canImport(os)

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(_ argStr: String) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(_ argStr: String) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(_ argStr: String) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogDebug(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogError(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

@available(iOS 14, macOS 10.10, tvOS 14, watchOS 7, macCatalyst 13, *)
public func OSLogInfo(logger:OSLog?, _ format:StaticString?, _ args: CVarArg...) {
    
}

#endif
