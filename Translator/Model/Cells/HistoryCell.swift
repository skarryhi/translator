//
//  HistoryCell.swift
//  Translator
//
//  Created by Saturn Karry on 6/3/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit


class HistoryCell : UITableViewCell {
    let minValue = 0
    
    var pair : History? {
        didSet {
            sourceLabel.text = pair?.source
            resultLabel.text = pair?.result
        }
    }
    
    private let sourceLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return lbl
    }()
    
    private let resultLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        lbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let viewblue: UIView = {
           let view = UIView()
            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
        }()
        addSubview(viewblue)
        addSubview(sourceLabel)
        addSubview(resultLabel)
        viewblue.anchor(top: safeAreaLayoutGuide.topAnchor,
                        left: safeAreaLayoutGuide.leftAnchor,
                        bottom: safeAreaLayoutGuide.bottomAnchor,
                        right: safeAreaLayoutGuide.rightAnchor,
                        
                        paddingTop: 0,
                        paddingLeft: 0,
                        paddingBottom: 0,
                        paddingRight: 0,
                        
                        width: 0,
                        height: 0,
                        enableInsets: false)
        
        let stack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [sourceLabel, resultLabel])
            stack.distribution = .equalSpacing
            stack.alignment = .center
            stack.spacing = 30.0
            return stack
        }()

        addSubview(stack)
        stack.anchor(top: viewblue.topAnchor,
                     left: viewblue.leftAnchor,
                     bottom: viewblue.bottomAnchor,
                     right: viewblue.rightAnchor,
                     paddingTop: 20,
                     paddingLeft: 30,
                     paddingBottom: 0,
                     paddingRight: 30,
                     
                     width: 0,
                     height: 0,
                     enableInsets: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
