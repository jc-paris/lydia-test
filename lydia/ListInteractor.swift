//
//  ListInteractor.swift
//  lydia
//
//  Created by Jean-Christophe Paris on 25/08/2018.
//  Copyright © 2018 Jean-Christophe Paris. All rights reserved.
//

import Foundation

class ListInteractor {
    weak var viewController: ListViewController?

    let fetchCount = 20
    var users: [UserViewModel] = []
    var isFechting = false {
        didSet {
            viewController?.updateFetchingState(isFechting)
        }
    }
    
    func retrieveUsers() {
        users = UserDataManager.shared.users.map { UserViewModel(user: $0) }
        if users.count == 0 {
            fetchMore()
        }
    }
    
    func fetchMore() {
        let page = users.count / fetchCount + 1
        isFechting = true
        UserService.fetchUser(page: page, count: fetchCount) { [weak self] (results, error) in
            self?.isFechting = false
            guard let results = results else {
                self?.viewController?.showError(msg: error!.localizedDescription)
                return
            }
            do {
                let users = try UserDataManager.shared.saveUserResults(results)
                self?.users.append(contentsOf: users.map { UserViewModel(user: $0) })
                self?.viewController?.fetchedUsers(users)
            } catch {
                let nserror = error as NSError
                self?.viewController?.showError(msg: nserror.localizedDescription)
            }
        }
    }
}
