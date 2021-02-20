//
//  SearchTokenCell.swift
//  RestaurantMenu
//
//  Created by Sachin Gupta on 2/13/21.
//

import Foundation
import UIKit

class SearchTokenCell: UITableViewCell {
  @IBOutlet weak var tokenLabel: UILabel!
  @IBOutlet weak var continentImageView: UIImageView!
  
  var token: UISearchToken! {
    didSet {
      guard let continent = token?.representedObject as? Category else {
        return
      }
      tokenLabel.text = "Search by \(continent.description)"
      continentImageView.image = UIImage(systemName: "globe")
        continentImageView.tintColor = .systemBlue
    }
  }
}
