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
    
    var interactor = ListInteractor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.viewController = self
        interactor.retrieveUsers()
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
        return interactor.users.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if interactor.users.count - indexPath.row <= fetchTreshold && !interactor.isFechting {
            interactor.fetchMore()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier)!
        let user = interactor.users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier, let details = segue.destination as? DetailsViewController,
            let index = tableView.indexPathForSelectedRow?.row {
            details.user = interactor.users[index]
        }
    }
}

//extension ListViewController: NSFetchedResultsControllerDelegate {
//    lazy var fetchedResultsController: NSFetchedResultsController<User> = {
//        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
//        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//        let aFetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
//        aFetchedResultController.delegate = self
//
//        do {
//            try aFetchedResultController.performFetch()
//        } catch (let error) {
//            showError(msg: error.localizedDescription)
//        }
//        return aFetchedResultController
//    }()
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .none)
//        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .none)
//        case .update, .move:
//            break
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }
//}
