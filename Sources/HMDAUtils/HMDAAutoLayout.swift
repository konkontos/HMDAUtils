//
//  HMDAAutoLayout.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 20/10/20.
//
//  Modified: Originally by: https://www.swiftbysundell.com/articles/building-dsls-in-swift/

import Foundation

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
#endif

public protocol HMDALayoutAnchor {
    func constraint(equalTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(greaterThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
    func constraint(lessThanOrEqualTo anchor: Self,
                    constant: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: HMDALayoutAnchor {}

public struct HMDALayoutProperty<Anchor: HMDALayoutAnchor> {
    fileprivate let anchor: Anchor
}

public class HMDALayoutProxy {
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    
    private let view: UIView
    
    fileprivate init(view: UIView) {
        self.view = view
    }
    
    private func property<A: HMDALayoutAnchor>(with anchor: A) -> HMDALayoutProperty<A> {
        return HMDALayoutProperty(anchor: anchor)
    }
}

public extension HMDALayoutProperty {
    func equal(to otherAnchor: Anchor, offsetBy
                constant: CGFloat = 0) {
        anchor.constraint(equalTo: otherAnchor,
                          constant: constant).isActive = true
    }
    
    func greaterThanOrEqual(to otherAnchor: Anchor,
                            offsetBy constant: CGFloat = 0) {
        anchor.constraint(greaterThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
    
    func lessThanOrEqual(to otherAnchor: Anchor,
                         offsetBy constant: CGFloat = 0) {
        anchor.constraint(lessThanOrEqualTo: otherAnchor,
                          constant: constant).isActive = true
    }
}

public extension UIView {
    func layout(using closure: (HMDALayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(HMDALayoutProxy(view: self))
    }
}

func +<A: HMDALayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, rhs)
}

func -<A: HMDALayoutAnchor>(lhs: A, rhs: CGFloat) -> (A, CGFloat) {
    return (lhs, -rhs)
}

func ==<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>,
                         rhs: (A, CGFloat)) {
    lhs.equal(to: rhs.0, offsetBy: rhs.1)
}

func ==<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>, rhs: A) {
    lhs.equal(to: rhs)
}

func >=<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>,
                         rhs: (A, CGFloat)) {
    lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func >=<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>, rhs: A) {
    lhs.greaterThanOrEqual(to: rhs)
}

func <=<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>,
                         rhs: (A, CGFloat)) {
    lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
}

func <=<A: HMDALayoutAnchor>(lhs: HMDALayoutProperty<A>, rhs: A) {
    lhs.lessThanOrEqual(to: rhs)
}
