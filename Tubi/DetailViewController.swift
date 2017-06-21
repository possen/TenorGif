//
//  DetailViewController.swift
//  Tubi
//
//  Created by Paul Ossenbruggen on 6/20/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit
import AVKit

class DetailViewController: AVPlayerViewController {
    var model: AssetModel.Result!
    var del = TubiPlayerDelegate()
    
    override func viewDidLoad() {
        self.delegate = del
        exitsFullScreenWhenPlaybackEnds = true
        if let url = URL(string: model.media[0].loopedmp4.url) {
            let pl = AVPlayer(url: url)
            self.player = pl
            pl.play()
        }
    }
}
