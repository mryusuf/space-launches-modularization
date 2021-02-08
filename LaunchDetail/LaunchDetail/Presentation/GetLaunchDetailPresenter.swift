//
//  GetLaunchDetailPresenter.swift
//  LaunchDetail
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core
import RxSwift

public class GetLaunchDetailPresenter<
  Request,
  Response,
  LaunchWatchlistUseCase: UseCase>
where LaunchWatchlistUseCase.Request == Request,
      LaunchWatchlistUseCase.Response == Response{
  
  private var bags = DisposeBag()
  
  private let _launchWatchlistUseCase: LaunchWatchlistUseCase
  
  public var isToggled = PublishSubject<Response>()
  public var errorMessage: String = ""
  public var isLoading: Bool = false
  public var isError: Bool = false
  
  public init(launchWatchlistUseCase: LaunchWatchlistUseCase ) {
    _launchWatchlistUseCase = launchWatchlistUseCase
  }
  
  public func toggle(request: Request?) {
    isLoading = true
    
    _launchWatchlistUseCase.execute(request: request)
      .observeOn( MainScheduler.instance)
      .subscribe() { result in
//        print(result)
        self.isToggled.onNext(result)
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
