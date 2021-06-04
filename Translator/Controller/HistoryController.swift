//
//  HistoryController.swift
//  Translator
//
//  Created by Saturn Karry on 6/2/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit
import CoreData

class HistoryController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var translations: [History]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchHistory()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
        var cv1 = tableView.dequeueReusableCell(withIdentifier: "cv1")
        if cv1 == nil {
            cv1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cv1")
        }
        guard let cell = cv1 else { fatalError("Failed to get a cell!") }
        
        
        let item = translations![indexPath.row]
        cell.textLabel?.text = item.source
        cell.detailTextLabel?.text = item.result
//        print(item.source)
//        print(item.result)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            self.context.delete(self.translations![indexPath.row])
            try! self.context.save()
            self.fetchHistory()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }

    // MARK: - CoreData
    
    func fetchHistory() {
        do {
            try self.translations = context.fetch(History.fetchRequest())
            
            DispatchQueue.main.async {
                self.translations?.reverse()
                self.tableView.reloadData()
            }
        }
        catch {
            print("DON'T FETCH")
        }
    }
    @IBAction func deleteHistory(_ sender: UIBarButtonItem) {
        guard let translations = self.translations else {return}
        for item in translations {
            context.delete(item)
        }
        try! context.save()
        tableView.reloadData()
    }
}
