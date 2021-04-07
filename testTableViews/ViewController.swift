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
    
    var numberOfRowsBelowTheLne = 0
    
    let treeObject = TreeObject(num: 0)
    var arrayOfCells: [TreeObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        treeObject.setActive()
        treeObject.setHidden()
        for child in treeObject.children {
            child.setHidden()
        }
        
        arrayOfCells = treeObject.children
        
        setupTableView(table: tableView, identifier: identifier)
        activateConstraints()
    }
    
    func setupTableView(table: UITableView, identifier: String) {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// -MARK: TableView Data Source & Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedParent = treeObject.findElement(withIndex: indexPath.row) {
            tableView.beginUpdates()
            if !selectedParent.isActive {
                var increment = indexPath.row + 1
                for child in selectedParent.children {
                    
                    arrayOfCells.insert(child, at: increment)
                    tableView.insertRows(at: [IndexPath.init(row: increment, section: 0)], with: .automatic)
                    
                    increment += 1
                }
                selectedParent.setActive()
                for child in selectedParent.children {
                    child.setHidden()
                }
                
            } else {
                
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
