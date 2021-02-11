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
import About

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

    router.viewController = view
    
    return view
  }
  
  func buildAbout() -> UIViewController {
    let aboutUseCase: Interactor<
      Any,
      AboutDomainModel,
      GetAboutRepository> = Injection.init().provideAbout()
    let presenter = GetAboutPresenter(aboutUseCase: aboutUseCase)
    let view = AboutView(presenter: presenter)
    
    return view
  }
  
  func buildWatchlist() -> UIViewController {
    
    let interactor: Interactor<
      Any,
      [LaunchWatchlistDomainModel],
      GetWatchlistRepository<
        GetWatchlistLocalDataSource,
        WatchlistTransformer>
    > = Injection.init().provideGetWatchList()
  
    let presenter = GetListPresenter(useCase: interactor)
    let router = LaunchWatchlistRouter()
    let view = LaunchWatchlistView(presenter: presenter)
    router.viewController = view
    
    return view
    
  }
}
