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
    let token = "Bearer t1.9euelZqYi5uXkpial8yRzY-Qns7Jnu3rnpWakJCZisySnszHyJeOmpzPnMbl8_cCKTJ6-e81EC50_d3z90JXL3r57zUQLnT9.SvqNKivEDcvvSuCWBFRRZs7o9rzrt7-uu3jp0ZwmIXl-lDgtoqTMEzBfKq6dukUL6Y_mtGRWb38r8hukni2YAw"
    let folder_id = "b1gllin8jcku7jtu772i"
    var timer: Timer?
    
    @IBOutlet weak var sourseLanguageButton: UIButton!
    @IBOutlet weak var resultLanguageButton: UIButton!
    @IBOutlet weak var translatedTaxtLable: UILabel!
    @IBOutlet weak var textFieldOutlet: UITextField!
    
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
        if button.titleLabel?.text == currentLanguages.sourceLanguageText {
            vc.segueType = "leftButton"
        } else {
            vc.segueType = "rightButton"
        }
        vc.currentLanguages = self.currentLanguages
    }
    
    //MARK: - Buttons
    

    private func setButtonsLanguages() {
        sourseLanguageButton.setTitle(currentLanguages.sourceLanguageText, for: .normal)
        resultLanguageButton.setTitle(currentLanguages.resultLanguageText, for: .normal)
    }

    @IBAction func changedTextField(_ sender: Any) {
        if self.textFieldOutlet.text == "" {
            self.translatedTaxtLable.text = ""
            return
        }
//        let enteredText = textField.text
//        do {
//            sleep(1)
//        }
//        if enteredText != textField.text { return }
        createTimer()
//        requestAPI()

        
        
        
        
    }
    
    // MARK: - Timer
    
    func createTimer() {
        var savedString: String?
        savedString = self.textFieldOutlet.text
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
            "texts" : [self.textFieldOutlet.text],
            "sourceLanguageCode" : self.currentLanguages.sourceLanguageISO,
            "targetLanguageCode" : self.currentLanguages.resultLanguageISO
            ] as [String : Any]
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("ERROR JSON")
            return nil
        }
//        print(self.currentLanguages.resultLanguageISO)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(self.token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        return request
    }
    
    @objc private func requestAPI(timer: Timer) {
        guard let request = createRequest(),
            timer.userInfo as! String == self.textFieldOutlet.text!
            else {
                return
        }

//        print("\(savedString)  \(self.textFieldOutlet.text)")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("NO HAVE DATA")
                return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print (error)
            }
            
            if let jsonResult = try? JSONDecoder().decode(Translations.self, from: data) {
                DispatchQueue.main.async {
                   self.translatedTaxtLable.text = jsonResult.translations.first?.text
                }
                print(jsonResult)
            }
        }
        task.resume()
    }
}
