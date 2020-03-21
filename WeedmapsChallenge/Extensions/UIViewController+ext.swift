//
//  UIViewController+ext.swift
//  WeedmapsChallenge
//
//  Created by Sako Hovaguimian on 3/20/20.
//  Copyright © 2020 Weedmaps, LLC. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

