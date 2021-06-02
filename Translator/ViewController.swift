//
//  ViewController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

protocol LanguageCurrentDelegate: class {
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language)
}

class ViewController: UIViewController {

    var currentLanguages = Languages()
    let token = "Bearer t1.9euelZqTipyZi4qRlcqZz4qPloqPz-3rnpWakJCZisySnszHyJeOmpzPnMbl9Pc4PSd6-e8DQHnj3fT3eGskevnvA0B54w.RrhSmGb41MdGUQwbpKvMj7F5G-YQszlwbbejyoYHqwMGe7VHHgY1ljmsKrH0jOVgcVOLSP3TQdm9rb6XAWJfBQ"
    let folder_id = "b1gllin8jcku7jtu772i"
    var timer: Timer?
    
    @IBOutlet weak var sourseLanguageButton: UIButton!
    @IBOutlet weak var resultLanguageButton: UIButton!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var translatedText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translatedText.isEditable = false
        textField.delegate = self
        self.textField.textColor = .gray
        self.textField.text = "Enter the text"
        translatedText.textColor = .darkGray
        setButtonsLanguages()
    }
    
    //MARK: - Buttons
    

    private func setButtonsLanguages() {
        sourseLanguageButton.setTitle(currentLanguages.sourceLanguageText, for: .normal)
        resultLanguageButton.setTitle(currentLanguages.resultLanguageText, for: .normal)
    }


    @IBAction func changeButton() {
        currentLanguages.swipe()
        setButtonsLanguages()
        self.textField.text = self.translatedText.text
        timerRequest()
    }
    
    // MARK: - Timer
    
    func timerRequest() {
        if textField.text == "Enter the text" { return }
        var savedString: String?
        savedString = self.textField.text
        timer = Timer.scheduledTimer(timeInterval: 0.3,
                                     target: self,
                                     selector: #selector(requestAPI),
                                     userInfo: savedString,
                                     repeats: false)
    }
    
    // MARK: - API
    
    private func createRequest() -> URLRequest? {
        guard let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate") else {
            print("NO URL")
            return nil }
        
        let parameters = [
            "folder_id" : self.folder_id,
            "texts" : [self.textField.text],
            "sourceLanguageCode" : self.currentLanguages.sourceLanguageISO,
            "targetLanguageCode" : self.currentLanguages.resultLanguageISO
            ] as [String : Any]
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("ERROR JSON")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        return request
    }
    
    @objc private func requestAPI(timer: Timer) {
        guard let request = createRequest(),
            timer.userInfo as! String == self.textField.text!
            else { return }

        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("NO HAVE DATA")
                return }
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
//            } catch {
//                print (error)
//            }
            if let jsonResult = try? JSONDecoder().decode(Translations.self, from: data) {
                DispatchQueue.main.async {
                   self.translatedText.text = jsonResult.translations.first?.text
                }
//                print(jsonResult)
            }
        }
        task.resume()
    }
    // MARK: - Navigation
    
    @IBAction func save(_ unwindSegue: UIStoryboardSegue) {
        setButtonsLanguages()
        timerRequest()
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
        vc.currentLanguages = self.currentLanguages
        vc.mainController = self as LanguageCurrentDelegate
    }
}

extension ViewController: LanguageCurrentDelegate {
    func changeCurentLanguage(sourseLanguage: Language, resultLanguage: Language) {
        self.currentLanguages.sourseLanguage = sourseLanguage
        self.currentLanguages.resultLanguage = resultLanguage
    }
}

    // MARK: - TextField

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if self.textField.text == "" {
            self.translatedText.text = ""
            return
        }
        if self.textField.text.last == "\n" {
            self.textField.resignFirstResponder()
            self.textField.text.removeLast()
            if self.textField.text == "" {
                self.textField.textColor = .gray
                self.textField.text = "Enter the text"
                return
            }
        }
        timerRequest()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.textField.text == "Enter the text" {
            self.textField.text = ""
            self.textField.textColor = .black
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textField.text == "" {
            self.textField.textColor = .gray
            self.textField.text = "Enter the text"
        }
    }
}
