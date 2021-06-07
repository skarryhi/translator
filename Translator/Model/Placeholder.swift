//
//  Placeholder.swift
//  Translator
//
//  Created by Saturn Karry on 6/3/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class Placeholder {
    var requestManager = RequestManager()
    
    var isOn = true
    let textOnEnglish = "Enter text"
    var text: String?
    var vc: ResultTextChange?
    var language = "en" {
        didSet {
            requestPlaceholder(text: textOnEnglish, language: language)
        }
    }

    private func requestPlaceholder(text: String, language: String) {
        guard let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate") else {
            print("NO URL")
            return
        }
        
        let parameters = [
            "folder_id" : requestManager.folder_id,
            "texts" : [text],
            "sourceLanguageCode" : "en",
            "targetLanguageCode" : language
            ] as [String : Any]
        guard let json = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("ERROR JSON")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(requestManager.token, forHTTPHeaderField: "Authorization")
        request.httpBody = json
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("NO HAVE DATA")
                return }
            if let jsonResult = try? JSONDecoder().decode(Translations.self, from: data) {
                DispatchQueue.main.async {
                    self.vc?.setSourceText(resultLanguage: jsonResult.translations.first!.text)
                }
            } else {
                print("Not convert")
            }
        }
        task.resume()
    }
}
