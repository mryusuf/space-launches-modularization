//
//  Date+Ext.swift
//  Core
//
//  Created by Indra Permana on 03/02/21.
//

import Foundation

extension String {
  
  public func toDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from: self)
    return date
  }
  
  public func modelToDate() -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    let date = dateFormatter.date(from: self)
    return date
  }
  
}

extension Date {
  
  public func toString() -> String? {
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.timeZone = .current
    dateFormatter.timeStyle = .short
    dateFormatter.dateStyle = .short
    let dateString = dateFormatter.string(from: self)
    return dateString
  }
}
