//
//  Instantiable.swift
//  Tech_Accel_Travel_Book
//
//  Created by 新垣 清奈 on 2023/01/22.
//

import UIKit

protocol Instantiatable {
    associatedtype DependencyType
    init?(coder: NSCoder, dependencyType: DependencyType)
}

extension Instantiatable where Self: UIViewController {
    init?(coder: NSCoder, dependencyType: DependencyType) {
        fatalError("\(String(describing: Self.self)) is required any initializer")
    }

    static func instantiate(with dependencyType: DependencyType) -> Self {
        let storyboardName = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        guard let viewController = storyboard.instantiateInitialViewController(creator: { coder in
            Self(coder: coder, dependencyType: dependencyType)
        }) else {
            fatalError("Unable to create \(storyboardName)")
        }
        return viewController
    }
}

extension Instantiatable where Self: UIViewController, DependencyType == DependencyType {
    static func instantiate(dependencyType: DependencyType) -> Self {
        instantiate(with: dependencyType)
    }
}
