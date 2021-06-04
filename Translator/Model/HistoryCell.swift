//
//  HistoryCell.swift
//  Translator
//
//  Created by Saturn Karry on 6/3/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    var pair : History? {
        didSet {
            sourceText.text = pair?.source
            resultText.text = pair?.result
        }
    }
    
    private let sourceText: UILabel = {
        let lable = UILabel()
        lable.text = "1"
        return lable
    }()
    
    private let resultText: UILabel = {
        let lable = UILabel()
        lable.text = "2"
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(sourceText)
        addSubview(resultText)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
