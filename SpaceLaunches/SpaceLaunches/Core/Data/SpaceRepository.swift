//
//  SpaceRepository.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 10/11/20.
//

import Foundation
import RxSwift

protocol SpaceRepositoryProtocol {

  func getAboutData() -> AboutModel
  
}

final class SpaceRepository: NSObject {
  
  typealias SpaceInstance = (LocalDataSource) -> SpaceRepository
  
  fileprivate let local: LocalDataSource
  
  private init(local: LocalDataSource) {
    self.local = local
  }
  
  static let shared: SpaceInstance = {localRepo in
    return SpaceRepository(local: localRepo)
  }
}

extension SpaceRepository: SpaceRepositoryProtocol {
  
  func getAboutData() -> AboutModel {
    return self.local.getAboutData()
  }
  
}
