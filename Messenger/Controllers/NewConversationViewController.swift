//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by 김종서 on 2021/08/25.
//

import UIKit
import JGProgressHUD


class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .extraLight)
    
    private let searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "Search for Users ..."
        
        return searchBar
        
    }()
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        
        return table
    }()
    
    private let noResultLabel: UILabel = {
        
        let label = UILabel()
        
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = .systemFont(ofSize: 20, weight: .bold)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        searchBar.delegate = self
        
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        
        searchBar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        
        dismiss(animated: true, completion: nil)
    }
    
}


extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        
    }
}
