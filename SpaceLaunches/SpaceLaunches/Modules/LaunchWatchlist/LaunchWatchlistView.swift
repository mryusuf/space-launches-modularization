//
//  LaunchWatchlistView.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 20/11/20.
//

import UIKit
import Core
import Watchlist
import RxSwift

protocol LaunchWatchlistViewProtocol: class {
  
  func startLoading()
  func stopLoading()
  func displayLaunches(_ launches: [LaunchModel])
  func showEmptyState()
  func hideEmptyState()
  
}

class LaunchWatchlistView: UIViewController {
  
  //  var presenter: LaunchWatchlistPresenterProtocol?
  private var _presenter: GetListPresenter<
    Any,
    LaunchWatchlistDomainModel,
    Interactor<
      Any,
      [LaunchWatchlistDomainModel],
      GetWatchlistRepository<
        GetWatchlistLocalDataSource,
        WatchlistTransformer>>
  >
  private weak var containerView: UIView?
  private weak var launchesUIView: LaunchesUIView?
  private weak var activityIndicator: UIActivityIndicatorView?
  private weak var emptyLabel: UILabel?
  internal var isLoading = false
  
  private var bags = DisposeBag()
  init(
    presenter: GetListPresenter<
      Any,
      LaunchWatchlistDomainModel,
      Interactor<
        Any,
        [LaunchWatchlistDomainModel],
        GetWatchlistRepository<
          GetWatchlistLocalDataSource,
          WatchlistTransformer>>
    >) {
    _presenter = presenter
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Launch Watchlist"
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    setupIndicatorView()
    setupLaunchesTableView()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    self._presenter.list.subscribe(
      onNext: { list in
        if list.count == 0 {
          self.showEmptyState()
        } else {
          let launchViewList = LaunchMapper.mapWatchlistLaunchesDomainToView(input: list)
          self.displayLaunches(launchViewList)
        }
      }, onError: {(Error) in
        print(Error.localizedDescription)
      })
      .disposed(by: bags)
    
    self._presenter.getList(request: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    
  }
  
}

extension LaunchWatchlistView {
  
  func setupIndicatorView() {
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(activityIndicator)
    self.activityIndicator = activityIndicator
    
    self.activityIndicator?.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }
  
  func setupLaunchesTableView() {
    
    let launchesUIView = LaunchesUIView()
    launchesUIView.setup()
    launchesUIView.delegate = self
    self.view.addSubview(launchesUIView)
    
    launchesUIView.snp.makeConstraints { make in
      make.left.right.equalTo(self.view)
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(0)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin).offset(0)
    }
    
    self.launchesUIView = launchesUIView
    
  }
}

extension LaunchWatchlistView: LaunchWatchlistViewProtocol {
  func startLoading() {
    
    isLoading = true
    self.activityIndicator?.isHidden = false
    self.launchesUIView?.isHidden = true
    self.activityIndicator?.startAnimating()
    
  }
  
  func stopLoading() {
    
    self.activityIndicator?.stopAnimating()
    self.activityIndicator?.isHidden = true
    self.launchesUIView?.isHidden = false
    
  }
  
  func displayLaunches(_ launches: [LaunchModel]) {
    
    self.launchesUIView?.displayPreviousLaunches(launches)
    
  }
  
  func showEmptyState() {
    
    self.launchesUIView?.isHidden = true
    let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    emptyLabel.text = "No Launches in your Watchlist yet :("
    emptyLabel.font = .systemFont(ofSize: 14, weight: .medium)
    
    self.view.addSubview(emptyLabel)
    
    emptyLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    self.emptyLabel = emptyLabel
    
  }
  
  func hideEmptyState() {
    if let emptyLabel = emptyLabel {
      emptyLabel.isHidden = true
    }
  }
  
  func showDetailLaunch(_ launch: LaunchModel) {
    let launchDetailVC = LaunchesRouter().buildDetail(launch)
    launchDetailVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(launchDetailVC, animated: true)
  }
  
}

extension LaunchWatchlistView: LaunchTableViewProtocol {
  
  func didSelectLaunch(_ launch: LaunchModel) {
    
    self.showDetailLaunch(launch)
    
  }
}
