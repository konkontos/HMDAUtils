//
//  HMDAReachability.swift
//  HMDAToolkit
//
//  Created by Konstantinos Kontos on 20/09/2016.
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif

public typealias JSONObject = [String: Any]
public typealias JSONArray = [JSONObject]
public typealias NotificationDict = [AnyHashable : Any]

fileprivate func jsonStr(fromObject jsonObject: Any, pretty: Bool) -> String? {
    let memoryStream = OutputStream.toMemory()
    
    memoryStream.open()
    
    let errorPointer: NSErrorPointer = nil
    
    if pretty == true {
        JSONSerialization.writeJSONObject(jsonObject, to: memoryStream, options: .prettyPrinted, error: errorPointer)
    } else {
        JSONSerialization.writeJSONObject(jsonObject, to: memoryStream, options: [], error: errorPointer)
    }

    if errorPointer?.pointee == nil {
        let stringData = memoryStream.property(forKey: .dataWrittenToMemoryStreamKey) as! Data
        
        memoryStream.close()
        
        let jsonStr = String(data: stringData, encoding: .utf8)
        
        return jsonStr
    } else {
        return nil
    }
    
}

public extension Array {
    
    func jsonPrettyStr() -> String? {
        return jsonStr(fromObject: self, pretty: true)
    }
    
    func jsonPlainStr() -> String? {
        return jsonStr(fromObject: self, pretty: false)
    }
    
}

public extension Dictionary {
    
    var jsonPrettyStr: String? {
        jsonStr(fromObject: self, pretty: true)
    }
    
    var jsonPlainStr: String? {
        jsonStr(fromObject: self, pretty: false)
    }
    
}

public extension JSONSerialization {
    
    class func jsonObject(fromAssetNamed assetName: String) -> Any? {
        
        #if os(macOS)
        return NSDataAsset(name: NSDataAsset.Name(assetName))?.data.jsonObject
        #else
        return NSDataAsset(name: NSDataAssetName(assetName))?.data.jsonObject
        #endif
        
    }
    
    class func jsonObject(from pathURL: URL) -> Any? {
        return JSONSerialization.jsonObject(fromPath: pathURL.path)
    }
        
    class func jsonObject(fromPath path: String) -> Any? {
        
        let contentURL = URL(fileURLWithPath: path)
        
        if let jsonData = try? Data(contentsOf: contentURL) {
            return try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        } else {
            return nil
        }
        
    }
    
    class func jsonObject(fromJSON json: String) -> Any? {
        
        if let jsonData = json.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
        } else {
            return nil
        }
        
    }
    
}

public protocol JSONTransformable {
    associatedtype DBObject: Codable
    
    static func fromJSON<T: Codable>(jsonObject: JSONObject) -> T?
    
    var asJSON: Any? {get}
}

public extension JSONTransformable {
    
    static func fromJSON<T: Codable>(jsonObject: JSONObject) -> T? {
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) {
            
            let jsonDecoder = JSONDecoder()
            
            let decodedObject = try? jsonDecoder.decode(T.self, from: jsonData)
            
            return decodedObject
            
        } else {
            return nil
        }
        
    }
    
    var asJSON: Any? {
        
        let jsonEncoder = JSONEncoder()
        
        if let jsonData = try? jsonEncoder.encode(self as! DBObject) {
            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            
            return jsonObject
        } else {
            return nil
        }
        
    }
    
}


public extension URL {
    
    var jsonObject: Any? {
        JSONSerialization.jsonObject(from: self)
    }
    
}


public extension Encodable {
    
    func jsonEncodedData() throws -> Data {
        return try JSONEncoder().encode(self)
    }
    
}


public extension Data {
    
    func decodedJSONData<T: Decodable>() throws -> T {
        return try JSONDecoder().decode(T.self, from: self)
    }
    
}
