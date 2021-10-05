//
//  Extension.swift
//  Covid App
//
//  Created by Baboon on 05/10/2021.
//

import UIKit
import Foundation
import SwifterSwift
import MBProgressHUD
import jsonlogic

struct Font {
    static func getFont(style: String, size: CGFloat) -> UIFont {
        return UIFont(name: style, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    //MARK: Poppins Font
    static var PoppinsRegular: (CGFloat) -> UIFont {
        return { getFont(style: "Poppins-Regular", size: $0)}
    }
    
    static var PoppinsMedium: (CGFloat) -> UIFont {
        return { getFont(style: "Poppins-Medium", size: $0)}
    }
    
    static var PoppinsBold: (CGFloat) -> UIFont {
        return { getFont(style: "Poppins-Bold", size: $0)}
    }
    
    static var PoppinsSemiBold: (CGFloat) -> UIFont {
        return { getFont(style: "Poppins-SemiBold", size: $0)}
    }
    
    static var PoppinsThin: (CGFloat) -> UIFont {
        return { getFont(style: "Poppins-Thin", size: $0)}
    }
}

struct Color {
    static let textColor: UIColor = UIColor(hexString: "#51405E")!
    static let mainColor: UIColor = UIColor(hexString: "#E0617F")!
    static let backgroundColor: UIColor = UIColor(hexString: "#F8F8F8")!
    static let bolderColor: UIColor = UIColor(hexString: "#E3E3EC")!
    static let blurColor: UIColor = UIColor(hexString: "#FBECEF")!
    static let sbgColor: UIColor = UIColor(hexString: "#F0EFEF")!
    static let blueColor: UIColor = UIColor(hexString: "#185ADB")!
    static let titleFieldColor: UIColor = UIColor(hexString: "#5E5873")!
}

extension UIColor {
    class var Main: UIColor {
        return UIColor(named: "Main") ?? .clear
    }
    class var Background: UIColor {
        return UIColor(named: "Background") ?? .clear
    }
    class var Bolder: UIColor {
        return UIColor(named: "Bolder") ?? .clear
    }
    class var Text: UIColor {
        return UIColor(named: "Text") ?? .clear
    }
    class var Blur20: UIColor {
        return UIColor(named: "Blur 20%") ?? .clear
    }
    class var Linear1: UIColor {
        return UIColor(named: "Linear1") ?? .clear
    }
    class var Linear2: UIColor {
        return UIColor(named: "Linear1") ?? .clear
    }
    class var SBG: UIColor {
        return UIColor(named: "SBG") ?? .clear
    }
    class var CovidBlue: UIColor {
        return UIColor(named: "Blue") ?? .clear
    }
    class var TitleField: UIColor {
        return UIColor(named: "TitleField") ?? .clear
    }
    class var Linear: [UIColor] {
        return [.Linear1, .Linear2]
    }
}

extension UIView {
    func showLoading(_ loading: Bool) {
        let previousBg = self.backgroundColor?.copy() as? UIColor
        if loading {
            HudHelper.shared.showHUD(for: self)
            self.backgroundColor = previousBg?.withAlphaComponent(0.5)
        } else {
            HudHelper.shared.hideHUD(for: self)
            self.backgroundColor = previousBg?.withAlphaComponent(1)
        }
    }

}

class HudHelper: NSObject {
    static private var manager: HudHelper?
    static var shared: HudHelper {
        if manager == nil {
            manager = HudHelper()
        }
        return manager!
    }
    
    var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    private var hud = MBProgressHUD()
    // MARK: - HUD
    func showHUD(_ isShow: Bool = true, _ isTopView: Bool = true) {
        if let window = appDelegate?.window, isTopView {
            if isShow {
                if !window.subviews.contains(where: {String(describing: type(of: $0.self)) == "MBProgressHUD"}) {
                    let hud = MBProgressHUD.showAdded(to: window, animated: true)
                    hud.bezelView.color = #colorLiteral(red: 0.9334154725, green: 0.9253697991, blue: 0.9334509969, alpha: 1) .withAlphaComponent(0.85)
                    hud.bezelView.style = .solidColor
                    hud.bezelView.blurEffectStyle = .light
                }
            } else {
                MBProgressHUD.hide(for: window, animated: true)
            }
        }
    }
    
    func showHUD(for view: UIView, _ isShow: Bool = true) {
        if isShow {
            if !view.subviews.contains(where: {String(describing: type(of: $0.self)) == "MBProgressHUD"}) {
                let hud = MBProgressHUD.showAdded(to: view, animated: true)
                hud.bezelView.color = .clear
                hud.bezelView.style = .solidColor
                hud.contentColor = .gray
            }
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func hideHUD(for view: UIView) {
        HudHelper.shared.showHUD(for: view, false)
    }
    
    func hideHUD() {
        self.showHUD(false)
    }
}

extension UIViewController {
    func showLoading(_ loading: Bool) {
        HudHelper.shared.showHUD(for: self.view, loading)
    }
    func showError(_ error: Error) {
        if error.code == 1 {
            showAlert(title: "Error \(error.code)", message: error.localizedDescription, completion: {
                _ in
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            showAlert(title: "Error \(error.code)", message: error.localizedDescription)
        }
    }
}

extension UITextField {
    func addImageLeftView(image : UIImage?, size: CGSize) {
        guard let image = image else { return }
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        view.image = image
        view.contentMode = .center
        self.leftView = view
        self.leftViewMode = .always
    }
}
