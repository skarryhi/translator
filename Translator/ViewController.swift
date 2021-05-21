//
//  ViewController.swift
//  Translator
//
//  Created by Saturn Karry on 5/21/21.
//  Copyright © 2021 ru.skarry. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstLanguageButton: UIButton!
    @IBOutlet weak var secondLanguageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

    @IBAction func changeButton() {
        let firstText = firstLanguageButton.titleLabel?.text
        firstLanguageButton.setTitle(secondLanguageButton.titleLabel?.text, for: .normal)
        secondLanguageButton.setTitle(firstText, for: .normal)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
