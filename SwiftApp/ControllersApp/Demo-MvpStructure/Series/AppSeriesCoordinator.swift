//
//  AppCoordinator.swift
//  SwiftApp
//
//  Created by Dylan Bui on 10/14/19.
//  Copyright © 2019 Propzy Viet Nam. All rights reserved.
//

import Foundation

class AppSeriesCoordinator: DbCoordinator
{
    private let window: UIWindow
    
    var childCoordinators: [DbCoordinator] = []
    var navigator: DbNavigatorType
    let navigationController: UINavigationController
    
    var vlcSeries: MvpSeriesViewController?
    var vlcSeriesDetail: MvpSeriesDetailViewController?
    
    // var starterCoordinator: DbCoordinator?
    
    init(window: UIWindow = UIWindow(),
         navigationController: UINavigationController = UINavigationController())
    {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        self.navigationController = navigationController
        self.navigator = DbNavigator(navigationController: navigationController)

        self.setupStarterCoordinator()
    }
    
    func setupStarterCoordinator()
    {
        
        // starterCoordinator = SeriesCoordinator(navigationController: navigationController)
    }
    
    func start()
    {
        // starterCoordinator?.start()
        
        self.vlcSeries = MvpSeriesViewController()
        self.vlcSeries?.gotoDelegate = self
        self.navigator.push(self.vlcSeries!, animated: true) {
            print("Da pop MvpSeriesViewController")
        }
    }
}

extension AppSeriesCoordinator: MvpSeriesViewControllerGotoDelegate
{
    func gotoMvpSeriesDetail(_ controller: MvpSeriesViewController, item: MvpSeries)
    {
        self.vlcSeriesDetail = MvpSeriesDetailViewController()
        self.vlcSeriesDetail?.presenter = MvpSeriesDetailPresenter.init(ui: self.vlcSeriesDetail!, seriesName: item.name)
        self.vlcSeriesDetail?.dataSource = MvpSeriesDetailCollectionViewDataSource()
        
        // self.navigationController?.pushViewController(vcl, animated: true)
        self.navigator.push(self.vlcSeriesDetail!, animated: true) {
            print("Da pop MvpSeriesDetailViewController")
        }

    }

}
