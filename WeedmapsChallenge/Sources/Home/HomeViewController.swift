//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation


class HomeViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet private var collectionView: UICollectionView!
    
    private var businesses: [Business] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var recentSearches: [String] = CacheManager.shared.fetchCachedSearches().reversed()
    private var favoriteBusinesses: [Business] = CacheManager.shared.fetchCachedBusinesses()
    
    private var locationManager = LocationManager.shared.locationManager
    
    private var searchController = UISearchController(searchResultsController: nil)
    private var searchResults = [Business]()
    
    private var inSearchMode: Bool {
        return self.searchController.isActive && !self.searchController.searchBar.text!.isEmpty
    }
    
    
    private var cellSpacingValue: CGFloat = 6.0
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureViews()
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    //MARK: Helper Functions
    private func configureViews() {
        
        self.configureCollectionView()
        
        self.title = "Yelp"
        self.definesPresentationContext = true
        
        self.view.backgroundColor = .white
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.placeholder = "Search For A Business!"
        self.searchController.searchBar.delegate = self

        self.navigationItem.searchController = self.searchController
        
    }
    
    private func configureCollectionView() {
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        self.collectionView.register(UINib(nibName: BusinessCell.identifier, bundle: nil), forCellWithReuseIdentifier: BusinessCell.identifier)
        self.collectionView.register(UINib(nibName: RecentSearchesCell.identifier, bundle: nil), forCellWithReuseIdentifier: RecentSearchesCell.identifier)
        self.collectionView.register(HomeHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeaderReusableView.identifier)
        
    }
    
    private func loadMoreBusinesses() {
        
        guard let query = searchController.searchBar.text else { return }
        guard let coorindate = self.locationManager.location?.coordinate else { return }
        
        YelpService.shared.fetchBusinesses(query: query,
                                    latitude: coorindate.latitude.description,
                                    longitude: coorindate.longitude.description,
                                    offset: self.businesses.count) { businesses, error in
                                        
            guard error == nil else {
                self.showAlert(title: "Network Error", message: error.debugDescription)
                return
            }
                                        
            guard let unrwappedBusinesses = businesses else { return }
                                        
            self.businesses.append(contentsOf: unrwappedBusinesses)
                                        
        }
        
        
    }
    
    private func handleSearchBarResults() {
        
        Alamofire.SessionManager.default.session.getAllTasks { (tasks) -> Void in
            tasks.forEach({ $0.cancel() })
        }
        
        DispatchQueue.main.async {
            
            guard let coorindate = self.locationManager.location?.coordinate else {
                self.showAlert(title: "Location Error", message: "Please check and see if you have locations turned on")
                return
            }
            
            guard let query = self.searchController.searchBar.text else { return }
            guard query.count > 2 else { return }
            
            YelpService.shared.fetchBusinesses(query: query, latitude: coorindate.latitude.description, longitude: coorindate.longitude.description) { businesses, error in
                
                guard error == nil else {
                    self.showAlert(title: "Network Error", message: error.debugDescription)
                    return
                }
                
                guard let unrwappedBusinesses = businesses else { return }
                
                self.businesses = unrwappedBusinesses
                
                self.collectionView.isUserInteractionEnabled = true
                
            }
            
        }
        
    }
    
    private func pushHomeDetailVC(withBusiness business: Business) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:  "HomeDetailViewController") as? HomeDetailViewController {
            
            vc.business = business
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    private func openSafari(forBusiness business: Business) {
    
        guard let businessURL = business.url,
            let url = URL(string: businessURL) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    
    }
    
}

// MARK: UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.handleSearchBarResults()
    }
    
}

// MARK: UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.businesses.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = self.searchController.searchBar.text else { return }
        guard query.count > 2 else {
            self.showAlert(title: "Query Error", message: "The seach field cannot be less than 3 characters, please add values")
            return
        }
        self.recentSearches.insert(query, at: 0)
        CacheManager.shared.cacheSearch(query)

    }
    
    //This is when the user clicks the 'x' button in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.businesses.removeAll()
        }
        
    }
    
}

// MARK: UICollectionViewDelegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.collectionView.isUserInteractionEnabled = false
        
        if self.inSearchMode {
            
            let business = self.businesses[indexPath.row]
            self.presentActionSheet(forBusiness: business)
            
        } else {
        
            let query = self.recentSearches[indexPath.row]
            self.searchController.searchBar.text = query
            self.recentSearches.insert(query, at: 0)
            CacheManager.shared.cacheSearch(query)
            self.searchController.isActive = true
            
        }

        
    }
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderReusableView.identifier, for: indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let height : CGFloat = self.inSearchMode ? 0 : 40
        return CGSize(width: self.view.frame.width, height: height)
        
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inSearchMode ? self.businesses.count : self.recentSearches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if self.inSearchMode {
            
            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCell.identifier, for: indexPath) as? BusinessCell {
                
                let business = self.businesses[indexPath.row]
                 // NOT USED YET. NEED FAVORITE UI
                
                cell.business = business
                cell.business?.isFavorite = business.isBusinessFavorited(self.favoriteBusinesses)
                cell.delegate = self
                
                return cell
                
            }
            
        } else {
            
            if let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchesCell.identifier, for: indexPath) as? RecentSearchesCell {
                
                cell.search = self.recentSearches[indexPath.row]
                
                return cell
            }

        }
        
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == self.businesses.count - 1 && self.inSearchMode == true {
            self.loadMoreBusinesses()
        }
        
    }
    
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfCellsPerRow: CGFloat = DeviceInfo.Orientation.isPortrait ? 2 : 4
        let heightForRow: CGFloat = DeviceInfo.Orientation.isPortrait ? 2.5 : 1
        
        let cellWidth = self.collectionView.frame.width / numberOfCellsPerRow
        let cellSpacing = (self.cellSpacingValue * 2) + 2.5 //Inset
        
        let cellHeight = self.collectionView.frame.height / heightForRow
        
        return self.inSearchMode ? CGSize(width: cellWidth - cellSpacing,
                                          height: cellHeight)
                                 : CGSize(width: self.collectionView.frame.width - (self.cellSpacingValue * 4),
                                          height: self.collectionView.frame.height / 8)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacingValue
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacingValue
    }
    
}

//MARK: AddToFavoritesDelegate
extension HomeViewController: AddToFavoritesDelegate {
    
    func addToFavorites(business: Business) {
        self.favoriteBusinesses.append(business)
        CacheManager.shared.cacheBusiness(business)
        self.collectionView.reloadData()
    }
    
}

// MARK: ALERTS
extension HomeViewController {
    
    private func presentActionSheet(forBusiness business: Business) {
        
        let actionSheet = UIAlertController(title: "Viewing Options For \(business.name)", message: "", preferredStyle: .actionSheet)
        
        let webViewAction = UIAlertAction(title: "Open in WebView", style: .default) { (_) in
            self.pushHomeDetailVC(withBusiness: business)
            CacheManager.shared.updateCachedBusiness(business)
        }
        
        let safariAction = UIAlertAction(title: "Open in Safari", style: .default) { (_) in
            self.openSafari(forBusiness: business)
            CacheManager.shared.updateCachedBusiness(business)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(safariAction)
        actionSheet.addAction(webViewAction)
        actionSheet.addAction(cancelAction)
        
        self.collectionView.isUserInteractionEnabled = true
        self.present(actionSheet, animated: true, completion: nil)

    }
    
}
