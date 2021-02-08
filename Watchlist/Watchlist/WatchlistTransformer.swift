//
//  WatchlistTransformer.swift
//  Watchlist
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import Core

public struct WatchlistTransformer: Mapper {
  
  public typealias Request = Any
  public typealias Response = Any
  public typealias Entity = [LaunchesEntity]
  public typealias Domain = [LaunchWatchlistDomainModel]
  
  public init() {}
  
  public func transformEntityToDomain(entity: [LaunchesEntity]) -> [LaunchWatchlistDomainModel] {
    return entity.map { launch in
      
      let status = StatusModel(
        id: launch.status?.id ?? 0 ,
        name: launch.status?.name ?? ""
      )
      
      let mission = MissionModel(
        id: launch.mission?.id ?? 0,
        name: launch.mission?.name ?? "",
        description: launch.mission?.desc ?? "",
        type: launch.mission?.type ?? ""
      )
      
      let pad = PadModel(
        id: launch.pad?.id ?? 0,
        name: launch.pad?.name ?? "",
        wiki_url: launch.pad?.wiki_url ?? "",
        location: PadLocationModel(
          name: launch.pad?.location?.name ?? "",
          country_code: launch.pad?.location?.country_code ?? "")
      )
      
      let rocket = RocketModel(
        id: launch.rocket?.id ?? 0,
        configuration: RocketConfigurationModel(
          id: launch.rocket?.configuration?.id ?? 0,
          name: launch.rocket?.configuration?.name ?? "",
          url: launch.rocket?.configuration?.url ?? "")
      )
      
      let agency = AgencyModel(
        id: launch.agency?.id ?? 0,
        url: launch.agency?.url ?? "",
        name: launch.agency?.name ?? "",
        type: launch.agency?.type ?? ""
      )
      
      return LaunchWatchlistDomainModel(
        id: launch.id,
        url: launch.url,
        name: launch.name,
        net: launch.net?.toString() ?? "",
        status: status,
        tbdtime: launch.tbdtime,
        tbddate: launch.tbddate,
        holdreason: launch.holdreason,
        failreason: launch.failreason,
        image: launch.image,
        infographic: launch.infographic,
        agency: agency,
        rocket: rocket,
        mission: mission,
        pad: pad,
        isInWatchlist: launch.isInWatchlist
      )
    }
  }
  
  public func transformResponseToEntity(response: Any, type: Int?) -> [LaunchesEntity] {
    fatalError()
  }
  
}


