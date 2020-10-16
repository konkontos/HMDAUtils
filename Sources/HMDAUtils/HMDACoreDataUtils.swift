//
//  HMDACoreDataUtils.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 24/3/20.
//  Copyright © 2020 Handmade Apps Ltd. All rights reserved.
//

import Foundation
import CoreData

#if canImport(Cocoa)
import Cocoa
#endif

#if canImport(UIKit)
import UIKit
#endif

public protocol HMDAUtilsMOCContainer {
    var moc: NSManagedObjectContext? {get}
}


public extension NSManagedObject {
    
    class var viewContext: NSManagedObjectContext? {
        #if os(macOS)
        return (NSApplication.shared.delegate as? HMDAUtilsMOCContainer)?.moc
        #else
        return (UIApplication.shared.delegate as? HMDAUtilsMOCContainer)?.moc
        #endif
    }
    
    func delete(in context: NSManagedObjectContext? = nil) throws {
        
        guard context != nil || NSManagedObject.viewContext != nil else {
            return
        }
        
        if context != nil {
            context?.delete(self)
            try context?.save()
        } else {
            NSManagedObject.viewContext?.delete(self)
            try NSManagedObject.viewContext?.save()
        }
        
    }
    
    func save(in context: NSManagedObjectContext? = nil) throws {
        
        guard context != nil || NSManagedObject.viewContext != nil else {
            return
        }
        
        if context != nil {
            
            if context?.hasChanges ?? false {
                try context?.save()
            }
            
        } else {
            
            if NSManagedObject.viewContext?.hasChanges ?? false {
                try NSManagedObject.viewContext?.save()
            }
            
        }
        
    }
    
    class func new(in context: NSManagedObjectContext? = nil) -> Self? {
        guard context != nil || NSManagedObject.viewContext != nil else {
            return nil
        }
        
        var newObject: NSManagedObject?
        
        if context != nil {
            newObject = NSEntityDescription
                .insertNewObject(forEntityName: String(describing: self),
                                 into: context!)
        } else {
            newObject = NSEntityDescription
                .insertNewObject(forEntityName: String(describing: self),
                                 into: NSManagedObject.viewContext!)
        }
        
        guard newObject != nil else {
            return nil
        }
        
        return unsafeDowncast(newObject!, to: self)
    }
    
    class func allObjects<T: NSFetchRequestResult>(in context: NSManagedObjectContext? = nil) throws -> [T]? {
        guard context != nil || NSManagedObject.viewContext != nil else {
            return nil
        }
        
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        var requestResults: [T]?
        
        if context != nil {
            requestResults = try context!.fetch(request)
        } else {
            requestResults = try NSManagedObject.viewContext!.fetch(request)
        }
        
        guard (requestResults?.count ?? 0) > 0 else {
            return nil
        }
        
        return requestResults
    }
    
}
