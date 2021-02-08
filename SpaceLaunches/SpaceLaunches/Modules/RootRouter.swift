//
//  RootRouter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 02/12/20.
//

import UIKit

class RootRouter {
  
  var homeViewController: UIViewController?
  
  func setupLaunch(window: UIWindow) {
    
    homeViewController = buildHome()
    window.rootViewController = homeViewController
    
  }
  
  func buildHome() -> UIViewController {
    
    let view = HomeView()
    var interactor = Injection().provideHome()
    let presenter = HomePresenter()
    let router = HomeRouter()
    
    view.presenter = presenter
    
    presenter.view = view
    presenter.interactor = interactor
    presenter.router = router
    
    interactor.presenter = presenter
    
    router.presenter = presenter
    router.viewController = view
    
    presenter.setupViewControllers()
    
    return view
  }
  
}
