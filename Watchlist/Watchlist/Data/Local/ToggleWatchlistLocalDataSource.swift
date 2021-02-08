//
//  ToggleWatchlistLocalDataSource.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core
import RxSwift
import RealmSwift

public struct ToggleWatchlistLocalDataSource: LocalDataSource {
  
  public typealias Request = String
  public typealias Response = Bool
  
  private let _realm: Realm
  
  public init(realm: Realm) {
    _realm = realm
  }
  
  public func list(request: String?) -> Observable<[Bool]> {
    fatalError()
  }
  
  public func addEntities(entities: [Bool]) -> Observable<Bool> {
    fatalError()
  }
  
  public func addEntity(_ id: String) -> Observable<Bool> {
    return Observable<Bool>.create { observer in
      do {
        try _realm.write {
          if let launch = _realm.object(ofType: LaunchesEntity.self, forPrimaryKey: id) {
            launch.isInWatchlist.toggle()
//            print(launch)
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
