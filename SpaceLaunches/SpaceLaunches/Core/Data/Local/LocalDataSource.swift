//
//  LocalDataSource.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 13/11/20.
//

import Foundation
import RealmSwift
import RxSwift
import Home

protocol LocalDataSourceProtocol {
  
  func getAboutData() -> AboutModel
}

final class LocalDataSource: NSObject {
  
  private let realm: Realm?
  
  private init(realm: Realm?) {
    self.realm = realm
  }
  
  static let shared: (Realm?) -> LocalDataSource = { realmDB in
    return LocalDataSource(realm: realmDB)
  }
  
}

extension LocalDataSource: LocalDataSourceProtocol {
  
  func getAboutData() -> AboutModel {
    return AboutModel(
      name: "Muhamad Yusuf Indra P. P.",
      email: "muhamadyusufindra@gmail.com",
      imageName: "yusuf.png")
  }
  
}

extension Results {
  
  func toArray<T>(ofType: T.Type) -> [T] {
    var array = [T]()
    for index in 0 ..< count {
      if let result = self[index] as? T {
        array.append(result)
      }
    }
    return array
  }
}
