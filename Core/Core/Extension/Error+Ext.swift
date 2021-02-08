//
//  Error+Ext.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation

public enum DatabaseError: LocalizedError {

  case invalidInstance
  case requestFailed
  
  public var errorDescription: String? {
    switch self {
    case .invalidInstance: return "Database can't instance."
    case .requestFailed: return "Your request failed."
    }
  }

}
