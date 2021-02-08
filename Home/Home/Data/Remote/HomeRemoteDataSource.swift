//
//  HomeRemoteDataSource.swift
//  Home
//
//  Created by Indra Permana on 05/02/21.
//

import Foundation
import Core
import RxSwift
import Alamofire

public struct HomeRemoteDataSource: DataSource {
  
  public typealias Request = String
  public typealias Response = [Launch]
  private let _endpoint: String
  
  public init(endpoint: String) {
    _endpoint = endpoint
  }
  public func execute(request: String?) -> Observable<[Launch]> {
    return Observable<[Launch]>.create { observer in
      if let url = URL(string: _endpoint) {
//        print(url.absoluteString)
        AF.request(url)
          .validate()
          .responseDecodable(of: LaunchesResult.self) { response in
            switch response.result {
            case .success(let values):
//              print(values)
              observer.onNext(values.results)
              observer.onCompleted()
            case .failure(let error):
              observer.onError(error)
            }
          }
      }
      return Disposables.create()
    }
  }
  
}
