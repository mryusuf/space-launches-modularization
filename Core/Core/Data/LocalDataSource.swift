//
//  LocalDataSource.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation
import RxSwift

public protocol LocalDataSource {
  
  associatedtype Request
  associatedtype Response
  
  func list(request: Request?) -> Observable<[Response]>
  func addEntities(entities: [Response]) -> Observable<Bool>
  func addEntity(_ id: String) -> Observable<Bool>
  func updateEntity(_ id: String) -> Observable<Bool>
}
