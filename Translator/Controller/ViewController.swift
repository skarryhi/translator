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
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language, controller: UITableViewController)
}

protocol ResultTextChange: class {
    func setResultText(resultLanguage: String)
    func getSourceLanguage() -> String
    func getResultLanguage() -> String
    func getSourceText() -> String
    func setSourceText(resultLanguage: String)
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
        
        placeholder.vc = self as ResultTextChange
        setTextPlaceholder()
        setButtonsLanguages()
        
        sourseLanguageButton.addTarget(self, action: #selector(tapedButton(button :)), for: .touchUpInside)
        resultLanguageButton.addTarget(self, action: #selector(tapedButton(button :)), for: .touchUpInside)
    }

    // MARK: - Placeholder
    
    private func setTextPlaceholder() {
        self.sourceText.textColor = .gray
        self.placeholder.language = self.languageManager.sourceLanguageISO
        self.sourceText.text = placeholder.text
        placeholder.isOn = true
    }
    
    //MARK: - Buttons
    
    
    private func setButtonsLanguages() {
        sourseLanguageButton.setTitle(languageManager.sourceLanguageText, for: .normal)
        resultLanguageButton.setTitle(languageManager.resultLanguageText, for: .normal)
        if placeholder.isOn == true {
            setTextPlaceholder()
        }
    }
    
    @objc private func tapedButton(button : UIButton) {
        var segue: String
        if button == self.sourseLanguageButton {segue = "leftButton"} else {segue = "rightButton"}
        var mainController = self as LanguageCurrentDelegate
        let choiseController = ChoiceController(segueType: segue, languageManager: languageManager, mainController: &mainController)
        let nvc = UINavigationController(rootViewController: choiseController)
        nvc.navigationBar.backgroundColor = #colorLiteral(red: 0.9992701411, green: 0.8648766875, blue: 0.3745337725, alpha: 1)
        present(nvc, animated: true)
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
        if placeholder.isOn == true {
            setTextPlaceholder()
        }
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
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language, controller: UITableViewController) {
        self.languageManager.sourseLanguage = sourseLanguage
        self.languageManager.resultLanguage = resultLanguage
        setButtonsLanguages()
    }
}

extension ViewController: ResultTextChange {
    func getSourceLanguage() -> String { return self.languageManager.sourceLanguageISO }
    func getResultLanguage() -> String { return self.languageManager.resultLanguageISO }
    func getSourceText() -> String { return self.sourceText.text }
    func setResultText(resultLanguage: String) { self.translatedText.text = resultLanguage }
    func setSourceText(resultLanguage: String) { self.sourceText.text = resultLanguage}
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
