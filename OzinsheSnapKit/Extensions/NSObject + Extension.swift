//
//  NSObject + Extension.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 25.02.2024.
//

import UIKit

extension NSObject {
    func adaptiveSize(for size: CGFloat) -> CGFloat {
        let screenSize = UIScreen.main.bounds.size
        let baseSize = CGSize(width: 375, height: 812)
        let scale = min(screenSize.width, screenSize.height) / min(baseSize.width, baseSize.height)
        
        return size * scale
    }
}

