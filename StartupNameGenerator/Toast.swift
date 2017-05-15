//
//  Toast.swift
//  StartupNameGenerator
//
//  Created by Lucas Franco on 5/15/17.
//  Copyright © 2017 LucasFranco. All rights reserved.
//

import Foundation
import Toast_Swift

extension UIViewController{

    func showToast(text: String) {
    var style = ToastStyle()
    style.messageColor = UIColor.white
    self.view.makeToast(text, duration: 3.0, position: .center, style: style)
    
}
}
