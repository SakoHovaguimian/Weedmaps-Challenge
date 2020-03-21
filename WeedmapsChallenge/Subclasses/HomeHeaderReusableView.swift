//
//  HomeHeaderReusableView.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

class HomeHeaderReusableView: UICollectionReusableView {
    
    static let identifier = "HomeHeaderReusableView"
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.configure()
    }
    
    private func configure() {
        
        self.backgroundColor = .clear
        
        self.label.text = "Recent Searches"
        self.label.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.label.textColor = .white
        self.label.textAlignment = .left
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.label)
        
        NSLayoutConstraint.activate([
            self.label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            self.label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            self.label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 8),
            self.label.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        self.layoutIfNeeded()
        
    }
        
}
