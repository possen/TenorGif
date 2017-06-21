//
//  DetailViewController.swift
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import AVKit
import AVFoundation

class DetailViewController: AVPlayerViewController {
    var model: AssetModel.Result!
    var del = PlayerDelegate()
    
    override func viewDidLoad() {
        self.delegate = del
        exitsFullScreenWhenPlaybackEnds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let url = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/102w0bsn0ge83qfv7za/102/hls_vod_mvp.m3u8") {
            let pl = AVPlayer(url: url)
            self.player = pl
            pl.play()
        }
    }
}
