//
//  ChoiceController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ChoiceController: UIViewController {
    
    var currentLanguages: Languages?
    weak var mainController: LanguageCurrentDelegate?

    @IBOutlet weak var currentLanguageLable: UILabel!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    var choice: String?
    var segueType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCurrentLanguage()
        setButtons()
    }
    
    @IBAction func firstChoice() {
        if segueType == "leftButton" {
            currentLanguages?.sourseLanguage = Languages.getLanguage(language: firstButton.titleLabel!.text!)
        } else {
            currentLanguages?.resultLanguage = Languages.getLanguage(language: firstButton.titleLabel!.text!)
        }
        mainController?.changeCurentLanguage(sourseLanguage: currentLanguages!.sourseLanguage,
                                             resultLanguage: currentLanguages!.resultLanguage)
    }
    
    @IBAction func secondChoice() {
        if segueType == "leftButton" {
            currentLanguages?.sourseLanguage = Languages.getLanguage(language: secondButton.titleLabel!.text!)
        } else {
            currentLanguages?.resultLanguage = Languages.getLanguage(language: secondButton.titleLabel!.text!)
        }
        mainController?.changeCurentLanguage(sourseLanguage: currentLanguages!.sourseLanguage,
                                             resultLanguage: currentLanguages!.resultLanguage)
    }
    
    // MARK: - Navigation


    private func setCurrentLanguage() {
        if segueType == "leftButton" {
            currentLanguageLable.text = currentLanguages?.sourceLanguageText
        } else {
            currentLanguageLable.text = currentLanguages?.resultLanguageText
        }
    }
    
    private func setButtons() {
        var languages: [String] = []
        if segueType == "leftButton" {
            languages = Languages.otherLanguages(for: currentLanguages!.sourseLanguage)
        } else {
            languages = Languages.otherLanguages(for: currentLanguages!.resultLanguage)
        }
        firstButton.setTitle(languages.first, for: .normal)
        secondButton.setTitle(languages.last, for: .normal)
    }
    
}
