//
//  HomeLaunchesResponse.swift
//  Home
//
//  Created by Indra Permana on 04/02/21.
//

import Foundation

public struct LaunchesResult: Decodable {
  let count: Int
  let results: [Launch]
}

public struct Launch: Decodable {
  let id: String
  let url: String
  let name: String
  let net: String?
  let tbdtime: Bool
  let tbddate: Bool
  let status: Status
  let holdreason: String?
  let failreason: String?
  let image: String?
  let infographic: String?
  let launch_service_provider: Agency
  let rocket: Rocket
  let mission: Mission?
  let pad: Pad
}

public struct Status: Decodable {
  let id: Int
  let name: String
}

public struct Agency: Decodable {
  let id: Int
  let url: String?
  let name: String?
  let type: String?
}

public struct Rocket: Decodable {
  let id: Int
  let configuration: RocketConfiguration
}

public struct RocketConfiguration: Decodable {
  let id: Int
  let name: String?
  let url: String?
}

public struct Mission: Decodable {
  let id: Int
  let name: String?
  let description: String?
  let type: String?
}

public struct Pad: Decodable {
  let id: Int
  let name: String?
  let wiki_url: String?
  let location: PadLocation
}

public struct PadLocation: Decodable {
  let name: String
  let country_code: String
}
