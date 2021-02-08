//
//  ToggleWatchlistRepository.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core
import RxSwift

public struct ToggleWatchlistRepository<
  WatchlistLocalDataSource: LocalDataSource>: Repository
where
WatchlistLocalDataSource.Response == Bool{
  
  public typealias Request = String
  public typealias Response = Bool
  
  private let _localDataSource: WatchlistLocalDataSource
  
  public init(localDataSource: WatchlistLocalDataSource) {
    
    _localDataSource = localDataSource
    
  }
  public func execute(request: String?) -> Observable<Bool> {
//    print("ToggleWatchlistRepository request : \(request ?? "")")
    return _localDataSource.addEntity(request ?? "")
      
  }
  
}
