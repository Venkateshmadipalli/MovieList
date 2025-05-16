//
//  MovieListTests.swift
//  MovieListTests
//
//  Created by Venkatesh MAdipalli on 13/05/25.
//

import XCTest
@testable import MovieList

class HomeViewControllerTests: XCTestCase {
    
    var sut: HomeViewController! // sut = System Under Test
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        _ = sut.view // Triggers viewDidLoad
    }
    
    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    func testInitialSegmentSelected_ShowsMoviesView() {
        XCTAssertEqual(sut.sigment.selectedSegmentIndex, 0)
        XCTAssertFalse(sut.movies?.view.isHidden ?? true)
        XCTAssertTrue(sut.search?.view.isHidden ?? false)
    }
    
    func testSegmentChangedToSearch_ShowsSearchView() {
        sut.sigment.selectedSegmentIndex = 1
        sut.segmentChanged(sut.sigment)
        
        XCTAssertTrue(sut.movies?.view.isHidden ?? false)
        XCTAssertFalse(sut.search?.view.isHidden ?? true)
    }
    
    func testSegmentChangedToMovies_ShowsMoviesView() {
        sut.sigment.selectedSegmentIndex = 1
        sut.segmentChanged(sut.sigment)
        sut.sigment.selectedSegmentIndex = 0
        sut.segmentChanged(sut.sigment)
        
        XCTAssertFalse(sut.movies?.view.isHidden ?? true)
        XCTAssertTrue(sut.search?.view.isHidden ?? false)
    }
    
    func testChildViewControllersAddedToParent() {
        XCTAssertTrue(sut.children.contains(where: { $0 is MoviesViewController }))
        XCTAssertTrue(sut.children.contains(where: { $0 is SearchViewController }))
    }
}
