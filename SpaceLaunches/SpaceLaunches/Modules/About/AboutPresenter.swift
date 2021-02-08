//
//  AboutPresenter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 23/11/20.
//

import Foundation
import RxSwift

protocol AboutPresenterProtocol: class {
  
  var interactor: AboutUseCase? { get set }
  var router: AboutRouterProtocol? { get set }
  var view: AboutViewProtocol? { get set }
  func setupView()
  
}

class AboutPresenter {
  
  var interactor: AboutUseCase?
  var router: AboutRouterProtocol?
  weak var view: AboutViewProtocol?
  private var aboutModel: AboutModel?
  
}

extension AboutPresenter: AboutPresenterProtocol {
  
  func setupView() {
    
    if let aboutData = self.interactor?.getAboutData() {
      self.aboutModel = aboutData
      self.view?.display(aboutData)
    }

  }
  
}
