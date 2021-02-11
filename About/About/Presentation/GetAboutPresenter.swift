//
//  GetAboutPresenter.swift
//  About
//
//  Created by Indra Permana on 10/02/21.
//

import Foundation
import Core
import RxSwift
public class GetAboutPresenter<
  Request,
  Response,
  AboutUseCase: UseCase>
where AboutUseCase.Request == Request,
      AboutUseCase.Response == Response {
  
  private var bags = DisposeBag()
  
  private let _aboutUseCase: AboutUseCase
  public var aboutData = PublishSubject<Response>()
  
  public init(aboutUseCase: AboutUseCase) {
    _aboutUseCase = aboutUseCase
  }
  
  public func getData(request: Request?) {
    _aboutUseCase.execute(request: request)
      .observeOn(MainScheduler.instance)
      .subscribe() { result in
        self.aboutData.onNext(result)
      } onError: { (Error) in
        print(Error)
      }
      .disposed(by: bags)
  }
}
