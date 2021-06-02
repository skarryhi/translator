//
//  APIRequests.swift
//  Translator
//
//  Created by Saturn Karry on 6/2/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation

class RequestManager {
    
    private let token = "Bearer t1.9euelZrKz5WUjMeJj5fKz8yem5SWle3rnpWakJCZisySnszHyJeOmpzPnMbl8_daUCJ6-e9_VXIS_t3z9xp_H3r5739VchL-.Pj-zSs_VHa9PxCemxUkdDNTOEECSFeTzk7FOgSkiWwp5AqdLg2xdJJ4Onw6S3haOdafD-ue-hNDY8DELYxc_AA"
    private let folder_id = "b1gllin8jcku7jtu772i"
    private var timer: Timer?
    weak var vc: ResultTextChange?
//    var translatedText: String
//    var currentLanguages: Languages
    

    // MARK: - Timer
    
    func timerRequest() {
        if vc?.getSourceText() == vc?.getPlaceholder() { return }
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
            "sourceLanguageCode" : vc?.getSourceLanguages() ?? "en",
            "targetLanguageCode" : vc?.getResultLanguages() ?? "ru"
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
            timer.userInfo as? String == vc?.getSourceText()
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
                    self.vc?.setResultText(resultLanguage: jsonResult.translations.first!.text)
                }
//                print(jsonResult)
            } else {
                print("Not convert")
            }
        }
        task.resume()
    }
}
