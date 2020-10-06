//
//  Service.swift
//  firebaseSocialLoginPractice
//
//  Created by 旌榮 凌 on 2020/9/30.
//  Copyright © 2020 com.dltic. All rights reserved.
//

import UIKit
import LBTATools
import JGProgressHUD

class Service {
    static let baseColor = UIColor(red: 254/255, green: 202/255, blue: 64/255, alpha: 1)
    static let darkBaseColor = UIColor(red: 253/255, green: 166/255, blue: 47/255, alpha: 1)
    static let unSelectedItemColor = UIColor(red: 173/255, green: 173/255, blue: 173/255, alpha: 1)
    
    static let buttonTitleFontSize: CGFloat = 16
    static let buttonTitleColor = UIColor.white
    static let buttonBackgrountColorSignInAnonymously = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1)
    static let buttonBackgrountColorSignInWithFacebook = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    static let buttonBackgrountColorSignInWithTwitter = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    static let buttonBackgrountColorSignInWithGoogle = UIColor(red: 237/255, green: 90/255, blue: 64/255, alpha: 1)
    static let buttonCornerRadius: CGFloat = 7
    
    static let twitterKey = "wNUnAdAbfR9EBg9hMgajqlzDH"
    static let twitterSecret = "IPuwlkBm5T8mRwO97AAxvuKoCKXiUbfhiu0exoHJuUx1UcAUDt"
    
    static func showAlert(on:UIViewController, style: UIAlertController.Style, title:String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default, handler: nil)], completion: (()-> Swift.Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions{
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
    
    static func dismissHud(_ hud: JGProgressHUD, text: String, detailText: String, delay: TimeInterval){
        hud.textLabel.text = text
        hud.detailTextLabel.text = detailText
        hud.dismiss(afterDelay: delay, animated: true)
    }
}
