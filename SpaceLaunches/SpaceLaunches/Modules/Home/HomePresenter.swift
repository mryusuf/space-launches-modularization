//
//  HomePresenter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 14/11/20.
//

import Foundation
import RxSwift

protocol HomePresenterProtocol: class {
  
  var view: HomeViewProtocol? { get set }
  func setupViewControllers()
  
}

class HomePresenter {
  
  let _interactor: HomeUseCase
  let _router: HomeRouterProtocol
  weak var view: HomeViewProtocol?
  private var bags = DisposeBag()
  
  public init(interactor: HomeUseCase,router: HomeRouterProtocol) {
    _interactor = interactor
    _router = router
  }
}

extension HomePresenter: HomePresenterProtocol {
  
  func setupViewControllers() {
    
    let controllers = _router.getViewControllers()
    self.view?.display(controllers)
  }
  
}
