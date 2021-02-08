//
//  LaunchWatchlistRouter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 20/11/20.
//

import UIKit

protocol LaunchWatchlistRouterProtocol {
  
  func showLaunchDetail(with launch: LaunchModel)
  
}

class LaunchWatchlistRouter {
  
  weak var viewController: UIViewController?
  
}

extension LaunchWatchlistRouter: LaunchWatchlistRouterProtocol {
  
  func showLaunchDetail(with launch: LaunchModel) {
    
    let launchDetailVC = buildDetail(launch)
    self.viewController?.navigationController?.pushViewController(launchDetailVC, animated: true)
    
  }
  
  func buildDetail(_ launch: LaunchModel) -> UIViewController {
    
//    let view = LaunchDetailView()
//    var interactor = Injection.init().provideLaunchDetail(launch: launch)
//    let presenter = LaunchDetailPresenter()
//    let router = LaunchDetailRouter()
//    
//    view.presenter = presenter
//    
//    presenter.view = view
//    presenter.interactor = interactor
//    presenter.router = router
//    
//    interactor.presenter = presenter
//    
//    router.presenter = presenter
//    router.viewController = view
//    
//    return view
    return UIViewController()
    
  }
  
}
