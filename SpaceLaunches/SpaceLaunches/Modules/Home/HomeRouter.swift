//
//  HomeRouter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import UIKit
import Core
import Home
import Watchlist

protocol HomeRouterProtocol {
  
  var presenter: HomePresenterProtocol? { get set }
  func getViewControllers() -> [UIViewController]
  
}

class HomeRouter {
  
  weak var presenter: HomePresenterProtocol?
  weak var viewController: UIViewController?
  
}

extension HomeRouter: HomeRouterProtocol {
  
  func getViewControllers() -> [UIViewController] {
    
    let launchVC = buildLaunches()
    launchVC.tabBarItem = UITabBarItem(title: "Launches", image: UIImage(named: "launches-true"), tag: 0)
    
    let watchlistVC = buildWatchlist()
    watchlistVC.tabBarItem = UITabBarItem(title: "Watchlist", image: UIImage(named: "watchlist-true"), tag: 1)
    
    let aboutVC = buildAbout()
    aboutVC.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
    
    let launchNC = UINavigationController(rootViewController: launchVC)
    let watchlistNC = UINavigationController(rootViewController: watchlistVC)
    let aboutNC = UINavigationController(rootViewController: aboutVC)
    
    return [
      launchNC,
      watchlistNC,
      aboutNC
    ]
  }
  
  func buildLaunches() -> UIViewController {
//    let view = LaunchesView()
//    var interactor = Injection.init().provideLaunches()
//    let presenter = LaunchesPresenter()
    let upcomingGoLaunchesUseCase: Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>
      > = Injection.init().provideHomeUpcomingGoLaunches()
    
    let previousLaunchesUseCase: Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>
      > = Injection.init().provideHomePreviousLaunches()
    
    let presenter = GetHomeLaunchesPresenter(upcomingGoLaunchesUseCase: upcomingGoLaunchesUseCase, previousLaunchesUseCase: previousLaunchesUseCase)
    let router = LaunchesRouter()
    
    let view = LaunchesView(presenter: presenter)
//
//    presenter.view = view
//    presenter.interactor = interactor
//    presenter.router = router
//
//    interactor.presenter = presenter
//
//    router.presenter = presenter
    router.viewController = view
    
    return view
  }
  
  func buildAbout() -> UIViewController {
    let view = AboutView()
    var interactor = Injection.init().provideAbout()
    let presenter = AboutPresenter()
    let router = AboutRouter()
    
    view.presenter = presenter
    
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    
    interactor.presenter = presenter
    
    router.presenter = presenter
    router.viewController = view
    
    return view
  }
  
  func buildWatchlist() -> UIViewController {
    
//    var interactor = Injection.init().provideLaunchWatchlist()
    let interactor: Interactor<
      Any,
      [LaunchWatchlistDomainModel],
      GetWatchlistRepository<
        GetWatchlistLocalDataSource,
        WatchlistTransformer>
    > = Injection.init().provideGetWatchList()
    
//    let presenter = LaunchWatchlistPresenter()
    let presenter = GetListPresenter(useCase: interactor)
    let router = LaunchWatchlistRouter()
    let view = LaunchWatchlistView(presenter: presenter)
    
//    view.presenter = presenter
//
//    presenter.view = view
//    presenter.interactor = interactor
//    presenter.router = router
//
//    interactor.presenter = presenter
//
//    router.presenter = presenter
    router.viewController = view
    
    return view
    
  }
}
