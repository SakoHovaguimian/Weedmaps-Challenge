//
//  WeedmapsChallengeUITests.swift
//  WeedmapsChallengeUITests
//
//  Created by Mark Anderson on 10/5/18.
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import UIKit
import XCTest
@testable import WeedmapsChallenge

class WeedmapsChallengeUITests: XCTestCase {
    
    var homeViewController_underTest: HomeViewController!

    override func setUp() {

        continueAfterFailure = false

        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        homeViewController_underTest = (storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
        
        _ = homeViewController_underTest.view

    }

    override func tearDown() {
        self.homeViewController_underTest = nil
    }
    
    func testSUT_HasSearchBar() {
        
        XCTAssertNotNil(homeViewController_underTest.searchBar)
    }
    
    func testSUT_ShouldSetSearchBarDelegate() {
        
        XCTAssertNotNil(self.homeViewController_underTest.searchBar)
    }
    
    func testSUT_QuerySearchText_AfterSearchButtonTapped() {
        
        let searchBar = homeViewController_underTest.navigationItem.searchController?.searchBar
        
        searchBar?.text = "Burgers"

        let expectedTargetSearchText = "Burgers"
        
        let actualTargetSearchText = "Burgers"
        
        XCTAssertEqual(expectedTargetSearchText, actualTargetSearchText)
    }
    
    func testSUT_ResultSearchText_AfterSearchButtonTapped() {
        
        let searchBar = homeViewController_underTest.navigationItem.searchController?.searchBar
        
        searchBar?.text = "Burgers"
        
        homeViewController_underTest.searchBarSearchButtonClicked(searchBar!)
        
        let expectedTargetSearchText = "Burgers"
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

        let actualTargetSearchText = searchBar?.text
        XCTAssertEqual(expectedTargetSearchText, actualTargetSearchText)
        
    }
    
    func testSUT_HomeCollectionView() {
        
        
        let app = XCUIApplication()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        let cellsQuery = collectionViewsQuery.cells
        cellsQuery.otherElements.containing(.staticText, identifier:"Grub Burger Bar").element.swipeUp()
        app.children(matching: .window).element(boundBy: 0).tap()
        
        
    }
}
