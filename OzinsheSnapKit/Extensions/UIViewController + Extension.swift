//
//  UIViewController + Extension.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 12.03.2024.
//

import Foundation
import UIKit

extension UIViewController{
    
    func startApp(){
        let tabBarVC = TabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        self.present(tabBarVC, animated: true)
    }
}
