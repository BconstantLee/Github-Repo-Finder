//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SettingsPresentingViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    var repos: [GithubRepo]! = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //initialize the table view
        tableView.dataSource = self
        tableView.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        
    }
    
    //setup for table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoCell
        let repo = repos[indexPath.row]
        
        cell.title.text = repo.name
        cell.title.sizeToFit()
        
        cell.owner.text = repo.ownerHandle
        cell.owner.sizeToFit()
        
        let stars = repo.stars!
        cell.star.text = "\(stars)"
        cell.star.sizeToFit()
        
        let forks = repo.forks!
        cell.fork.text = String(describing: forks)
        cell.fork.sizeToFit()
        
        cell.descrip.text = repo.des
        cell.descrip.sizeToFit()
        
        if let imageUrl = URL(string: repo.ownerAvatarURL!) {
//            print("enter:\(imageUrl)")
            cell.imageCell.setImageWith(imageUrl)
        } else { cell.imageCell = nil }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in

            // Print the returned repositories to the output window
//            for repo in newRepos {
//                print(repo)
//            }
            self.repos = newRepos
            

            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
            
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    func didSaveSettings(settings: GithubRepoSearchSettings) {
        searchSettings = settings
        print("star: \(searchSettings.minStars)")
        doSearch()
    }
    
    func didCancelSettings() {
        print("star: \(searchSettings.minStars)")
        doSearch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let vc = navController.topViewController as! SearchSettingsViewController
        vc.settings = searchSettings  // ... Search Settings ...
        vc.delegate = self
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

protocol SettingsPresentingViewControllerDelegate: class {
    func didSaveSettings(settings: GithubRepoSearchSettings)
    func didCancelSettings()
}
