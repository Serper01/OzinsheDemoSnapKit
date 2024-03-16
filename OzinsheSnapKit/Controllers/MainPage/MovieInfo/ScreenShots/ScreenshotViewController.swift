//
//  ScreenshotViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 03.03.2024.
//

import UIKit

class ScreenshotShowViewController: UIViewController {
    var imageview = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        
        imageview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
