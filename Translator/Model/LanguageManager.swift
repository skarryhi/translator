//
//  Languages.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import Foundation


enum Language {
    case english
    case russian
    case spanish
}

class LanguageManager {
    
    let numberOfLanguages = 3

    var sourseLanguage: Language {
        didSet {
            sourceLanguageText = getTextLanguage(language: self.sourseLanguage)
            sourceLanguageISO = getISOLanguage(language: self.sourseLanguage)
        }
    }
    var resultLanguage: Language {
        didSet {
            resultLanguageText = getTextLanguage(language: self.resultLanguage)
            resultLanguageISO = getISOLanguage(language: self.resultLanguage)
        }
    }
    
    var sourceLanguageText: String = "English"
    var resultLanguageText: String = "Spanish"
    
    var sourceLanguageISO: String = "en"
    var resultLanguageISO: String = "es"
    
    init() {
        sourseLanguage = .english
        resultLanguage = .spanish
    }
    
    
    private func getTextLanguage(language: Language) -> String {
        switch language {
        case .english:
            return "English"
        case .russian:
            return "Russian"
        case .spanish:
            return "Spanish"
        }
    }
    
    private func getISOLanguage(language: Language) -> String {
        switch language {
        case .english:
            return "en"
        case .russian:
            return "ru"
        case .spanish:
            return "es"
        }
    }
    
    static func getLanguage(language: String) -> Language {
        switch language {
        case "English":
            return .english
        case "Russian":
            return .russian
        case "Spanish":
            return .spanish
        default:
            return .english
        }
    }
    
    func swipe() {
        let sourse = sourseLanguage
        sourseLanguage = resultLanguage
        resultLanguage = sourse
    }
    
    static func otherLanguages(for language: Language) -> [String] {
        var otherLanguages: [String] = []
        
        switch language {
        case .english:
            otherLanguages.append("Russian")
            otherLanguages.append("Spanish")
        case .russian:
            otherLanguages.append("English")
            otherLanguages.append("Spanish")
        case .spanish:
            otherLanguages.append("English")
            otherLanguages.append("Russian")
        }
        return otherLanguages
    }
}


