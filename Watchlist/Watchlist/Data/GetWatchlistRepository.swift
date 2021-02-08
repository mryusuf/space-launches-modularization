//
//  GetWatchlistRepository.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core
import RxSwift

public struct GetWatchlistRepository<
  GetWatchlistLocalDataSource: LocalDataSource,
  WatchlistTransformer: Mapper
>: Repository
where
  GetWatchlistLocalDataSource.Response == LaunchesEntity,
WatchlistTransformer.Response == Any,
WatchlistTransformer.Entity == [LaunchesEntity],
WatchlistTransformer.Domain == [LaunchWatchlistDomainModel]
{
  
  public typealias Request = Any
  public typealias Response = [LaunchWatchlistDomainModel]
  
  private let _localDataSource: GetWatchlistLocalDataSource
  private let _mapper: WatchlistTransformer
  
  public init(
    localDataSource: GetWatchlistLocalDataSource,
    mapper: WatchlistTransformer) {
    
    _localDataSource = localDataSource
    _mapper = mapper
    
  }
  public func execute(request: Any?) -> Observable<[LaunchWatchlistDomainModel]> {
    return _localDataSource.list(request: nil)
      .map { _mapper.transformEntityToDomain(entity: $0) }
      
  }
  
}
