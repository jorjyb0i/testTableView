//
//  ViewController.swift
//  testTableViews
//
//  Created by jorjyb0i on 24.03.2021.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()
    let identifier = "mainTable"
    let treeObject = TreeObject(num: 0)
    var arrayOfCells: [TreeObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayOfCells = treeObject.children
        setupTableView(table: tableView, identifier: identifier)
    }
    
    override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            tableView.frame = view.bounds
    }
    
    func setupTableView(table: UITableView, identifier: String) {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        treeObject.setActive()
        treeObject.setHidden()
        showChildren(of: treeObject)
    }
    
    func showChildren(of parent: TreeObject) {
        for child in parent.children {
            child.setHidden()
        }
    }
    
    func hideAndDeactivateChildren(of parent: TreeObject) {
        for child in parent.children {
            if child.isActive {
                child.setActive()
                hideAndDeactivateChildren(of: child)
            }
            child.setHidden()
        }
    }
}

// -MARK: TableView Data Source & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedParent = treeObject.findElement(withIndex: indexPath.row) {
            tableView.beginUpdates()
            
            //Open node
            if !selectedParent.isActive {
                var increment = indexPath.row + 1
                for child in selectedParent.children {
                    arrayOfCells.insert(child, at: increment)
                    tableView.insertRows(at: [IndexPath.init(row: increment, section: 0)], with: .automatic)
                    increment += 1
                }
                selectedParent.setActive()
                showChildren(of: selectedParent)
            }
            
            //Hide node
            else {
                let toDelete = selectedParent.numberOfObjectsBelowLine()
                if toDelete > 0 {
                    for i in 1...toDelete {
                        arrayOfCells.remove(at: indexPath.row + 1)
                        tableView.deleteRows(at: [IndexPath.init(row: indexPath.row + i, section: 0)], with: .automatic)
                    }
                }
                selectedParent.setActive()
                hideAndDeactivateChildren(of: selectedParent)
            }
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = arrayOfCells[indexPath.row].title
        return cell
    }
}
