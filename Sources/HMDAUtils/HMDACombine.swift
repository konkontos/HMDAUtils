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
