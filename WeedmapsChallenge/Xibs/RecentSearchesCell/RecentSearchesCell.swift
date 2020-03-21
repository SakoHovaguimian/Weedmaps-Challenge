//
//  RecentSearchesCell.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/19/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

class RecentSearchesCell: UICollectionViewCell {
    
    // MARK: Reuse Identifier
    static let identifier = "RecentSearchesCell"
    
    // MARK: Properties
    public var search: String? {
        didSet {
            self.configure()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var parentView: UIView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.parentView.layer.cornerRadius = 11
    }
    
    // MARK: Helper Functions
    private func configure() {
        self.searchLabel.text = search
    }

}
