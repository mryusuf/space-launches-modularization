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
    
    var interactor = Injection().provideHome()
    let router = HomeRouter()
    
    let presenter = HomePresenter(interactor: interactor, router: router)
    let view = HomeView(presenter: presenter)
    
    presenter.view = view
    
    interactor.presenter = presenter
    
    router.presenter = presenter
    router.viewController = view
    
    presenter.setupViewControllers()
    
    return view
  }
  
}
