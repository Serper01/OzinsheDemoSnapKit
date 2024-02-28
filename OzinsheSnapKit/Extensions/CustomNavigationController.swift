//
//  CustomNavigationController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 25.02.2024.
//

import UIKit

class CustomNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.count > 1 {
            let backButtonItem = UIBarButtonItem(image: UIImage(named: "BackButton"), style: .plain, target: self, action: #selector(goBack))
            backButtonItem.tintColor = UIColor(named: "#111827 - #FFFFFF")
            viewController.navigationController?.navigationBar.isHidden = false
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        
    }
    @objc private func goBack() {
        self.popViewController(animated: true)
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

