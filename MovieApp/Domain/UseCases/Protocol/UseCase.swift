//
//  UseCase.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
