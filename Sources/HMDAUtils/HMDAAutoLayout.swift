//
//  HMDAAutoLayout.swift
//  HMDAUtils
//
//  Created by Konstantinos Kontos on 20/10/20.
//
//  Modified and extended: Originally and inspired by: https://www.swiftbysundell.com/articles/building-dsls-in-swift/

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

public protocol HMDALayoutDimension {
    func constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: Self, multiplier m: CGFloat) -> NSLayoutConstraint
    func constraint(equalTo anchor: Self, multiplier m: CGFloat, constant c: CGFloat) -> NSLayoutConstraint
}

extension NSLayoutAnchor: HMDALayoutAnchor {}

extension NSLayoutDimension: HMDALayoutDimension {}

public struct HMDALayoutProperty<Anchor: HMDALayoutAnchor> {
    fileprivate let anchor: Anchor
}

public struct HMDALayoutDimensionProperty<Dimension: HMDALayoutDimension> {
    fileprivate let dimension: Dimension
}

public class HMDALayoutProxy<V: HMDALayoutViewType> {
    public lazy var leading = property(with: view.leadingAnchor)
    public lazy var trailing = property(with: view.trailingAnchor)
    public lazy var top = property(with: view.topAnchor)
    public lazy var bottom = property(with: view.bottomAnchor)
    public lazy var width = property(with: view.widthAnchor)
    public lazy var height = property(with: view.heightAnchor)
    public lazy var centerXAnchor = property(with: view.centerXAnchor)
    public lazy var centerYAnchor = property(with: view.centerYAnchor)
    
    public lazy var widthDimension = dimensionProperty(with: view.widthAnchor)
    public lazy var heightDimension = dimensionProperty(with: view.heightAnchor)
    
    private let view: V
    
    fileprivate init(view: V) {
        self.view = view
    }
    
    private func property<A: HMDALayoutAnchor>(with anchor: A) -> HMDALayoutProperty<A> {
        return HMDALayoutProperty(anchor: anchor)
    }
    
    private func dimensionProperty<A: HMDALayoutDimension>(with dimension: A) -> HMDALayoutDimensionProperty<A> {
        return HMDALayoutDimensionProperty(dimension: dimension)
    }
    
}


public extension HMDALayoutDimensionProperty {
    
    func constraint(equalToConstant c: CGFloat) {
        dimension.constraint(equalToConstant: c).isActive = true
    }
    
    func constraint(equalTo anchor: Dimension, multiplier m: CGFloat) {
        dimension.constraint(equalTo: anchor, multiplier: m).isActive = true
    }
    
    func constraint(equalTo anchor: Dimension, multiplier m: CGFloat, constant c: CGFloat) {
        dimension.constraint(equalTo: anchor, multiplier: m, constant: c).isActive = true
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

public extension HMDALayoutViewType {
    
    func layout(using closure: (HMDALayoutProxy<HMDALayoutViewType>) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(HMDALayoutProxy(view: self))
    }
    
    func clearConstraints(in parentView: HMDALayoutViewType? = nil) {
        NSLayoutConstraint.deactivate(self.constraints.filter { (constraint) -> Bool in
            (constraint.secondItem != nil ? true : false)
        })
        parentView?.removeConstraints(forView: self)
    }
    
    func remake(using closure: (HMDALayoutProxy<HMDALayoutViewType>) -> Void) {
        clearConstraints(in: self.superview)
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
