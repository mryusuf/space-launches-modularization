//
//  LaunchDetailInfographicTableViewCell.swift
//  SpaceLaunches
//
//  Created by Indra Permana on 19/11/20.
//

import UIKit
import SDWebImage

class LaunchDetailInfographicTableViewCell: UITableViewCell {

  @IBOutlet weak var infographicImageView: UIImageView!
  weak var parent: LaunchDetailView?
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func set(_ launchDetail: LaunchDetail, parent: LaunchDetailView) {
    self.parent = parent
    infographicImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
    infographicImageView.sd_setImage(with: URL(string: launchDetail.detail)) {_, _, _, _ in
      self.infographicImageView.snp.makeConstraints { make in
        make.top.bottom.right.left.equalToSuperview()
      }
      self.infographicImageView.isUserInteractionEnabled = true
      self.infographicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onInfographicTapped)))
    }
  }
  
  @objc func onInfographicTapped() {
    guard let parent = parent, let image = infographicImageView.image else { return }
    parent.showInfographicImage(for: image)
  }
    
}
