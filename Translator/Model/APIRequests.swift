//
//  APIRequests.swift
//  Translator
//
//  Created by Saturn Karry on 6/2/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation

class RequestManager {
    
    let token = "Bearer t1.9euelZqenMeZj83Pm5CNk5SKmceRyO3rnpWakJCZisySnszHyJeOmpzPnMbl9PdFbgd6-e8nH1Kl3fT3BR0FevnvJx9SpQ._pE5cpy581FWb1tups-6dJG912RcEwMkRw5V5prm5of3sUguIcinNWnBSk33DnngkQSp-kK-Hsfv4ow6hqMLAA"
    let folder_id = "b1gllin8jcku7jtu772i"
    private var timer: Timer?
    weak var vc: ResultTextChange?
//    var translatedText: String
//    var currentLanguages: Languages
    

    // MARK: - Timer
    
    func timerRequest() {
        var savedString: String?
        savedString = vc?.getSourceText()
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
            "texts" : [vc?.getSourceText()],
            "sourceLanguageCode" : vc?.getSourceLanguage() ?? "en",
            "targetLanguageCode" : vc?.getResultLanguage() ?? "ru"
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
            let string = timer.userInfo as? String,
            string == vc?.getSourceText()
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
                    if string == self.vc?.getSourceText() {
                        self.vc?.setResultText(resultLanguage: jsonResult.translations.first!.text)
                    }
                }
//                print(jsonResult)
            } else {
                print("Not convert")
            }
        }
        task.resume()
    }
}
