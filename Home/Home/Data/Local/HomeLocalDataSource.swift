//
//  HomeUpcomingGoLaunchesLocalDataSource.swift
//  Home
//
//  Created by Indra Permana on 05/02/21.
//

import Foundation
import Core
import RxSwift
import RealmSwift

public struct HomeLocalDataSource: LocalDataSource {
  
  public typealias Request = Any
  public typealias Response = LaunchesEntity
  
  private let _realm: Realm
  private let _predicate: NSPredicate
  private let _ascendingSort: Bool
  
  public init(realm: Realm, predicate: NSPredicate, ascendingSort: Bool) {
    _realm = realm
    _predicate = predicate
    _ascendingSort = ascendingSort
  }
  
  public func list(request: Any?) -> Observable<[LaunchesEntity]> {
    return Observable<[LaunchesEntity]>.create { observer in
      let launches: Results<LaunchesEntity> = {
        _realm.objects(LaunchesEntity.self)
          .filter(_predicate)
          .sorted(byKeyPath: "net", ascending: _ascendingSort)
      }()
      observer.onNext(launches.toArray(ofType: LaunchesEntity.self))
      observer.onCompleted()
      
      return Disposables.create()
    }
  }
  
  public func addEntities(entities: [LaunchesEntity]) -> Observable<Bool> {
    return Observable<Bool>.create { observer in
      do {
        try _realm.write {
          for entity in entities {
            _realm.add(entity, update: .all)
          }
          observer.onNext(true)
          observer.onCompleted()
        }
      } catch {
        observer.onError(DatabaseError.requestFailed)
      }
      return Disposables.create()
    }
  }
  
  public func addEntity(_ id: String) -> Observable<Bool> {
    fatalError()
  }
  
  public func updateEntity(_ id: String) -> Observable<Bool> {
    fatalError()
  }
  
}
