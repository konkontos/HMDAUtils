//
//  HMDAUtils.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 20/09/2016.
//

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

import AVFoundation

public typealias NotificationUserInfo = [AnyHashable: Any]

public typealias VoidClosure = () -> Void

public func delayedRun(interval: TimeInterval, code: @escaping VoidClosure) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval) {
        code()
    }
}

public func mainQueueRun(code: @escaping VoidClosure) {
    DispatchQueue.main.async {
        code()
    }
}

#if canImport(UIKit)
public extension UIDeviceOrientation {
    
    var interfaceOrientation: UIInterfaceOrientationMask {
        
        switch self {
            
        case .portrait:
            return .portrait
            
        case .portraitUpsideDown:
            return .portraitUpsideDown
            
        case .landscapeLeft:
            return .landscapeLeft
            
        case .landscapeRight:
            return .landscapeRight
            
        default:
            return .all
            
        }
        
    }
    
}
#endif

#if canImport(UIKit)
public extension UIColor {
    
    var asCSSRGBAStr: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
    
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
        red = red * 255.0
        green = green * 255.0
        blue = blue * 255.0
    
        return "rgba(\(Int(red)),\(Int(green)),\(Int(blue)),\(alpha))"
    }
    
}
#endif


#if os(macOS)
public extension NSColor {
    
    var asCSSRGBAStr: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
    
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    
        red = red * 255.0
        green = green * 255.0
        blue = blue * 255.0
    
        return "rgba(\(Int(red)),\(Int(green)),\(Int(blue)),\(alpha))"
    }
    
}
#endif

public extension URL {
    
    var exists: Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    var folderContents: [URL]? {
        return try? FileManager.default.contentsOfDirectory(at: self,
                                                includingPropertiesForKeys: nil,
                                                options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
    }
    
    var fileContents: String? {
        return try? String(contentsOf: self)
    }
    
    #if canImport(UIKit)
    var imageContents: UIImage? {
        return UIImage(contentsOfFile: self.path)
    }
    #endif
    
    #if os(macOS)
    var imageContents: NSImage? {
        NSImage(contentsOf: self)
    }
    #endif
    
    mutating func setSkipBackupAttribute() {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        
        _ = try? setResourceValues(resourceValues)
    }
    
    func eraseFile() throws {
        try FileManager.default.removeItem(at: self)
    }
    
    func eraseAllFiles() throws {
        
        if let folderContents = self.folderContents {
            
            for url in folderContents {
                try url.eraseFile()
            }
            
        }
        
    }
    
    func streamCopy(toURL destinationURL: URL, appending: Bool) {
        let inputStream = InputStream(url: self)
        let outputStream = OutputStream(url: destinationURL, append: appending)
        
        inputStream?.open()
        outputStream?.open()
        
        var buffer = [UInt8](repeating: 0, count: 1024)
        
        var bytesRead = inputStream?.read(&buffer, maxLength: 1024)
        
        while bytesRead! > 0 {
            outputStream?.write(buffer, maxLength: bytesRead!)
            bytesRead = inputStream?.read(&buffer, maxLength: 1024)
        }
        
        outputStream?.close()
        inputStream?.close()
    }
    
    #if canImport(UIKit)
    func thumbnailForVideo(atPlaybackSeconds seconds: Double) -> UIImage? {
        let videoAsset = AVURLAsset(url: self)
        let assetGenerator = AVAssetImageGenerator(asset: videoAsset)
        let thumbnailSnapshotTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(exactly: 1.0)!)
        
        guard let cgImage = try? assetGenerator.copyCGImage(at: thumbnailSnapshotTime, actualTime: nil) else {
            return nil
        }
        
        let thumbnail = UIImage(cgImage: cgImage)
        
        return thumbnail
    }
    #endif
    
    #if os(macOS)
    func thumbnailForVideo(atPlaybackSeconds seconds: Double) -> NSImage? {
        let videoAsset = AVURLAsset(url: self)
        let assetGenerator = AVAssetImageGenerator(asset: videoAsset)
        let thumbnailSnapshotTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(exactly: 1.0)!)
        
        guard let cgImage = try? assetGenerator.copyCGImage(at: thumbnailSnapshotTime, actualTime: nil) else {
            return nil
        }
        
        let thumbnail = NSImage(cgImage: cgImage,
                                size: NSSize(width: cgImage.width, height: cgImage.height))
        
        return thumbnail
    }
    #endif
    
}

public extension URLResponse {
    
    var contentLength: Int {
        let httpResponse = (self as! HTTPURLResponse)
        return Int((httpResponse.allHeaderFields["Content-Length"] as! String))!
    }
    
}

public extension NSObject {
    
    static var classStr: String {
        return classForCoder().description().components(separatedBy: ".").last!
    }
    
}

public extension Data {
    
    var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: .allowFragments)
    }
    
    var asUTF8Str: String? {
        return String(data: self, encoding: .utf8)
    }
    
}

public extension String {
    
    static var nonBreakingSpace: String {
        return "\u{00A0}"
    }
    
    var formattedForNonOrphanWrapping: String {
        let reversedString = String(self.reversed())
        
        if let lastSpaceRange = reversedString.range(of: " ") {
            
            let fixedStr = reversedString.replacingOccurrences(of: " ",
                                                               with: " \(String.nonBreakingSpace) ",
                options: .anchored,
                range: lastSpaceRange)
            
            return String(fixedStr.reversed())
        } else {
            return self
        }
        
    }
    
    var jsonObject: JSONObject? {
        return JSONSerialization.jsonObject(fromJSON: self) as? JSONObject
    }
    
    var jsonArray: JSONArray? {
        return JSONSerialization.jsonObject(fromJSON: self) as? JSONArray
    }
    
    var fileContents: String? {
        return try? String(contentsOfFile: self)
    }
    
    var fileDataContents: Data? {
        
        if let contents = try? String(contentsOfFile: self) {
            return contents.data(using: .utf8)
        } else {
            return nil
        }
        
    }
    
    var bundledPath: String? {
        return Bundle.main.path(forResource: self, ofType: nil)
    }
    
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    
    func regexMatches(pattern: String, options: NSRegularExpression.Options) -> [Substring]? {
        
        if let regex = try? NSRegularExpression(pattern: pattern,
                                                options: options) {
            
            let results = regex.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
            
            var matches: [Substring]?
            
            for result in results {
                
                if result.numberOfRanges == 1 {
                    
                    let startIndex = self.index(self.startIndex, offsetBy: result.range.location)
                    let endIndex = self.index(self.startIndex, offsetBy: result.range.length + result.range.location - 1)
                    
                    let substr = self[startIndex...endIndex]
                    
                    if matches == nil {
                        matches = [Substring]()
                    }
                    
                    matches?.append(substr)
                } else {
                    var n = 1
                    
                    while n < result.numberOfRanges {
                        let captureGroupRange = result.range(at: n)
                        
                        if captureGroupRange.location >= self.count {
                            return nil
                        }
                        
                        let startIndex = self.index(self.startIndex, offsetBy: captureGroupRange.location)
                        let endIndex = self.index(self.startIndex, offsetBy: captureGroupRange.length + captureGroupRange.location - 1)
                        
                        let substr = self[startIndex...endIndex]
                        
                        if matches == nil {
                            matches = [Substring]()
                        }
                        
                        matches?.append(substr)
                        
                        n += 1
                    }
                    
                }
                
            }
            
            return matches
            
        } else {
            return nil
        }
        
    }

    var asURL: URL? {
        return URL(string: self)
    }
    
    var asURLEncodedStr: String {
        let encodedStr = self.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        return encodedStr ?? self
    }
    
    #if canImport(UIKit)
    
    var asRGBColor: UIColor? {
        
        guard hasPrefix("#") else {
            return nil
        }
        
        let hexString = self[self.index(self.startIndex, offsetBy: 1)...]
        
        guard hexString.count == 6 else {
            return nil
        }
        
        var hexValue: Float = 0
        
        // Get RED value
        var subStr = String(hexString)[index(startIndex, offsetBy: 0)..<index(startIndex, offsetBy: 2)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let redComponent = hexValue / 255.0
        
        
        // Get GREEN value
        subStr = String(hexString)[index(startIndex, offsetBy: 2)..<index(startIndex, offsetBy: 4)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let greenComponent = hexValue / 255.0
        
        
        // Get BLUE value
        subStr = String(hexString)[index(startIndex, offsetBy: 4)..<index(startIndex, offsetBy: 6)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let blueComponent = hexValue / 255.0
        
        return UIColor(red: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }
    
    func rgbColor(withAlpha alpha: Float) -> UIColor? {
        guard let color = asRGBColor else {
            return nil
        }
        
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        
        color.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: CGFloat(alpha))
    }
    
    func attributedString(withColor color: UIColor) -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.foregroundColor] = color
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    #endif
    
    #if os(macOS)
    
    var asRGBColor: NSColor? {
        
        guard hasPrefix("#") else {
            return nil
        }
        
        let hexString = self[self.index(self.startIndex, offsetBy: 1)...]
        
        guard hexString.count == 6 else {
            return nil
        }
        
        var hexValue: Float = 0
        
        // Get RED value
        var subStr = String(hexString)[index(startIndex, offsetBy: 0)..<index(startIndex, offsetBy: 2)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let redComponent = hexValue / 255.0
        
        
        // Get GREEN value
        subStr = String(hexString)[index(startIndex, offsetBy: 2)..<index(startIndex, offsetBy: 4)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let greenComponent = hexValue / 255.0
        
        
        // Get BLUE value
        subStr = String(hexString)[index(startIndex, offsetBy: 4)..<index(startIndex, offsetBy: 6)]
        
        Scanner(string: "0x\(subStr)").scanHexFloat(&hexValue)
        let blueComponent = hexValue / 255.0
        
        return NSColor(calibratedRed: CGFloat(redComponent), green: CGFloat(greenComponent), blue: CGFloat(blueComponent), alpha: 1.0)
    }
    
    func rgbColor(withAlpha alpha: Float) -> NSColor? {
        guard let color = asRGBColor else {
            return nil
        }
        
        var redComponent: CGFloat = 0
        var greenComponent: CGFloat = 0
        var blueComponent: CGFloat = 0
        var alphaComponent: CGFloat = 0
        
        color.getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
        
        return NSColor(calibratedRed: redComponent, green: greenComponent, blue: blueComponent, alpha: CGFloat(alpha))
    }
    
    func attributedString(withColor color: NSColor) -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        attributes[NSAttributedString.Key.foregroundColor] = color
        
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    #endif
    
    var asHTMLAttrStr: NSAttributedString? {
        let attrStr = try? NSAttributedString(data: self.data(using: .utf8)!,
                                              options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attrStr
    }
    
    func htmlAttrStr(usingSourceEncoding encoding: String.Encoding) -> NSAttributedString? {
        let attrStr = try? NSAttributedString(data: self.data(using: encoding)!,
                                              options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        return attrStr
    }
    
    var asUnicodeUnescapedStr: String? {
        let regex = try? NSRegularExpression(pattern: "\\\\U(\\d{4})", options: NSRegularExpression.Options.dotMatchesLineSeparators)
        
        let mutableRawStr = NSMutableString(string: self)
        
        if regex!.replaceMatches(in: mutableRawStr,
                                 options: NSRegularExpression.MatchingOptions.reportCompletion,
                                 range: NSMakeRange(0, self.count),
                                 withTemplate: "\\\\u$1") > 0 {
            
            if let cString = mutableRawStr.cString(using: String.Encoding.utf8.rawValue) {
                
                if let unEscapedString = NSString(cString: cString, encoding: String.Encoding.nonLossyASCII.rawValue) {
                    return unEscapedString as String
                } else {
                    return self
                }
                
            } else {
                
                return self
                
            }
            
        } else {
            
            return self
            
        }
        
    }
    
    func serverDate(withFormat dateFormat: String) -> Date? {
        // 2015-04-23T01:11:00.000Z
        // "yyyy-MM-dd'T'HH:mm:ss'.'zzz'Z'"
        
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale.autoupdatingCurrent
        inputFormatter.dateFormat = dateFormat
        
        return inputFormatter.date(from: self)
    }
    
    
    
}

public extension FileManager {
    
    func cleanup(folder: URL) {
        
        if let contents = try? contentsOfDirectory(atPath: folder.path) {
            
            for file in contents {
                
                let filePathURL = folder.appendingPathComponent(file)
                
                _ = try? removeItem(at: filePathURL)
            }
            
        }
        
    }
    
    func cleanupTempDir() {
        
        if let contents = try? FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory()) {
            
            for file in contents {
                var filePathURL = URL(fileURLWithPath: NSTemporaryDirectory())
                filePathURL.appendPathComponent(file)
                _ = try? FileManager.default.removeItem(at: filePathURL)
            }
            
        }
        
    }

    class var applicationCachesDocumentsFolder: URL {
        let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    class var applicationDocumentsFolder: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    class var temporaryFolder: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    class var applicationSupportFolder: URL {
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }
    
    func sizeForItem(atFileURL url: URL) -> UInt64 {
        
        if let fileAttrs = try? self.attributesOfItem(atPath: url.path) {
            let byteCount = (fileAttrs as NSDictionary).fileSize()
            return byteCount
        } else {
            return 0
        }
        
    }
    
    
    // via Ole Begemann
    // (https://oleb.net/blog/2018/03/temp-file-helper/?utm_campaign=Swift%2BWeb%2BWeekly&utm_medium=email&utm_source=Swift_Web_Weekly_50)
    /// Creates a temporary directory with a unique name and returns its URL.
    ///
    /// - Returns: A tuple of the directory's URL and a delete function.
    ///   Call the function to delete the directory after you're done with it.
    ///
    /// - Note: You should not rely on the existence of the temporary directory
    ///   after the app is exited.
    func urlForUniqueTemporaryDirectory(preferredName: String? = nil) throws
        -> (url: URL, deleteDirectory: () throws -> Void)
    {
        let basename = preferredName ?? UUID().uuidString
        
        var counter = 0
        var createdSubdirectory: URL? = nil
        repeat {
            do {
                let subdirName = counter == 0 ? basename : "\(basename)-\(counter)"
                let subdirectory = temporaryDirectory
                    .appendingPathComponent(subdirName, isDirectory: true)
                try createDirectory(at: subdirectory, withIntermediateDirectories: false)
                createdSubdirectory = subdirectory
            } catch CocoaError.fileWriteFileExists {
                // Catch file exists error and try again with another name.
                // Other errors propagate to the caller.
                counter += 1
            }
        } while createdSubdirectory == nil
        
        let directory = createdSubdirectory!
        let deleteDirectory: () throws -> Void = {
            try self.removeItem(at: directory)
        }
        return (directory, deleteDirectory)
    }
    
}

public extension TimeInterval {
    
    static var halfHour: TimeInterval {
        return 30.0 * 60.0
    }
    
    static var hour: TimeInterval {
        return 60.0 * 60.0
    }
    
    static var day: TimeInterval {
        return 24.0 * 60.0 * 60.0
    }
    
    static var fiveMin: TimeInterval {
        return 5 * 60.0
    }
    
    static var tenMin: TimeInterval {
        return 10 * 60.0
    }
    
    static var minute: TimeInterval {
        return 60.0
    }
    
}

public extension Bundle {
    
    class func bundleValue(forRootKey key: String) -> Any? {
        return Bundle.main.infoDictionary![key]
    }

    class var version: String {
        return Bundle.bundleValue(forRootKey: "CFBundleShortVersionString") as! String
    }
    
    class var build: String {
        return Bundle.bundleValue(forRootKey: "CFBundleVersion") as! String
    }
    
}


// via Ole Begemann
// (https://oleb.net/blog/2018/03/temp-file-helper/?utm_campaign=Swift%2BWeb%2BWeekly&utm_medium=email&utm_source=Swift_Web_Weekly_50)

/// A wrapper around a temporary file in a temporary directory. The directory
/// has been especially created for the file, so it's safe to delete when you're
/// done working with the file.
///
/// Call `deleteDirectory` when you no longer need the file.
struct TemporaryFile {
    let directoryURL: URL
    let fileURL: URL
    /// Deletes the temporary directory and all files in it.
    let deleteDirectory: () throws -> Void
    
    /// Creates a temporary directory with a unique name and initializes the
    /// receiver with a `fileURL` representing a file named `filename` in that
    /// directory.
    ///
    /// - Note: This doesn't create the file!
    init(creatingTempDirectoryForFilename filename: String) throws {
        let (directory, deleteDirectory) = try FileManager.default
            .urlForUniqueTemporaryDirectory()
        self.directoryURL = directory
        self.fileURL = directory.appendingPathComponent(filename)
        self.deleteDirectory = deleteDirectory
    }
}


public extension Sequence where Self.Element: Hashable {
    
    var containsDuplicates: Bool {
        Dictionary(grouping: self){$0}.filter {$1.count > 1}.keys.count > 0
    }
    
}
