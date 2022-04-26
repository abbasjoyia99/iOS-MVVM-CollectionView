//
//  RepositoryTask.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
