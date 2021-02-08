//
//  GetListPresenter.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation
import RxSwift

public class GetListPresenter<Request, Response, Interactor: UseCase> where Interactor.Request == Request, Interactor.Response == [Response] {
  
  private var bags = DisposeBag()
  
  private let _useCase: Interactor
  
  public var list = PublishSubject<[Response]>()
  public var errorMessage: String = ""
  public var isLoading: Bool = false
  public var isError: Bool = false
  
  public init(useCase: Interactor) {
    _useCase = useCase
  }
  
  public func getList(request: Request?) {
    isLoading = true
    
    _useCase.execute(request: request)
      .observeOn( MainScheduler.instance)
      .subscribe() { result in
//        print(result)
        self.list.onNext(result)
      } onError: { (error) in
        print("error: \(error)")
        self.errorMessage = error.localizedDescription
        self.isError = true
        self.isLoading = false
      } onCompleted: {
        self.isLoading = false
      }
      .disposed(by: bags)
  }
}

