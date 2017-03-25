//
//  LoginViewController.swift
//  SuperBowl
//
//  Created by MMizogaki on 2017/03/04.
//  Copyright © 2017年 MMizogaki. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        domainTextField.delegate = self
        nameTextField.delegate = self
        
        // テキストを全消去するボタンを表示
        domainTextField.clearButtonMode = .always
        nameTextField.clearButtonMode = .always
        
        // 改行ボタンの種類を変更
        domainTextField.returnKeyType = .done
        nameTextField.returnKeyType = .done
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Actions
    @IBAction func push(_ sender: UIButton) {
        self.present(BowlsViewController(), animated: true, completion: nil)
    }
    
    @IBAction func openDebugMenu(sender: AnyObject!) {
        
        let debugMenuViewController = DebugMenuViewController.instantiate()
        let navigationController = UINavigationController(rootViewController: debugMenuViewController)
        
        self.present(navigationController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    // MARK: TextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // キーボードを隠す
        textField.resignFirstResponder()
        return true
    }
    
    // クリアボタンが押された時の処理
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        print("Clear")
        return true
    }
    
    // テキストフィールドがフォーカスされた時の処理
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("Start")
        return true
    }
    
    // テキストフィールドでの編集が終わろうとするときの処理
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("End")
        return true
    }
}
