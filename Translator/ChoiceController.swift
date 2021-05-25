//
//  ChoiceController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ChoiceController: UIViewController {
    
    weak var currentLanguages: Languages?

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
    }
    
    @IBAction func secondChoice() {
    }
    
    // MARK: - Navigation


    private func setCurrentLanguage() {
        if segueType == "leftButton" {
            currentLanguageLable.text = currentLanguages?.sourseLanguageText
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
