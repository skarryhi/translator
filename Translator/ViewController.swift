//
//  ViewController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    var currentLanguages = Languages()
    
    @IBOutlet weak var sourseLanguageButton: UIButton!
    @IBOutlet weak var resultLanguageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setButtonsLanguages()
    }
    

    @IBAction func changeButton() {
        currentLanguages.swipe()
        setButtonsLanguages()
    }
    
    // MARK: - Navigation
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ChoiceController,
              let button = sender as? UIButton
        else { return }
        if button.titleLabel?.text == currentLanguages.sourseLanguageText {
            vc.segueType = "leftButton"
        } else {
            vc.segueType = "rightButton"
        }
        vc.currentLanguages = self.currentLanguages
    }
    

    private func setButtonsLanguages() {
        sourseLanguageButton.setTitle(currentLanguages.sourseLanguageText, for: .normal)
        resultLanguageButton.setTitle(currentLanguages.resultLanguageText, for: .normal)
    }
}
