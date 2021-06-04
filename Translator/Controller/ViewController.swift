//
//  ViewController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit
import CoreData

protocol LanguageCurrentDelegate: class {
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language)
}

protocol ResultTextChange: class {
    func setResultText(resultLanguage: String)
    func getSourceLanguages() -> String
    func getResultLanguages() -> String
    func getSourceText() -> String
}

class ViewController: UIViewController {
    
    var languageManager = LanguageManager()
    var requestManager = RequestManager()
    var placeholder = Placeholder()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var sourseLanguageButton: UIButton!
    @IBOutlet weak var resultLanguageButton: UIButton!
    @IBOutlet weak var sourceText: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestManager.vc = self as ResultTextChange
        self.translatedText.isEditable = false
        self.sourceText.delegate = self
        self.translatedText.textColor = .darkGray
        
        setTextPlaceholder()
        setButtonsLanguages()
        
        
    }
    
    // MARK: - Placeholder
    
    private func setTextPlaceholder() {
        self.sourceText.textColor = .gray
        self.sourceText.text = placeholder.text
        placeholder.isOn = true
    }
    
    //MARK: - Buttons
    
    
    private func setButtonsLanguages() {
        sourseLanguageButton.setTitle(languageManager.sourceLanguageText, for: .normal)
        resultLanguageButton.setTitle(languageManager.resultLanguageText, for: .normal)
    }
    
    
    @IBAction func changeButton() {
        languageManager.swipe()
        setButtonsLanguages()
        if self.translatedText.text != "" {
            self.sourceText.text = self.translatedText.text
        } else {
            return
        }
        requestManager.timerRequest()
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
        setButtonsLanguages()
        if placeholder.isOn == false {
            requestManager.timerRequest()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ChoiceController,
            let button = sender as? UIButton
            else { return }
        if button == sourseLanguageButton {
            vc.segueType = "leftButton"
        } else {
            vc.segueType = "rightButton"
        }
        vc.languageManager = self.languageManager
        vc.mainController = self as LanguageCurrentDelegate
    }
    
    // MARK: - Core Data
    
    private func saveToHistory() {
        let item = History(context: self.context)
        item.source = self.sourceText.text
        item.result = self.translatedText.text
        do {
            try context.save()
            DispatchQueue.main.async {
            }
        }
        catch {
            print("DON't SAVE")
        }
        
    }
}

// MARK: - Protocols

extension ViewController: LanguageCurrentDelegate {
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language) {
        self.languageManager.sourseLanguage = sourseLanguage
        self.languageManager.resultLanguage = resultLanguage
    }
}

extension ViewController: ResultTextChange {
    func getSourceLanguages() -> String { return self.languageManager.sourceLanguageISO }
    func getResultLanguages() -> String { return self.languageManager.resultLanguageISO }
    func getSourceText() -> String { return self.sourceText.text }
    func setResultText(resultLanguage: String) { self.translatedText.text = resultLanguage }
}

// MARK: - TextChanged

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if self.sourceText.text.last == "\n" {
            self.sourceText.resignFirstResponder()
            self.sourceText.text.removeLast()
            if self.sourceText.text != "" {
                saveToHistory()
            }
        }
        if self.sourceText.text == "" {
            self.translatedText.text = ""
            if self.sourceText.isFirstResponder == false {
                setTextPlaceholder()
            }
            return
        }
        requestManager.timerRequest()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if placeholder.isOn == true {
            self.sourceText.text = ""
            self.sourceText.textColor = .black
            placeholder.isOn = false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if sourceText.text == "" {
            setTextPlaceholder()
        }
    }
}
