//
//  Repository.swift
//  Core
//
//  Created by Indra Permana on 01/02/21.
//

import Foundation
import RxSwift

public protocol Repository {
  
  associatedtype Request
  associatedtype Response
  
  func execute(request: Request?) -> Observable<Response>
  
}
