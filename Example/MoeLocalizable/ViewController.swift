//
//  ViewController.swift
//  MoeLocalizable
//
//  Created by linyanzuo1222@gmail.com on 07/10/2019.
//  Copyright (c) 2019 linyanzuo1222@gmail.com. All rights reserved.
//

import UIKit
import MoeLocalizable
import MoeCommon


class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var pwdLabel: UITextField!
    @IBOutlet weak var transactionlabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var inviteLabel: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = LocalConfig.shared
        config.setLocalLanguage(.chineseTraditional)
//        config.useLocalizedDefault = true
        config.languageDidChange { [weak self] (language) in
            MLog(language?.rawValue)
            self?.test3()
        }
        
//        test()
//        test2()
        test3()
//        test4()
//        test5()
//        test6()
        
        nextBtn.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(localLanguageDidChange), name: Notification.Name.Localizable.LanguageChange, object: nil)
    }
    
    @objc func localLanguageDidChange(noti: Notification) {
        let language = noti.userInfo!["Language"] as? LocalLanguage
        MLog(language?.rawValue)
        test3()
    }
    
    @objc func changeLanguage() {
        LocalConfig.shared.setLocalLanguage(.english)
    }
    
    /// 通过表名加载本地化文本的原生实现
    private func test() {
        /**
         key: 本地化值的key, 如果找不到table, 则将key值作为文本
         tableName: 本地化文件的名称(区分大小写, 不需要.strings后缀), nil或空字符时则默认查找`Localizable.strings`
         comment: 注释值
         */
        let table = "Localized"
        titleLabel.text = NSLocalizedString("title", tableName: table, comment: "邮箱注册")
        usernameLabel.placeholder = NSLocalizedString("username", tableName: table, comment: "用户名")
        pwdLabel.placeholder = NSLocalizedString("password", tableName: table, comment: "登陆密码")
        transactionlabel.placeholder = NSLocalizedString("transaction", tableName: table, comment: "交易密码")
        emailLabel.placeholder = NSLocalizedString("email", tableName: table, comment: "邮箱")
        inviteLabel.placeholder = NSLocalizedString("invite_code", tableName: table, comment: "邀请码")
        nextBtn.setTitle(NSLocalizedString("next_step", tableName: table, comment: "下一步"), for: .normal)
    }
    
    /// 通过包加载本地化文本的原生实现
    private func test2() {
        /**
         key : 本地化值的key
         value : 本地化加载失败时, 使用的默认值
         tableName : 本地化文件的名称(区分大小写, 不需要.strings后缀), nil或空字符时则默认查找`Localizable.strings`
         */
        let table = "Localized"
        titleLabel.text = Bundle.main.localizedString(forKey: "title", value: "Default_邮箱注册", table: table)
        usernameLabel.placeholder = Bundle.main.localizedString(forKey: "username", value: "Default_用户名", table: table)
        pwdLabel.placeholder = Bundle.main.localizedString(forKey: "password", value: "Default_登陆密码", table: table)
        transactionlabel.placeholder = Bundle.main.localizedString(forKey: "transaction", value: "Default_交易密码", table: table)
        emailLabel.placeholder = Bundle.main.localizedString(forKey: "email", value: "Default_邮箱", table: table)
        inviteLabel.placeholder = Bundle.main.localizedString(forKey: "invite_code", value: "Default_邀请码", table: table)
        nextBtn.setTitle(Bundle.main.localizedString(forKey: "next_step", value: "Default_下一步", table: table), for: .normal)
    }
    
    /// 
    private func test3() {
        titleLabel.text = local.title
        usernameLabel.placeholder = local.username
        pwdLabel.placeholder = local.password
        transactionlabel.placeholder = local.transaction
        emailLabel.placeholder = local.email
        inviteLabel.placeholder = local.invite_code
        nextBtn.setTitle(local.next_step, for: .normal)
    }
    
    private func test4() {
        LocalConfig.shared.useLocalizedDefault = true
        print(LocalRegister.shared.stringLibURL)
        
        titleLabel.text = "新用户注册".localRegister(key: "register_title")
        usernameLabel.placeholder = "新用户名".localRegister(key: "register_username")
        pwdLabel.placeholder = "新密码".localRegister(key: "register_password")
        transactionlabel.placeholder = "新交易密码".localRegister(key: "register_transaction")
        emailLabel.placeholder = "新邮箱".localRegister(key: "register_email")
        inviteLabel.placeholder = "新邀请码".localRegister(key: "register_invite")
        nextBtn.setTitle("下一步 (新)".localRegister(key: "register_next_step"), for: .normal)
    }
    
    private func test5() {
        titleLabel.text = "新用户注册".localRegister(key: "title")
        usernameLabel.placeholder = "新用户名".localRegister(key: "username")
        pwdLabel.placeholder = "新密码".localRegister(key: "password")
        transactionlabel.placeholder = "新交易密码".localRegister(key: "transaction")
        emailLabel.placeholder = "新邮箱".localRegister(key: "email")
        inviteLabel.placeholder = "新邀请码".localRegister(key: "invite_code")
        nextBtn.setTitle("下一步 (新)".localRegister(key: "next_step"), for: .normal)
    }
    
    private func test6() {
        titleLabel.text = local.localized("title")
        usernameLabel.placeholder = local.localized( "username")
        pwdLabel.placeholder = local.localized("password")
        transactionlabel.placeholder = local.localized("transaction")
        emailLabel.placeholder = local.localized("email")
        inviteLabel.placeholder = local.localized("invite_code", "Hello world")
        nextBtn.setTitle(local.localized("next_step"), for: .normal)
    }
}

