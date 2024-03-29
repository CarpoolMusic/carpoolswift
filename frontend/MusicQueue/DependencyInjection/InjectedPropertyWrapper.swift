//
//  InjectedPropertyWrapper.swift
//  MusicQueue
//
//  Created by Nolan Biscaro on 2024-03-14.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T

    init() {
        self.wrappedValue = DependencyContainer.resolve(T.self)
    }
}
