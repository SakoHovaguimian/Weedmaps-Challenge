//
//  PopUpView.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

class PopUpView: UIView {
    
    private var business: Business?

    private var nameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    
    init(business: Business, frame: CGRect) {
        super.init(frame: frame)
        self.business = business
        self.configureView()
        self.setupViews()
    }
    
    private func configureView() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .black
        self.layer.cornerRadius = 11
        
        self.addSubview(self.nameLabel)
        
        self.nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        self.nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        self.nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8).isActive = true
        
        self.addSubview(self.imageView)
        
        self.imageView.bottomAnchor.constraint(equalTo: self.nameLabel.topAnchor, constant: -16).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        
    }
    
    private func setupViews() {
        
        guard let business = self.business else { return }
        
        self.nameLabel.text = business.name
        self.imageView.kf.setImage(with: URL(string: business.imageURL)!)
        
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
