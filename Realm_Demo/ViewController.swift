//
//  ViewController.swift
//  Realm_Demo
//
//  Created by Sky on 12/1/19.
//  Copyright © 2019 Andy. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var recentsSearch: [SearchLocal] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initTableView()
    }
    
    func initTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        reloadRecentSearch()
    }

    @IBAction func btnSearchTapped(_ sender: Any) {
        let recentSearch = SearchLocal()
        recentSearch.keyword = searchBar.text ?? ""
        recentSearch.date = Date()
        
        let realm = try! Realm()
        
        realm.beginWrite()
        if let existItem = realm.objects(SearchLocal.self).first(where: {$0.keyword.compare(recentSearch.keyword) == .orderedSame}) {
            existItem.date = Date()
        } else {
            realm.add(recentSearch)
        }
        try! realm.commitWrite()
        
        reloadRecentSearch()
    }
    
    func reloadRecentSearch() {
        let realm = try! Realm()
        let result = realm.objects(SearchLocal.self).sorted { (item1, item2) -> Bool in
            return item1.date.compare(item2.date) != .orderedAscending
        }
        
        recentsSearch = result
        tableView.reloadData()
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentsSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemSearchViewCell", for: indexPath) as! ItemSearchViewCell
        cell.lbContent.text = recentsSearch[indexPath.row].keyword
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension ViewController: ItemSearchViewCellDelegate {
    func itemSearchViewCell(cell: ItemSearchViewCell, didDeleteAt index: Int) {
        let item = recentsSearch[index]
        let realm = try! Realm()
        try! realm.write {
            if let recentSearch = realm.objects(SearchLocal.self).first(where: {$0.keyword.compare(item.keyword) == .orderedSame}) {
                realm.delete(recentSearch)
                recentsSearch.remove(at: index)
            }
        }
        
        tableView.reloadData()
    }
}
