//
//  FavoritesTableViewCell.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: Reuse Identifier
    static let identifier = "FavoritesTableViewCell"
    
    // MARK: Properties
    public var business: Business? {
        didSet {
            self.configure()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    @IBOutlet weak var businessPriceLabel: UILabel!
    @IBOutlet weak var businessRatingLabel: UILabel!
    @IBOutlet weak var businessDistanceLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessStackView: UIStackView!
    
    // MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureParentView()
    }
    
    // MARK: Helper Functions
    private func configure() {
        
        guard let business = self.business else { return }
        
        self.businessNameLabel.text = business.name
        
        self.businessPriceLabel.text = business.price == nil ? "Not Enought Data" : "Price: \(business.price ?? "")"
        
        self.businessRatingLabel.text = business.rating == nil ? "Not Enough Data!" : "Rating: \(business.rating ?? 0.0)"
        
        self.businessDistanceLabel.text = "Distance: \(self.business?.distance?.convertToMiles().truncate(places: 1) ?? 0.0)"
    
        self.numberOfViewsLabel.text = "Number of Views: \(business.numberOfViews ?? 0)"
        
        if let url = URL(string: business.imageURL) {
            self.businessImageView.kf.setImage(with: url)
        }
        
    }
    
    private func configureParentView() {
        self.parentView.layer.cornerRadius = 11
        self.businessImageView.layer.cornerRadius = 11
    }

}
