//
//  MoviePlayerViewController.swift
//  OzinsheSnapKit
//
//  Created by Serper Kurmanbek on 03.03.2024.
//

import UIKit
import YouTubePlayer

class MoviePlayerViewController: UIViewController {
    
    var player = YouTubePlayerView()
    var video_link = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: " #FFFFFF - #121827")
        view.addSubview(player)
        player.loadVideoID(video_link)
        
        player.snp.makeConstraints { make in
            make.top.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
