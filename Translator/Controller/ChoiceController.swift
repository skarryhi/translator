//
//  ChoiceController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ChoiceController: UITableViewController {
    
    var languageManager: LanguageManager
    weak var mainController: LanguageCurrentDelegate?

    var currentLanguage = ""
    var languages = [String]()
    var segueType: String
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentLanguage()
        createLanguagesList()
        tableView.delegate = self
        tableView.insetsContentViewsToSafeArea = true
        tableView.separatorStyle = .none
    }
    
    init(segueType: String, languageManager: LanguageManager, mainController: inout LanguageCurrentDelegate) {
        self.segueType = segueType
        self.languageManager = languageManager
        self.mainController = mainController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languageManager.numberOfLanguages
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

        var cv1 = tableView.dequeueReusableCell(withIdentifier: "cv1")
        if cv1 == nil {
            cv1 = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cv1")
        }
        guard let cell = cv1 else { fatalError("Failed to get a cell!") }
        cell.textLabel?.text = languages[indexPath.row]
        if cell.textLabel?.text == currentLanguage {
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if segueType == "leftButton" {
            languageManager.sourseLanguage = LanguageManager.getLanguage(language: languages[indexPath.row])
        } else {
            languageManager.resultLanguage = LanguageManager.getLanguage(language: languages[indexPath.row])
        }
        mainController?.changeCurentLanguage(sourseLanguage: languageManager.sourseLanguage,
                                             resultLanguage: languageManager.resultLanguage, controller: self)
        dismiss(animated: true, completion: nil)
        return indexPath
    }
}
