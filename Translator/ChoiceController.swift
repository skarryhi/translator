//
//  ChoiceController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ChoiceController: UITableViewController {
    
    var currentLanguages: Languages = Languages()
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
    
//    @IBAction func firstChoice() {
//        if segueType == "leftButton" {
//            currentLanguages?.sourseLanguage = Languages.getLanguage(language: firstButton.text!)
//        } else {
//            currentLanguages?.resultLanguage = Languages.getLanguage(language: firstButton.text!)
//        }
//        mainController?.changeCurentLanguage(sourseLanguage: currentLanguages!.sourseLanguage,
//                                             resultLanguage: currentLanguages!.resultLanguage)
//    }
//
//    @IBAction func secondChoice() {
//        if segueType == "leftButton" {
//            currentLanguages?.sourseLanguage = Languages.getLanguage(language: secondButton.titleLabel!.text!)
//        } else {
//            currentLanguages?.resultLanguage = Languages.getLanguage(language: secondButton.titleLabel!.text!)
//        }
//        mainController?.changeCurentLanguage(sourseLanguage: currentLanguages!.sourseLanguage,
//                                             resultLanguage: currentLanguages!.resultLanguage)
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentLanguages.numberOfLanguages + 1
    }
    
    // MARK: - Navigation


    private func setCurrentLanguage() {
        if segueType == "leftButton" {
            currentLanguage = currentLanguages.sourceLanguageText
        } else {
            currentLanguage = currentLanguages.resultLanguageText
        }
    }
    
    private func createLanguagesList() {
        self.languages += [currentLanguage]
        if segueType == "leftButton" {
            languages += Languages.otherLanguages(for: currentLanguages.sourseLanguage)
        } else {
            languages += Languages.otherLanguages(for: currentLanguages.resultLanguage)
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
            currentLanguages.sourseLanguage = Languages.getLanguage(language: languages[indexPath.row - 1])
        } else {
            currentLanguages.resultLanguage = Languages.getLanguage(language: languages[indexPath.row - 1])
        }
        mainController?.changeCurentLanguage(sourseLanguage: currentLanguages.sourseLanguage,
                                             resultLanguage: currentLanguages.resultLanguage)
        return indexPath
    }
}
