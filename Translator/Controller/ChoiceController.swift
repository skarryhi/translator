//
//  ChoiceController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ChoiceController: UITableViewController {
    
    var languageManager: LanguageManager = LanguageManager()
    weak var mainController: LanguageCurrentDelegate?

    var currentLanguage = ""
    var languages = [String]()
    var choice: String?
    var segueType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentLanguage()
        createLanguagesList()
        tableView.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageManager.numberOfLanguages + 1
    }
    
    // MARK: - Navigation

    private func setCurrentLanguage() {
        if segueType == "leftButton" {
            currentLanguage = languageManager.sourceLanguageText
        } else {
            currentLanguage = languageManager.resultLanguageText
        }
    }
    
    private func createLanguagesList() {
        self.languages += [currentLanguage]
        if segueType == "leftButton" {
            languages += LanguageManager.otherLanguages(for: languageManager.sourseLanguage)
        } else {
            languages += LanguageManager.otherLanguages(for: languageManager.resultLanguage)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableLanguageCell", for: indexPath) as! TableLanguageCell
        if indexPath.row == 0 {
            return cell
        }
        cell.textLabel?.text = languages[indexPath.row - 1]
        if cell.textLabel?.text == currentLanguage {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if segueType == "leftButton" {
            languageManager.sourseLanguage = LanguageManager.getLanguage(language: languages[indexPath.row - 1])
        } else {
            languageManager.resultLanguage = LanguageManager.getLanguage(language: languages[indexPath.row - 1])
        }
        mainController?.changeCurentLanguage(sourseLanguage: languageManager.sourseLanguage,
                                             resultLanguage: languageManager.resultLanguage)
        return indexPath
    }
}
