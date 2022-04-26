//
//  CGSize+ScaledSize.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
