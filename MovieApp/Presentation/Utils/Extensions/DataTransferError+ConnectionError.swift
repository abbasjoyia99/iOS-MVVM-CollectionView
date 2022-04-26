//
//  DataTransferError+ConnectionError.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
