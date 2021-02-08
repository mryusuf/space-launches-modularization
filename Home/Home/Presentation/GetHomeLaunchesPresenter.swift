//
//  GetHomeLaunchesPresenter.swift
//  Home
//
//  Created by Indra Permana on 06/02/21.
//

import Foundation
import Core
import RxSwift

public class GetHomeLaunchesPresenter<
  Request,
  Response,
  UpcomingLaunchesUseCase: UseCase,
  PreviousLaunchesUseCase: UseCase>
where UpcomingLaunchesUseCase.Request == Request,
      UpcomingLaunchesUseCase.Response == [Response],
      PreviousLaunchesUseCase.Request == Request,
      PreviousLaunchesUseCase.Response == [Response]{
  
  private var bags = DisposeBag()
  
  private let _upcomingGoLaunchesUseCase: UpcomingLaunchesUseCase
  private let _previousLaunchesUseCase: PreviousLaunchesUseCase
  
  public var upcomingGoLaunches = PublishSubject<[Response]>()
  public var previousLaunches = PublishSubject<[Response]>()
  public var errorMessage: String = ""
  public var isLoading: Bool = false
  public var isError: Bool = false
  
  public init(upcomingGoLaunchesUseCase: UpcomingLaunchesUseCase, previousLaunchesUseCase: PreviousLaunchesUseCase ) {
    _upcomingGoLaunchesUseCase = upcomingGoLaunchesUseCase
    _previousLaunchesUseCase = previousLaunchesUseCase
  }
  
  public func getUpcomingLaunches(request: Request?) {
    isLoading = true
    
    _upcomingGoLaunchesUseCase.execute(request: request)
      .observeOn( MainScheduler.instance)
      .subscribe() { result in
        self.upcomingGoLaunches.onNext(result)
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
  
  public func getPreviousLaunches(request: Request?) {
    isLoading = true
    
    _previousLaunchesUseCase.execute(request: request)
      .observeOn( MainScheduler.instance)
      .subscribe() { result in
//        print(result)
        self.previousLaunches.onNext(result)
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
