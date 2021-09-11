//
//  WaveSprite.swift
//  Sound Surfers
//
//  Created by matthew on 9/11/21.
//

import SpriteKit
import DSWaveformImage
import AVFoundation

// Contains the sprites and the audio player. Call the `update` method every frame to update the sprites.
class WaveSpriteController {
    private var audioPlayer : AVAudioPlayer
    private var waveData : [Float]
    private var waveSprite = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 100))
    var sprite : SKSpriteNode {
        get {
            return waveSprite
        }
    }
    init(audioPlayer: AVAudioPlayer, waveData: [Float]) {
        self.audioPlayer = audioPlayer
        self.waveData = waveData
        waveSprite.anchorPoint = CGPoint(x: 0.5, y: 0)
    }
    static func fromURL(_ url: URL, completionCallback: @escaping (WaveSpriteController?) -> Void) throws {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        let duration = audioPlayer.duration
        
        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: url)
        waveformAnalyzer?.samples(count: Int(duration / (1.0 / 30.0))) { data in
            if let data = data {
                print("waveData size is \(data.count)")
                completionCallback(WaveSpriteController(audioPlayer: audioPlayer, waveData: data))
            }
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func update() {
        let currentTimeNormalized = audioPlayer.currentTime / audioPlayer.duration
        let ix = Double(waveData.count) * currentTimeNormalized
        waveSprite.size.height = CGFloat((1 - waveData[Int(ix)]) * 200)
    }
}
