//
//  LaunchesEntity.swift
//  Core
//
//  Created by Indra Permana on 07/02/21.
//

import Foundation
import RealmSwift

public class LaunchesEntity: Object {
  @objc public dynamic var id: String = ""
  @objc public dynamic var url: String = ""
  @objc public dynamic var name: String = ""
  @objc public dynamic var net: Date?
  @objc public dynamic var status: StatusEntity?
  @objc public dynamic var tbdtime: Bool = false
  @objc public dynamic var tbddate: Bool = false
  @objc public dynamic var holdreason: String = ""
  @objc public dynamic var failreason: String = ""
  @objc public dynamic var image: String = ""
  @objc public dynamic var infographic: String = ""
  @objc public dynamic var agency: AgencyEntity?
  @objc public dynamic var rocket: RocketEntity?
  @objc public dynamic var mission: MissionEntity?
  @objc public dynamic var pad: PadEntity?
  @objc public dynamic var type: Int = 0
  @objc public dynamic var isInWatchlist: Bool = false
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class StatusEntity: Object {
  @objc public dynamic var id: Int = 0
  @objc public dynamic var name: String = ""
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class AgencyEntity: Object {
  @objc public dynamic var id: Int = 0
  @objc public dynamic var url: String = ""
  @objc public dynamic var name: String = ""
  @objc public dynamic var type: String = ""
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class RocketEntity: Object {
  @objc public dynamic var id: Int = 0
  public var configuration: RocketConfigurationEntity?
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class RocketConfigurationEntity: Object {
  @objc public dynamic var id: Int = 0
  @objc public dynamic var name: String = ""
  @objc public dynamic var url: String = ""
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class MissionEntity: Object {
  @objc public dynamic var id: Int = 0
  @objc public dynamic var name: String = ""
  @objc public dynamic var desc: String = ""
  @objc public dynamic var type: String = ""
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class PadEntity: Object {
  @objc public dynamic var id: Int = 0
  @objc public dynamic var name: String = ""
  @objc public dynamic var wiki_url: String = ""
  @objc public dynamic var location: PadLocationEntity?
  public override class func primaryKey() -> String? {
    return "id"
  }
}

public class PadLocationEntity: Object {
  @objc public dynamic var name: String = ""
  @objc public dynamic var country_code: String = ""
  public override class func primaryKey() -> String? {
    return "name"
  }
}

public enum LaunchType: Int {
  case upcomingGo = 1
  case previous = 2
}
