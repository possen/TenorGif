//
//  DetailViewController.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import AVKit
import AVFoundation

class VideoViewController: AVPlayerViewController {
    var model: AssetModel.Result?
    var del = PlayerDelegate()
    
    override func viewDidLoad() {
        self.delegate = del
        exitsFullScreenWhenPlaybackEnds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let model = model else {
            return
        }
        let url = model.media[0].loopedmp4.url
        player = AVPlayer(url: url)
        player?.play()
    }
}
