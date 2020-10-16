//
//  HMDACombine.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import Foundation

#if canImport(Combine)

import Combine

@available(iOS 13, macOS 10.15, *)
public protocol CombineSubscriber {
    
    var combineSubscriptions: Set<AnyCancellable>? {get set}
    
}

#endif


// #if targetEnvironment(macCatalyst)
// #if targetEnvironment(simulator)
// #if os(macOS)
// #if os(iOS)
// #if arch(x86_64)
// #if arch(arm64)
// #if arch(i386)
// #if os(tvOS)
// if #available(tvOS 9.1,*)
// @available(iOS 9.0, *)
// #if TARGET_OS_IOS
// #if TARGET_OS_OSX
// #if TARGET_OS_MACCATALYST
// #if TARGET_OS_TV
// #if TARGET_OS_SIMULATOR
// #if canImport(UIKit) /* Check if a module presents */
// #if swift(<5) /* Check the Swift version */
// #if compiler(<7) /* Check compiler version */
