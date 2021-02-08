//
//  LaunchMapper.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 10/11/20.
//

import Foundation
import Home
import Watchlist

final class LaunchMapper {
  
  static func mapHomeLaunchesDomainToView(
    input entity: [HomeLaunchesDomainModel]
  ) -> [LaunchModel] {
    return entity.map { launch in
      let status = StatusModel(
        id: launch.status.id,
        name: launch.status.name
      )
      
      let mission = MissionModel(
        id: launch.mission?.id ?? 0,
        name: launch.mission?.name ?? "",
        description: launch.mission?.description ?? "",
        type: launch.mission?.type ?? ""
      )
      
      let pad = PadModel(
        id: launch.pad.id ,
        name: launch.pad.name ,
        wiki_url: launch.pad.wiki_url ,
        location: PadLocationModel(
          name: launch.pad.location.name ,
          country_code: launch.pad.location.country_code )
      )
      
      let rocket = RocketModel(
        id: launch.rocket.id ,
        configuration: RocketConfigurationModel(
          id: launch.rocket.configuration.id ,
          name: launch.rocket.configuration.name ,
          url: launch.rocket.configuration.url )
      )
      
      let agency = AgencyModel(
        id: launch.agency.id ,
        url: launch.agency.url ,
        name: launch.agency.name ,
        type: launch.agency.type
      )
      
      return LaunchModel(
        id: launch.id,
        url: launch.url,
        name: launch.name,
        net: launch.net,
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
  
  static func mapWatchlistLaunchesDomainToView(
    input entity: [LaunchWatchlistDomainModel]
  ) -> [LaunchModel] {
    return entity.map { launch in
      let status = StatusModel(
        id: launch.status.id,
        name: launch.status.name
      )
      
      let mission = MissionModel(
        id: launch.mission?.id ?? 0,
        name: launch.mission?.name ?? "",
        description: launch.mission?.description ?? "",
        type: launch.mission?.type ?? ""
      )
      
      let pad = PadModel(
        id: launch.pad.id ,
        name: launch.pad.name ,
        wiki_url: launch.pad.wiki_url ,
        location: PadLocationModel(
          name: launch.pad.location.name ,
          country_code: launch.pad.location.country_code )
      )
      
      let rocket = RocketModel(
        id: launch.rocket.id ,
        configuration: RocketConfigurationModel(
          id: launch.rocket.configuration.id ,
          name: launch.rocket.configuration.name ,
          url: launch.rocket.configuration.url )
      )
      
      let agency = AgencyModel(
        id: launch.agency.id ,
        url: launch.agency.url ,
        name: launch.agency.name ,
        type: launch.agency.type
      )
      
      return LaunchModel(
        id: launch.id,
        url: launch.url,
        name: launch.name,
        net: launch.net,
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
  
  static func mapLaunchModelToDetail(
    input launch: LaunchModel
  ) -> [LaunchDetail] {
    
    var launchDetails: [LaunchDetail] = []
    
    if !launch.agency.name.isEmpty {
      let agencyDetail = LaunchDetail(label: "Agency", detail: launch.agency.name)
      launchDetails.append(agencyDetail)
    }
    
    if !launch.net.isEmpty {
      let dateDetail = LaunchDetail(label: "Launch", detail: launch.net)
      launchDetails.append(dateDetail)
    }
    
    if let missionDesc = launch.mission {
      let missionDetail = LaunchDetail(label: "Mission", detail: missionDesc.description)
      launchDetails.append(missionDetail)
    }
    
    let padName = launch.pad.name
    let padLocation = launch.pad.location.name
    if  !padName.isEmpty, !padLocation.isEmpty {
      let padDetailString = "\(padName), \(padLocation)"
      let padDetail = LaunchDetail(label: "Location", detail: padDetailString)
      launchDetails.append(padDetail)
    }
    
    if !launch.infographic.isEmpty {
      let infographicDetail = LaunchDetail(label: "Infographic", detail: launch.infographic)
      launchDetails.append(infographicDetail)
    }
    
    return launchDetails
  }
  
}
