//
//  ViewController.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {

    let userCellIdentifier = "userCell"
    let loadingCellIdentifier = "loadingCell"
    let segueIdentifier = "showDetail"
    let fetchTreshold = 10
    let searchController = UISearchController(searchResultsController: nil)
    
    var interactor = ListInteractor()
    var filteredUser: [UserViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.viewController = self
        interactor.retrieveUsers()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search User"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRows = tableView.indexPathsForSelectedRows {
            selectedRows.forEach { tableView.deselectRow(at: $0, animated: true) }
        }
    }
    
    func showError(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func updateFetchingState(_ isFetching: Bool) {
        if isFetching {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activity.startAnimating()
            activity.center = view.center
            view.addSubview(activity)
            
            tableView.tableFooterView = view
        } else {
            tableView.tableFooterView?.removeFromSuperview()
            tableView.tableFooterView = nil
        }
    }
    
    func fetchedUsers(_ newUsers: [User]) {
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredUser.count : interactor.users.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard searchController.isActive == false else {
            return
        }
        if interactor.users.count - indexPath.row <= fetchTreshold && !interactor.isFechting {
            interactor.fetchMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier)!
        let user = searchController.isActive ? filteredUser[indexPath.row] : interactor.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let details = segue.destination as? DetailsViewController,
            let index = tableView.indexPathForSelectedRow?.row {
            details.user = searchController.isActive ? filteredUser[index] : interactor.users[index]
        }
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        filteredUser = interactor.users.filter { return $0.name.lowercased().contains(searchText) || $0.email.lowercased().contains(searchText) }
        tableView.reloadData()
    }
}
