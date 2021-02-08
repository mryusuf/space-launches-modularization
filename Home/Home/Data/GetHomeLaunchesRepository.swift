//
//  GetHomeLaunchesRepository.swift
//  Home
//
//  Created by Indra Permana on 04/02/21.
//

import Foundation
import Core
import RxSwift

public struct GetHomeLaunchesRepository<
  HomeLocalDataSource: LocalDataSource,
  RemoteDataSource: DataSource,
  Transformer: Mapper
>: Repository
where
HomeLocalDataSource.Response == LaunchesEntity,
RemoteDataSource.Response == [Launch],
Transformer.Response == [Launch],
Transformer.Entity == [LaunchesEntity],
Transformer.Domain == [HomeLaunchesDomainModel]
{
  
  public typealias Request = Any
  public typealias Response = [HomeLaunchesDomainModel]
  
  private let _localDataSource: HomeLocalDataSource
  private let _remoteDataSource: RemoteDataSource
  private let _mapper: Transformer
  private let _type: Int
  
  public init(
    localDataSource: HomeLocalDataSource,
    remoteDataSource: RemoteDataSource,
    mapper: Transformer,
    type: Int) {
    
    _localDataSource = localDataSource
    _remoteDataSource = remoteDataSource
    _mapper = mapper
    _type = type
    
  }
  public func execute(request: Any?) -> Observable<[HomeLaunchesDomainModel]> {
    return _localDataSource.list(request: nil)
      .map { _mapper.transformEntityToDomain(entity: $0) }
      .filter { !$0.isEmpty }
      .ifEmpty(
        switchTo: self._remoteDataSource.execute(request: nil)
          .map { _mapper.transformResponseToEntity(response: $0, type: _type) }
          .flatMap { self._localDataSource.addEntities(entities: $0)}
          .filter { $0 }
          .flatMap { _ in self._localDataSource.list(request: nil)
            .map { _mapper.transformEntityToDomain(entity: $0) }
          }
      )
  }
  
}
