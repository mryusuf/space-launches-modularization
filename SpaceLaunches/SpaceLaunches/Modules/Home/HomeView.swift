//
//  HomeView.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import UIKit

protocol HomeViewProtocol: class {
  
  func display(_ viewControllers: [UIViewController])
  
}

class HomeView: UITabBarController {
  
  let _presenter: HomePresenterProtocol?
  
  public init(presenter: HomePresenterProtocol) {
    _presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension HomeView: HomeViewProtocol {
  
  func display(_ viewControllers: [UIViewController]) {
    
    self.viewControllers = viewControllers
    
  }
  
}
