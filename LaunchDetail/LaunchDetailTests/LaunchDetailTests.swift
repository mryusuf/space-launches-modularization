//
//  LaunchDetailTests.swift
//  LaunchDetailTests
//
//  Created by Indra Permana on 08/02/21.
//

import XCTest
import RxSwift
import RxBlocking
@testable import LaunchDetail
@testable import Core
@testable import Watchlist

class LaunchDetailTests: XCTestCase {
  
  // System Under Test
  var sut: Interactor<String, Bool, ToggleWatchlistRepository<ToggleWatchlistLocalDataSourceMock>>!
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testToggleWatchlistInteractor() {
    // Given: an interactor that use GetHomeLaunchesRepository,
    // with input: toggleResult and output: toggleResult
    let toggleResult = false
    let local = ToggleWatchlistLocalDataSourceMock(addEntityResult: .just(toggleResult))
    let repository = ToggleWatchlistRepository(localDataSource: local)
    sut = Interactor(repository: repository)
    
    // When: Interactor execute calling Repository
    let executeToggle = sut.execute(request: nil)
    
    // Then: the result of Toggle Interactor execute should be equal with toggleResult
    XCTAssertEqual(try executeToggle.toBlocking().first(), toggleResult)
  }
  
  class ToggleWatchlistLocalDataSourceMock: LocalDataSource {
    
    public typealias Request = Any
    public typealias Response = Bool
    
    var _addEntityResult: Observable<Bool>
    
    public init(addEntityResult: Observable<Bool>) {
      _addEntityResult = addEntityResult
    }
    
    func list(request: Any?) -> Observable<[Bool]> {
      fatalError()
    }
    
    func addEntities(entities: [Bool]) -> Observable<Bool> {
      fatalError()
    }
    
    
    func addEntity(_ id: String) -> Observable<Bool> {
      return _addEntityResult
    }
    
    func updateEntity(_ id: String) -> Observable<Bool> {
      fatalError()
    }
  }
  
}
