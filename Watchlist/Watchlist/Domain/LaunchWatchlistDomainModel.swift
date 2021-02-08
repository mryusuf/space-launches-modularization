//
//  LaunchWatchlistDomainModel.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import RxDataSources

public struct LaunchWatchlistDomainModel: Equatable, Identifiable {
  public let id: String
  public let url: String
  public let name: String
  public let net: String
  public let status: StatusModel
  public let tbdtime: Bool
  public let tbddate: Bool
  public let holdreason: String
  public let failreason: String
  public let image: String
  public let infographic: String
  public let agency: AgencyModel
  public let rocket: RocketModel
  public let mission: MissionModel?
  public let pad: PadModel
  public let isInWatchlist: Bool
}

extension LaunchWatchlistDomainModel: IdentifiableType {
  
  public typealias Identity = String
  
  public var identity: String {
    return id
  }
  
  public static func == (lhs: LaunchWatchlistDomainModel, rhs: LaunchWatchlistDomainModel) -> Bool {
    return lhs.id == rhs.id
  }
}

public struct StatusModel: Equatable {
  public let id: Int
  public let name: String
}

public struct AgencyModel: Equatable {
  public let id: Int
  public let url: String
  public let name: String
  public let type: String
}

public struct RocketModel: Equatable {
  public let id: Int
  public let configuration: RocketConfigurationModel
}

public struct RocketConfigurationModel: Equatable {
  public let id: Int
  public let name: String
  public let url: String
}

public struct MissionModel: Equatable {
  public let id: Int
  public let name: String
  public let description: String
  public let type: String
}

public struct PadModel: Equatable {
  public let id: Int
  public let name: String
  public let wiki_url: String
  public let location: PadLocationModel
}

public struct PadLocationModel: Equatable {
  public let name: String
  public let country_code: String
}
