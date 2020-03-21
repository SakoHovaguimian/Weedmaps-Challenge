//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit


class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var noFavoritesLabel: UILabel!
    @IBOutlet weak var favoritesTableView: UITableView!
    
    private var businesses: [Business] = CacheManager.shared.fetchCachedBusinesses().sorted(by: { ($0.numberOfViews ?? 0) > ($1.numberOfViews ?? 0) })
    
    private let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private var popUpView: PopUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViews()
        self.setupTableView()
        self.setupTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.businesses = CacheManager.shared.fetchCachedBusinesses().sorted(by: { ($0.numberOfViews ?? 0) > ($1.numberOfViews ?? 0) })
        self.favoritesTableView.reloadData()
        self.configureViews()
        
    }
    
    private func configureViews() {
        
        self.title = "Favorites"
        
        self.noFavoritesLabel.isHidden = businesses.isEmpty ? false : true
        self.favoritesTableView.isHidden = businesses.isEmpty ? true : false
    }
    
    private func setupTableView() {
        
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        
        self.favoritesTableView.tableFooterView = UIView()
        
        self.favoritesTableView.register(UINib(nibName: FavoritesTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        
    }
    
    private func showPopUpViewFor(businessAt index: Int) {
        
        self.view.addSubview(self.visualEffectView)
        
        self.visualEffectView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.visualEffectView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.visualEffectView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true

        self.visualEffectView.alpha = 0.0
        
        self.popUpView = PopUpView(business: self.businesses[index], frame: CGRect.zero)
        self.popUpView.alpha = 0.0
        
        self.view.addSubview(self.popUpView)
        
        self.popUpView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -40).isActive = true
        self.popUpView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        self.popUpView.widthAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        self.popUpView.heightAnchor.constraint(equalToConstant: view.frame.width - 64).isActive = true
        
        self.popUpView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3) {
            
            self.visualEffectView.alpha = 1.0
            self.popUpView.alpha = 1.0
            self.popUpView.transform = .identity
            
        }
        
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissPopUpView))
        self.visualEffectView.addGestureRecognizer(tap)
    }
    
    //MARK: @OBJC Functions
    
    @objc private func dismissPopUpView() {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.visualEffectView.alpha = 0.0
            self.popUpView.alpha = 0.0
        }) { _ in
            self.popUpView.removeFromSuperview()
            self.visualEffectView.removeFromSuperview()
        }
        
    }
    

}

extension FavoritesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showPopUpViewFor(businessAt: indexPath.row)
    }
    
}

extension FavoritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.favoritesTableView.dequeueReusableCell(withIdentifier: FavoritesTableViewCell.identifier) as? FavoritesTableViewCell {
            cell.business = self.businesses[indexPath.row]
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    
    
}
