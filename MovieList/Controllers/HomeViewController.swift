//
//  HomeViewController.swift
//  MovieList
//
//  Created by Venkatesh MAdipalli on 15/05/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var sigment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var movies : MoviesViewController?
    var search : SearchViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildViewControllers()
        updateContainer(index: sigment.selectedSegmentIndex)
        sigment.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
    }
    
    // MARK: - Segment Action
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateContainer(index: sender.selectedSegmentIndex)
    }
    
    // MARK: - Child Controller Setup
    private func setupChildViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Setup MoviesViewController
        if let moviesVC = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as? MoviesViewController {
            movies = moviesVC
            addChild(moviesVC)
            moviesVC.view.frame = containerView.bounds
            containerView.addSubview(moviesVC.view)
            moviesVC.didMove(toParent: self)
        }
        
        // Setup SearchViewController
        if let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController {
            search = searchVC
            addChild(searchVC)
            searchVC.view.frame = containerView.bounds
            containerView.addSubview(searchVC.view)
            searchVC.didMove(toParent: self)
        }
    }
    
    // MARK: - Switch Views
    private func updateContainer(index: Int) {
        movies?.view.isHidden = index != 0
        search?.view.isHidden = index != 1
    }
    
    // Optional back action
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
