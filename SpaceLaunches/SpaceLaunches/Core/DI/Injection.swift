//
//  Injection.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import Foundation
import RealmSwift
import Core
import Home
import LaunchDetail
import Watchlist
import About

final class Injection: NSObject {
  
  func provideHome() -> HomeUseCase {
    
    return HomeInteractor()
    
  }
  
  func provideHomeUpcomingGoLaunches<U: UseCase>() -> U where U.Request == Any, U.Response == [HomeLaunchesDomainModel] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dateNow = NSDate()
    let predicate = NSPredicate(format: "type == \(LaunchType.upcomingGo.rawValue) AND net > %@", dateNow)
    let local = HomeLocalDataSource(realm: appDelegate.realm, predicate: predicate, ascendingSort: true)
    let remote = HomeRemoteDataSource(endpoint: Endpoints.Gets.upcomingGo.url)
    let mapper = HomeLaunchesTransformer()
    let repository = GetHomeLaunchesRepository(
      localDataSource: local,
      remoteDataSource: remote,
      mapper: mapper,
      type: LaunchType.upcomingGo.rawValue)
    
    return Interactor(repository: repository) as! U
}
  
  func provideHomePreviousLaunches<U: UseCase>() -> U where U.Request == Any, U.Response == [HomeLaunchesDomainModel] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let predicate = NSPredicate(format: "type == \(LaunchType.previous.rawValue)")
    let local = HomeLocalDataSource(realm: appDelegate.realm, predicate: predicate, ascendingSort: false)
    let remote = HomeRemoteDataSource(endpoint: Endpoints.Gets.previous.url)
    let mapper = HomeLaunchesTransformer()
    let repository = GetHomeLaunchesRepository(
      localDataSource: local,
      remoteDataSource: remote,
      mapper: mapper,
      type: LaunchType.previous.rawValue)
    
    return Interactor(repository: repository) as! U
}
  
  func provideToggleWatchList<U: UseCase>() -> U where U.Request == String, U.Response == Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let local = ToggleWatchlistLocalDataSource(realm: appDelegate.realm)
    let repository = ToggleWatchlistRepository(localDataSource: local)
    
    return Interactor(repository: repository) as! U
}
  
  func provideGetWatchList<U: UseCase>() -> U where U.Request == Any, U.Response == [LaunchWatchlistDomainModel] {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let local = GetWatchlistLocalDataSource(realm: appDelegate.realm)
    let mapper = WatchlistTransformer()
    let repository = GetWatchlistRepository(localDataSource: local, mapper: mapper)
    
    return Interactor(repository: repository) as! U
}
  
  func provideAbout<U: UseCase>() -> U where U.Request == Any, U.Response == AboutDomainModel {
    
    let repository = GetAboutRepository()
    
    return Interactor(repository: repository) as! U
}
  
}
