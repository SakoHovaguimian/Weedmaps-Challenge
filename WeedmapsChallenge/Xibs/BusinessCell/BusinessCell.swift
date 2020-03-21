//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Kingfisher

protocol AddToFavoritesDelegate: class {
    func addToFavorites(business: Business)
}

class BusinessCell: UICollectionViewCell {
    
    //MARK: Reuse Identifier
    static let identifier = "BusinessCell"
    
    //MARK: Properties
    public var business: Business? {
        didSet {
            self.configure()
        }
    }
    
    weak var delegate: AddToFavoritesDelegate!

    //MARK: Outlets
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureViews()
    }
    
    //MARK: Helper Functions
    private func configure() {
        
        guard let business = self.business else { return }
        
        self.businessNameLabel.text = business.name

        if let url = URL(string: business.imageURL) {
            self.businessImageView.kf.setImage(with: url)
        }
        
        if business.isFavorite == true {
            self.addToFavoritesButton.setTitle("In Your Favs", for: .normal)
            self.addToFavoritesButton.isEnabled = false
        } else {
            self.addToFavoritesButton.setTitle("Add to Favorites", for: .normal)
            self.addToFavoritesButton.isEnabled = true
        }
        
    }
    
    private func configureViews() {
        
        self.layer.cornerRadius = 11
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 1
        
        self.addToFavoritesButton.layer.cornerRadius = 11
        self.addToFavoritesButton.addTarget(self, action: #selector(self.addToFavoritesButtonTapped(sender:)), for: .touchUpInside)
        
    }
    
    //MARK: @OBJC Functions
    @objc private func addToFavoritesButtonTapped(sender: UIButton) {
        guard let business = self.business else { return }
        self.delegate.addToFavorites(business: business)
    }
    
    
}
