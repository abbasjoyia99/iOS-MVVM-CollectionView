//
//  BackButtonEmptyTitleNavigationBarBehavior.swift
//  MovieApp
//
//  Created by Developer on 14/04/2022.
//

import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
