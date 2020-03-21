//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import WebKit


class HomeDetailViewController: UIViewController {
    
    // MARK: Properties
    public var business: Business?
    
    //MARK: Outlets
    @IBOutlet private var webView: WKWebView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureWebView()
    }
    
    // MARK: Helper Functions
    func configureWebView() {
        
        self.webView.allowsBackForwardNavigationGestures = true
        
        guard let business = self.business,
            let url = business.url else { return }
        
        if let businessURL = URL(string: url) {
            self.webView.load(URLRequest(url: businessURL))
        }
        
    }
}
