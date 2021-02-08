//
//  LaunchView.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 15/11/20.
//

import UIKit
import RxSwift
import SDWebImage
import SnapKit
import Lightbox
import Core
import LaunchDetail
import Watchlist

protocol LaunchDetailViewProtocol: class {
  
  func displayLaunch(name: String, image: String, desc: [LaunchDetail], infographic: [LaunchDetail])
  func updateToggleWatchlist(isInWatchlist: Bool)
  func onImageViewTapped()
  
}

class LaunchDetailView: UIViewController {
  
  private var _presenter: GetLaunchDetailPresenter<
    String,
    Bool,
    Interactor<
      String,
      Bool,
      ToggleWatchlistRepository<
        ToggleWatchlistLocalDataSource>>
  >
  private weak var launchImageView: UIImageView?
  private  weak var detailTableView: LaunchDetailTableView?
  private  weak var titleLabel: UILabel?
  private  weak var agencyLabel: UILabel?
  private  weak var launchDateLabel: UILabel?
  private  weak var addToWatchlistButton: UIButton?
  private var isInWatchlist = false
  private var _launch: LaunchModel
  private var bags = DisposeBag()
  
  init(
    presenter: GetLaunchDetailPresenter<
      String,
      Bool,
      Interactor<
        String,
        Bool,
        ToggleWatchlistRepository<
          ToggleWatchlistLocalDataSource>>>,
    launch: LaunchModel) {
    _presenter = presenter
    _launch = launch
    super.init(nibName: nil, bundle: nil)
    
    self.title = "Space Launch"
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    let launchDetails = LaunchMapper.mapLaunchModelToDetail(input: _launch)
    let splitLaunchDetails = launchDetails.reduce(([LaunchDetail](), [LaunchDetail]()) ) { (value, object) -> ([LaunchDetail], [LaunchDetail]) in
      var value = value
      if object.label == "Infographic" {
        value.1.append(object)
      } else {
        value.0.append(object)
      }
      return value
    }
    self.displayLaunch(name: _launch.name, image: _launch.image, desc: splitLaunchDetails.0, infographic: splitLaunchDetails.1)
  }
  
  override func viewDidLoad() {
    self.view.backgroundColor = .systemBackground
    //    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemFill]
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.hidesBarsOnSwipe = false
    
    setupToggleWatchlistButton()
    
  }
  
}

extension LaunchDetailView {
  
  func setupToggleWatchlistButton() {
    
    let isInWatchlist = self.checkIfInWatchlist(_launch)
    
    let addToWatchlistButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
    addToWatchlistButton.setImage(
      UIImage(named: "watchlist-\(isInWatchlist)"),
      for: .normal)
    addToWatchlistButton.imageView?.contentMode = .scaleAspectFit
    addToWatchlistButton.addTarget(self, action: #selector(toggleWatchlist), for: .touchUpInside)
    
    self.addToWatchlistButton = addToWatchlistButton
    let rightBarButtonItem = UIBarButtonItem(customView: addToWatchlistButton)
    self.navigationItem.rightBarButtonItem = rightBarButtonItem
    
  }
  
  @objc func toggleWatchlist() {
    self._presenter.isToggled.subscribe(
      onNext: { result in
//        print("LaunchDetailView result: \(result)")
        self.isInWatchlist = result
        if self.isInWatchlist {
          self.showAlert(title: "Success", message: "Added to Watchlist")
        } else {
          self.showAlert(title: "Success", message: "Removed from Watchlist")
        }
        self.updateToggleWatchlist(isInWatchlist: self.isInWatchlist)
      }, onError: { (Error) in
        print("error: \(Error)")
      })
      .disposed(by: bags)
    self._presenter.toggle(request: _launch.id)
  }
  
}

extension LaunchDetailView: LaunchDetailViewProtocol {
  
  func displayLaunch(name: String, image: String, desc: [LaunchDetail], infographic: [LaunchDetail]) {
    
    let launchImageView = UIImageView()
    launchImageView.sd_imageIndicator = SDWebImageActivityIndicator.medium
    launchImageView.sd_setImage(with: URL(string: image)) { _, _, _, _ in
      launchImageView.isUserInteractionEnabled = true
      launchImageView.addGestureRecognizer(
        UITapGestureRecognizer(target: self, action: #selector(self.onImageViewTapped))
      )
    }
    
    self.view.addSubview(launchImageView)
    launchImageView.snp.makeConstraints { make in
      make.left.right.equalTo(self.view)
      make.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin).offset(0)
      make.width.equalToSuperview()
      make.height.equalTo(250)
    }
    self.launchImageView = launchImageView
    
    let launchDetailTableView = LaunchDetailTableView()
    launchDetailTableView.setup(parent: self)
    launchDetailTableView.displayDetailLaunch(desc, infographic)
    self.view.addSubview(launchDetailTableView)
    
    launchDetailTableView.snp.makeConstraints { make in
      make.top.equalTo(launchImageView.snp_bottomMargin).offset(10)
      make.left.right.equalTo(self.view)
      make.bottom.equalTo(self.view).offset(0)
    }
    
  }
  
  func updateToggleWatchlist(isInWatchlist: Bool) {
    self.addToWatchlistButton?.setImage(
      UIImage(named: "watchlist-\(isInWatchlist)"),
      for: .normal)
  }
  
  @objc func onImageViewTapped() {
    guard let image: UIImage = self.launchImageView?.image
    else { return }
    self.showInfographicImage(for: image)
  }
  
  func checkIfInWatchlist(_ launchModel: LaunchModel) -> Bool {
    return launchModel.isInWatchlist
  }
  func showInfographicImage(for image: UIImage) {
    let image = [LightboxImage(image: image)]
    
    let lightBoxController = LightboxController(images: image, startIndex: 0)
    lightBoxController.pageDelegate = self as LightboxControllerPageDelegate
    lightBoxController.dismissalDelegate = self as LightboxControllerDismissalDelegate
    lightBoxController.dynamicBackground = true
    
    self.present(lightBoxController, animated: true, completion: nil)
  }
  
  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
      self.dismiss(animated: false, completion: nil)
    }))
    self.present(alert, animated: true)
  }
}

extension LaunchDetailView: LightboxControllerPageDelegate, LightboxControllerDismissalDelegate {
  
  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    
  }
  
  func lightboxControllerWillDismiss(_ controller: LightboxController) {
    
  }
  
}
