//
//  SeriesCoordinator.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/14/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

// Ko su dung vi ko can child Coordinator

class SeriesCoordinator: DbCoordinator
{
    var childCoordinators: [DbCoordinator] = []
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController = UINavigationController())
    {
        self.navigationController = navigationController
    }
    
    func start() {
        showFirstScene()
    }
}

extension SeriesCoordinator
{
    func showFirstScene()
    {
        // -- chua tao ne no chua hien thi o day --
//        let scene = FeatureSceneFactory.makeFirstScene(delegate: self)
//        navigationController.viewControllers = [scene]
    }
    
    func showSecondScene(userName: String)
    {
//        let scene = FeatureSceneFactory.makeSecondScene(userName: userName)
//        navigationController.pushViewController(scene, animated: true)
    }
}

//extension SeriesCoordinator: FirstViewPresenterDelegate {
//    func didEnterName(_ userName: String) {
//        showSecondScene(userName: userName)
//    }
//}
