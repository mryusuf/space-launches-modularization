//
//  HomeLaunchesTransformer.swift
//  Home
//
//  Created by Indra Permana on 05/02/21.
//

import Foundation
import Core

public struct HomeLaunchesTransformer: Mapper {
  
  public typealias Request = Any
  public typealias Response = [Launch]
  public typealias Entity = [LaunchesEntity]
  public typealias Domain = [HomeLaunchesDomainModel]
  
  public init() {}
  
  public func transformResponseToEntity(response: [Launch], type: Int?) -> [LaunchesEntity] {
//    print(response[0])
    return response.map { launch in
      
      let status = StatusEntity()
      status.id = launch.status.id
      status.name = launch.status.name
      
      let mission = MissionEntity()
      mission.id = launch.mission?.id ?? 0
      mission.name = launch.mission?.name ?? ""
      mission.desc = launch.mission?.description ?? ""
      mission.type = launch.mission?.type ?? ""
      
      let pad = PadEntity()
      pad.id = launch.pad.id
      pad.name = launch.pad.name ?? ""
      pad.wiki_url = launch.pad.wiki_url ?? ""
      let padLocation = PadLocationEntity()
      padLocation.name = launch.pad.location.name
      padLocation.country_code = launch.pad.location.country_code
      pad.location = padLocation
      
      let rocket = RocketEntity()
      rocket.id = launch.rocket.id
      let rocketConfiguration = RocketConfigurationEntity()
      rocketConfiguration.id = launch.rocket.configuration.id
      rocketConfiguration.name = launch.rocket.configuration.name ?? ""
      rocketConfiguration.url = launch.rocket.configuration.url ?? ""
      rocket.configuration = rocketConfiguration
      
      let agency = AgencyEntity()
      agency.id = launch.launch_service_provider.id
      agency.url = launch.launch_service_provider.url ?? ""
      agency.name = launch.launch_service_provider.name ?? ""
      agency.type = launch.launch_service_provider.type ?? ""
      
      let launchEntity = LaunchesEntity()
      launchEntity.id = launch.id
      launchEntity.url = launch.url
      launchEntity.name = launch.name
      launchEntity.net = launch.net?.toDate()
      launchEntity.status = status
      launchEntity.tbdtime = launch.tbdtime
      launchEntity.tbddate = launch.tbddate
      launchEntity.holdreason = launch.holdreason ?? ""
      launchEntity.failreason = launch.failreason ?? ""
      launchEntity.image = launch.image ?? ""
      launchEntity.infographic = launch.infographic ?? ""
      launchEntity.agency = agency
      launchEntity.rocket = rocket
      launchEntity.mission = mission
      launchEntity.pad = pad
      launchEntity.type = type ?? 0
      
      return launchEntity
    }
  }
  
  public func transformEntityToDomain(entity: [LaunchesEntity]) -> [HomeLaunchesDomainModel] {
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
      
      return HomeLaunchesDomainModel(
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
}
