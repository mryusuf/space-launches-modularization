//
//  HomeTests.swift
//  HomeTests
//
//  Created by Indra Permana on 08/02/21.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Home
@testable import Core

class HomeTests: XCTestCase {
  
  // System Under Test
  var sut: Interactor<Any, [HomeLaunchesDomainModel], GetHomeLaunchesRepository<HomeLocalDataSourceMock, HomeRemoteDataSourceMock, HomeLaunchesTransformer>>!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGetHomeListInteractor() {
    // Given: an interactor that use GetHomeLaunchesRepository,
    // with input: 2 Launch Response and output: 2 Launch Entity
    let local = HomeLocalDataSourceMock(
      listReturnValue: .just(LaunchesEntityMock().generateSomeLaunches()),
      addEntitiesReturnValue: .just(true))
    let remote = HomeRemoteDataSourceMock(
      remoteReturnValue: .just(LaunchesMock().generateSomeLaunches()))
    let mapper = HomeLaunchesTransformer()
    let repository = GetHomeLaunchesRepository(localDataSource: local, remoteDataSource: remote, mapper: mapper, type: LaunchType.upcomingGo.rawValue)
    sut = Interactor(repository: repository)
    
    // When: Interactor execute calling Repository
    let launchesCount = sut.execute(request: nil).map { $0.count }
    
    // Then: the amount of output (Launch Entity) should be equal with the input (Launch Response)
    XCTAssertEqual(try launchesCount.toBlocking().first(), LaunchesMock.launchMockCount)
  }
  
  class HomeLocalDataSourceMock: LocalDataSource {
    
    public typealias Request = Any
    public typealias Response = LaunchesEntity
    
    var _listReturnValue: Observable<[LaunchesEntity]>
    var _addEntitiesReturnValue: Observable<Bool>
    
    public init(
      listReturnValue: Observable<[LaunchesEntity]>,
      addEntitiesReturnValue: Observable<Bool>) {
      _listReturnValue = listReturnValue
      _addEntitiesReturnValue = addEntitiesReturnValue
    }
    
    func list(request: Any?) -> Observable<[LaunchesEntity]> {
      return _listReturnValue
    }
    
    func addEntities(entities: [LaunchesEntity]) -> Observable<Bool> {
      return _addEntitiesReturnValue
    }
    
    func addEntity(_ id: String) -> Observable<Bool> {
      fatalError()
    }
    
    func updateEntity(_ id: String) -> Observable<Bool> {
      fatalError()
    }
  }
  
  class HomeRemoteDataSourceMock: DataSource {
    
    public typealias Request = Any
    public typealias Response = [Launch]
    
    var _remoteReturnValue: Observable<[Launch]>
    
    public init(remoteReturnValue: Observable<[Launch]>) {
      _remoteReturnValue = remoteReturnValue
    }
    
    func execute(request: Any?) -> Observable<[Launch]> {
      return _remoteReturnValue
    }
  }
  
  struct LaunchesMock {
    static var launchMockCount = 2
    
    func generateSomeLaunches() -> [Launch] {
      var someLaunches: [Launch] = []
      for _ in 0..<LaunchesMock.launchMockCount {
        let status = Status(
          id: Int.random(in: 1...4),
          name: "Go")
        
        let mission = Mission(
          id: Int.random(in: 90..<99),
          name: "Mission Name",
          description: "Mission Desc",
          type: "Mission Type")
        
        let padLocation = PadLocation(
          name: "Launch Pad Location",
          country_code: "IDN")
        let pad = Pad(
          id: Int.random(in: 90..<99),
          name: "Launch Pad",
          wiki_url: "",
          location: padLocation)
        
        let rocketConfiguration = RocketConfiguration(
          id: Int.random(in: 90..<99),
          name: "Rocket Configuration",
          url: "")
        let rocket = Rocket(
          id: Int.random(in: 90..<99),
          configuration: rocketConfiguration)
        
        let agency = Agency(
          id: Int.random(in: 90..<99),
          url: "",
          name: "Space Agency",
          type: "Private")
        
        let launch = Launch(
          id: Int.random(in: 999..<9999).description,
          url: "",
          name: "a Launch",
          net: Date().description,
          tbdtime: false,
          tbddate: false,
          status: status,
          holdreason: "",
          failreason: "",
          image: "",
          infographic: "",
          launch_service_provider: agency,
          rocket: rocket,
          mission: mission,
          pad: pad)
        
        someLaunches.append(launch)
      }
      return someLaunches
    }
  }
  
  struct LaunchesEntityMock {
    
    func generateSomeLaunches() -> [LaunchesEntity] {
      var someLaunches: [LaunchesEntity] = []
      for _ in 0..<LaunchesMock.launchMockCount {
        
        let launch = LaunchesEntity()
        
        someLaunches.append(launch)
      }
      return someLaunches
    }
  }
  
}
