//
//  Mapper.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation

public protocol Mapper {
  
  associatedtype Request
  associatedtype Response
  associatedtype Entity
  associatedtype Domain
  
  func transformResponseToEntity(response: Response, type: Int?) -> Entity
  func transformEntityToDomain(entity: Entity) -> Domain
}
