//
//  LaunchesView.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import UIKit
import Core
import Home
import RxSwift

protocol LaunchesViewProtocol: class {
  
  //  var presenter: LaunchesPresenterProtocol? { get set }
  func startLoading()
  func stopLoading()
  func displayUpcomingGoLaunches(_ launches: [LaunchModel])
  func displayPreviousLaunches(_ launches: [LaunchModel])
  
}

class LaunchesView: UIViewController {
  
  private var _presenter: GetHomeLaunchesPresenter<
    Any,
    HomeLaunchesDomainModel,
    Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>>,
    Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>>
  >
  private weak var scrollView: UIScrollView?
  private weak var containerView: UIView?
  private weak var upcomingGoCollectionView: UpcomingGoLaunchView?
  private weak var previousLaunchesUIView: LaunchesUIView?
  private weak var upcomingLabel: UILabel?
  private weak var previousLabel: UILabel?
  private weak var activityIndicator: UIActivityIndicatorView?
  private var isLoading = false
  private var scrollViewHeight: CGFloat = 0
  private var containerViewHeight: CGFloat = 0
  private var bags = DisposeBag()
  init(presenter: GetHomeLaunchesPresenter<
    Any,
    HomeLaunchesDomainModel,
    Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>>,
    Interactor<
      Any,
      [HomeLaunchesDomainModel],
      GetHomeLaunchesRepository<
        HomeLocalDataSource,
        HomeRemoteDataSource,
        HomeLaunchesTransformer>>
  >) {
    _presenter = presenter
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Space Launches"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    
    setupIndicatorView()
    setupScrollView()
    setupUpcomingGoCollectionView()
    setupPreviousLaunchesTableView()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    self._presenter.upcomingGoLaunches.subscribe(
      onNext: { list in
        let launchViewList = LaunchMapper.mapHomeLaunchesDomainToView(input: list)
        self.displayUpcomingGoLaunches(launchViewList)
      }).disposed(by: bags)
    
    self._presenter.getUpcomingLaunches(request: nil)
    
    self._presenter.previousLaunches.subscribe(
      onNext: { list in
        let launchViewList = LaunchMapper.mapHomeLaunchesDomainToView(input: list)
        self.displayPreviousLaunches(launchViewList)
      }).disposed(by: bags)
    
    self._presenter.getPreviousLaunches(request: nil)
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.prefersLargeTitles = false
    self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    self.view.backgroundColor = .systemBackground
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    containerViewHeight = containerView?.frame.size.height ?? 0
    scrollViewHeight = containerViewHeight + view.bounds.height
    scrollView?.contentSize = CGSize(width: self.view.frame.width, height: scrollViewHeight)
    scrollView?.delegate = self
    previousLaunchesUIView?.launchesTableView?.isScrollEnabled = false
  }
  
}

extension LaunchesView {
  
  func setupIndicatorView() {
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(activityIndicator)
    self.activityIndicator = activityIndicator
    
    self.activityIndicator?.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
  }
  
  func setupScrollView() {
    
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    self.view.addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalTo(self.view)
    }
    
    let cv = UIView()
    cv.backgroundColor = .systemBackground
    scrollView.addSubview(cv)
    cv.snp.makeConstraints { make in
      make.top.equalTo(scrollView)
      make.left.right.equalTo(self.view)
    }
    
    self.scrollView = scrollView
    self.containerView = cv
  }
  
  func setupUpcomingLaunchesLabel() {
    
    guard let containerView = containerView else { return }
    
    let upcomingLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    upcomingLabel.text = "Upcoming Launches"
    upcomingLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    
    containerView.addSubview(upcomingLabel)
    
    upcomingLabel.snp.makeConstraints { make in
      make.top.equalTo(containerView.safeAreaLayoutGuide.snp.topMargin).offset(20)
      make.left.equalTo(containerView.snp.left).offset(20)
      make.right.equalTo(containerView.snp.right).offset(-20)
    }
    
    self.upcomingLabel = upcomingLabel
    
  }
  
  func setupPreviousLaunchesLabel() {
    
    guard let containerView = containerView, let upcomingGoCollectionView = upcomingGoCollectionView  else { return }
    
    let previousLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    previousLabel.text = "Previous Launches"
    previousLabel.font = .systemFont(ofSize: 16, weight: .semibold)
    
    containerView.addSubview(previousLabel)
    
    previousLabel.snp.makeConstraints { make in
      make.top.equalTo(upcomingGoCollectionView.safeAreaLayoutGuide.snp.bottomMargin).offset(20)
      make.right.equalTo(containerView.snp.right).offset(-20)
      make.left.equalTo(containerView.snp.left).offset(20)
    }
    
    containerView.snp.makeConstraints { make in
      make.bottom.equalTo(previousLabel.snp.bottom)
    }
    
    self.previousLabel = previousLabel
    
  }
  
  func setupUpcomingGoCollectionView() {
    
    setupUpcomingLaunchesLabel()
    
    guard let containerView = containerView, let upcomingLabel = upcomingLabel else { return }
    
    let upcomingGoLaunchesView = UpcomingGoLaunchView()
    upcomingGoLaunchesView.setup()
    upcomingGoLaunchesView.delegate = self
    containerView.addSubview(upcomingGoLaunchesView)
    
    upcomingGoLaunchesView.snp.makeConstraints { make in
      make.left.right.equalTo(containerView)
      make.top.equalTo(upcomingLabel.safeAreaLayoutGuide.snp.bottomMargin).offset(20)
      make.height.equalTo(400)
    }
    
    self.upcomingGoCollectionView = upcomingGoLaunchesView
  }
  
  func setupPreviousLaunchesTableView() {
    
    setupPreviousLaunchesLabel()
    
    guard let scrollView = scrollView, let containerView = containerView else { return }
    
    let previousLaunchesView = LaunchesUIView()
    previousLaunchesView.setup()
    previousLaunchesView.delegate = self
    scrollView.addSubview(previousLaunchesView)
    
    previousLaunchesView.snp.makeConstraints { make in
      make.left.equalTo(self.view)
      make.right.equalTo(self.view)
      make.top.equalTo(containerView.safeAreaLayoutGuide.snp.bottomMargin).offset(0)
      make.height.greaterThanOrEqualTo(self.view.bounds.height)
      make.bottom.equalTo(scrollView.snp.bottom).offset(0)
    }
    
    self.previousLaunchesUIView = previousLaunchesView
    
  }
  func showDetailLaunch(_ launch: LaunchModel) {
    let launchDetailVC = LaunchesRouter().buildDetail(launch)
    launchDetailVC.hidesBottomBarWhenPushed = true
    self.navigationController?.pushViewController(launchDetailVC, animated: true)
  }
}

extension LaunchesView: UIScrollViewDelegate {
  
}

extension LaunchesView: LaunchesViewProtocol {
  
  func startLoading() {
    
    isLoading = true
    self.activityIndicator?.isHidden = false
    self.upcomingGoCollectionView?.isHidden = true
    self.activityIndicator?.startAnimating()
    
  }
  
  func stopLoading() {
    
    self.activityIndicator?.stopAnimating()
    self.activityIndicator?.isHidden = true
    self.upcomingGoCollectionView?.isHidden = false
    
  }
  
  func displayUpcomingGoLaunches(_ launches: [LaunchModel]) {
    
    self.upcomingGoCollectionView?.displayUpcomingGoLaunches(launches)
    
  }
  func displayPreviousLaunches(_ launches: [LaunchModel]) {
    
    self.previousLaunchesUIView?.displayPreviousLaunches(launches)
    
  }
  
}

extension LaunchesView: UpcomingGoLaunchViewProtocol {
  
  func didSelectUpcomingGoLaunch(_ launch: LaunchModel) {
    
    //    self.presenter?.showDetailLaunch(with: launch)
    self.showDetailLaunch(launch)
    
  }
}

extension LaunchesView: LaunchTableViewProtocol {
  
  func didSelectLaunch(_ launch: LaunchModel) {
    
    //    self.presenter?.showDetailLaunch(with: launch)
    self.showDetailLaunch(launch)
  }
}
