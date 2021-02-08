//
//  WatchlistLocalDataSource.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core
import RxSwift
import RealmSwift

public struct GetWatchlistLocalDataSource: LocalDataSource {
  
  public typealias Request = Any
  public typealias Response = LaunchWatchlistEntity
  
  private let _realm: Realm
  
  public init(realm: Realm) {
    _realm = realm
  }
  
  public func list(request: Any?) -> Observable<[LaunchWatchlistEntity]> {
    return Observable<[LaunchWatchlistEntity]>.create { observer in
      let launches: Results<LaunchWatchlistEntity> = {
        _realm.objects(LaunchWatchlistEntity.self)
          .filter("isInWatchlist == %@", true)
          .sorted(byKeyPath: "net", ascending: true)
      }()
      observer.onNext(launches.toArray(ofType: LaunchWatchlistEntity.self))
      observer.onCompleted()
      return Disposables.create()
    }
  }
  
  public func addEntities(entities: [LaunchWatchlistEntity]) -> Observable<Bool> {
    fatalError()
  }
  
  public func addEntity(_ id: String) -> Observable<Bool> {
    return Observable<Bool>.create { observer in
      do {
        try _realm.write {
          if let launch = _realm.object(ofType: LaunchWatchlistEntity.self, forPrimaryKey: id) {
            launch.isInWatchlist.toggle()
            observer.onNext(launch.isInWatchlist)
            observer.onCompleted()
          } else {
            observer.onError(DatabaseError.requestFailed)
          }
        }
      } catch {
        observer.onError(DatabaseError.requestFailed)
      }
      return Disposables.create()
    }
  }
  
  public func updateEntity(_ id: String) -> Observable<Bool> {
    fatalError()
  }
}
