//
//  LaunchRouter.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import UIKit
import Core
import LaunchDetail
import Watchlist

class LaunchesRouter {
  
  weak var viewController: UIViewController?
  
  func buildDetail(_ launch: LaunchModel) -> UIViewController {
    let watchlistUseCase: Interactor<
      String,
      Bool,
      ToggleWatchlistRepository<
        ToggleWatchlistLocalDataSource>
    > = Injection.init().provideToggleWatchList()
    let presenter = GetLaunchDetailPresenter(launchWatchlistUseCase: watchlistUseCase)
    
    let view = LaunchDetailView(presenter: presenter, launch: launch)
    return view
  }

}
