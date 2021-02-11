//
//  WatchlistTests.swift
//  WatchlistTests
//
//  Created by Indra Permana on 11/02/21.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Core
@testable import Watchlist


class WatchlistTests: XCTestCase {
  
  // System Under Test
  var sut: Interactor<
    Any,
    [LaunchWatchlistDomainModel],
    GetWatchlistRepository<
      GetWatchlistLocalDataSourceMock,
      WatchlistTransformer>>!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testGetWatchlistInteractor() {
    // Given: an interactor that use GetHomeLaunchesRepository,
    // with input: 2 Launch Response and output: 2 Launch Entity
    
    let local = GetWatchlistLocalDataSourceMock(addEntityResult: .just(true), listResult: .just(LaunchesEntityMock().generateSomeLaunches()))
    let mapper = WatchlistTransformer()
    let repository = GetWatchlistRepository(localDataSource: local, mapper: mapper)
    sut = Interactor(repository: repository)
    
    // When: Interactor execute calling Repository
    let launchesCount = sut.execute(request: nil).map{$0.count}
    
    // Then: the amount of output from Interactor should be equal with the input mock
    XCTAssertEqual(try launchesCount.toBlocking().first(), LaunchesEntityMock.launchMockCount)
  }
  
  class GetWatchlistLocalDataSourceMock: LocalDataSource {
    
    public typealias Request = Any
    public typealias Response = LaunchesEntity
    
    var _addEntityResult: Observable<Bool>
    var _listResult: Observable<[LaunchesEntity]>
    
    public init(
      addEntityResult: Observable<Bool>,
      listResult: Observable<[LaunchesEntity]>) {
      _addEntityResult = addEntityResult
      _listResult = listResult
    }
    
    func list(request: Any?) -> Observable<[LaunchesEntity]> {
      return _listResult
    }
    
    func addEntities(entities: [LaunchesEntity]) -> Observable<Bool> {
      fatalError()
    }
    
    func addEntity(_ id: String) -> Observable<Bool> {
      return _addEntityResult
    }
    
    func updateEntity(_ id: String) -> Observable<Bool> {
      fatalError()
    }
  }
  
  struct LaunchesEntityMock {
    static var launchMockCount = 2
    func generateSomeLaunches() -> [LaunchesEntity] {
      var someLaunches: [LaunchesEntity] = []
      for _ in 0..<LaunchesEntityMock.launchMockCount {
        
        let launch = LaunchesEntity()
        
        someLaunches.append(launch)
      }
      return someLaunches
    }
  }
  
  
}
