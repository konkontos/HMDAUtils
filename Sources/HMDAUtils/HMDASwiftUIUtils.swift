//
//  HMDASwiftUIUtils.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 16/10/20.
//

#if canImport(SwiftUI)
import SwiftUI
#endif

#if canImport(UIKit)
import UIKit
#endif

#if canImport(Cocoa)
import Cocoa
#endif


#if canImport(SwiftUI) && canImport(UIKit)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, macCatalyst 13, *)
public struct FontModifier: ViewModifier {
    
    var font: UIFont
    
    public func body(content: Content) -> some View {
        content.font(Font(font))
    }
    
}
#endif

#if canImport(SwiftUI)
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, macCatalyst 13, *)
public extension UIFont {
    
    var swiftUIModifier: FontModifier {
        return FontModifier(font: self)
    }
    
}
#endif

#if canImport(SwiftUI)
@available(iOS 13, tvOS 13, watchOS 6, macCatalyst 13, *)
public struct TextFieldWithEraseButton: ViewModifier {
    
    var color: Color
    
    var closure: (() -> Void)?
    
    @Binding var text: String
    
    public init(withBoundText text: Binding<String>, andColor color: Color, closure: (() -> Void)? = nil) {
        self.color = color
        self.closure = closure
        self._text = text
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(Button(action: {
            self.text = ""
            self.closure?()
        }) {
            
                Image(systemName: "xmark.circle.fill").padding([.trailing], 8.0)
            
            },
            alignment: .trailing)
            .foregroundColor(color)
    }
    
}
#endif
