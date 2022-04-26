//
//  ConnectionError.swift
//  MovieApp
//
//  Created by Developer on 20/04/2022.
//

import Foundation
public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
