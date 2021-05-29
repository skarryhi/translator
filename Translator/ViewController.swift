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
    @IBOutlet weak var translatedTaxtLable: UILabel!
    
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

    @IBAction func changedTextField(_ sender: Any) {
        guard let textField = sender as? UITextField else {
            print("NO SENDER")
            return}
        

        
        guard let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate") else {
            print("NO URL")
            return }
        let token = "Bearer t1.9euelZqTmY2MxovMiomajMiUkMqKz-3rnpWakJCZisySnszHyJeOmpzPnMbl8_cTXzd6-e8yKSZE_t3z91MNNXr57zIpJkT-.gnwRcy_zN-509Om0HWSfNvmxiov-Q9-a3lIvQtzt38RnqvDF0qHraVF_CYgDMQZ_dkNDP_qVDVs9hvv7OHreDQ"
        
        let parameters = [
            "folder_id" : "b1gllin8jcku7jtu772i",
            "texts" : [textField.text],
            "targetLanguageCode" : "ru"
            ] as [String : Any]
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("ERROR JSON")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("NO HAVE DATA")
                return }
            
            if let jsonResult = try? JSONDecoder().decode(Translations.self, from: data) {
                DispatchQueue.main.async {
                   self.translatedTaxtLable.text = jsonResult.translations.first?.text
                }
                print(jsonResult)
            }
        }
        task.resume()
        if textField.text == "" {
            self.translatedTaxtLable.text = ""
        }
    }
}
