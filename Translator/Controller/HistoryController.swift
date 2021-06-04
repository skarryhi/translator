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
        tableView.allowsSelection = false
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")

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

//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 500
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        
//        var cv1 = tableView.dequeueReusableCell(withIdentifier: "cv1")
//        if cv1 == nil {
//            cv1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cv1")
//        }
//        guard let cell = cv1 else { fatalError("Failed to get a cell!") }
        
        
        let item = translations![indexPath.row]
//        cell.textLabel?.text = item.source
//        cell.detailTextLabel?.text = item.result
//        print("\(item.source) \(item.result)")
        cell.pair = item
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
//                print("\(self.translations?.first!.source) \(self.translations?.first!.result)")
                self.tableView.reloadData()
            }
        }
        catch {
            print("DON'T FETCH")
        }
    }
    @IBAction func deleteHistory(_ sender: UIBarButtonItem) {
        guard let translations = self.translations,
            translations.count != 0
            else {
            let alert = UIAlertController(title: "History is clean", message: "", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        print(translations.count)
        let alert = UIAlertController(title: "Delete", message: "Do you whant to delete all words?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            for item in translations {
                self.context.delete(item)
            }
            try! self.context.save()
            self.tableView.reloadData()
        }
        let canсelAction = UIAlertAction(title: "Canсel", style: .default)
        alert.addAction(canсelAction)
        alert.addAction(yesAction)
        self.present(alert, animated: true, completion: nil)
    }
}
