//
//  BlackStyleNavigationBarBehavior.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
