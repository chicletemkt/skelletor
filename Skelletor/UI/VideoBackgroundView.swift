//
//  VideoBackgroundView.swift
//  Skelletor
//
//  Created by Ronaldo Faria Lima on 30/05/17.
//  Copyright © 2017 Nineteen Apps. All rights reserved.
//

import UIKit
import MediaPlayer

/// A video enabled background view with playback controls
public class VideoBackgroundView: UIView {
    var player: AVPlayer? {
        set {
            videoLayer.player = newValue
        }
        get {
            return videoLayer.player
        }
    }
    
    var videoLayer: AVPlayerLayer {
        let vlayer = layer as! AVPlayerLayer
        vlayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        return vlayer
    }

    override public static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    fileprivate var videoURL_: URL?
    
    /// The video URL. Must be set before starting playback.
    public var videoURL: URL? {
        set {
            if let newURL = newValue {
                player = AVPlayer(url: newURL)
            } else {
                player = nil
            }
            videoURL_ = newValue
        }
        get {
            return videoURL_
        }
    }
    
    /// Controls if a video will be played in loop or not.
    @IBInspectable
    public var loopPlayback: Bool = false
    
    
    /// Playback the video using normal speed.
    public func play() {
        if loopPlayback {
            NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil, using: { [unowned self](_) in
                DispatchQueue.main.async {
                    self.player?.seek(to: kCMTimeZero)
                    self.player?.play()
                }
            })
        }
        player?.play()
    }
    
    /// Pause playback.
    public func pause() {
        if loopPlayback {
            NotificationCenter.default.removeObserver(self)
        }
        player?.pause()
    }
}
