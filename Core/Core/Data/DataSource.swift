//
//  DataSource.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation
import RxSwift

public protocol DataSource {
  
  associatedtype Request
  associatedtype Response
  
  func execute(request: Request?) -> Observable<Response>
}
