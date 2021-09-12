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
    var audioPlayer : AVAudioPlayer
    private var waveData : [Float]
    private var waveSprites : [SKSpriteNode]
    let barWidth = 5.0
    let barSpacing = 3.0
    var sprite = SKNode()
    init(audioPlayer: AVAudioPlayer, waveData: [Float], viewDimensions: CGSize) {
        self.audioPlayer = audioPlayer
        self.waveData = waveData
        
        let bars = Double(viewDimensions.width) / (barWidth + barSpacing)
        waveSprites = []
        for i in 0...Int(bars) {
            let sprite = SKSpriteNode(color: .red, size: CGSize(width: barWidth, height: 0))
            sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
            sprite.position.x = CGFloat((barWidth + barSpacing) * Double(i))
            self.sprite.addChild(sprite)
            
            waveSprites.append(sprite)
        }
    }
    static func fromURL(_ url: URL, viewDimensions: CGSize, completionCallback: @escaping (WaveSpriteController?) -> Void) throws {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.prepareToPlay()
        let duration = audioPlayer.duration
        
        let waveformAnalyzer = WaveformAnalyzer(audioAssetURL: url)
        waveformAnalyzer?.samples(count: Int(duration / (1.0 / 100.0))) { data in
            if let data = data {
                completionCallback(WaveSpriteController(audioPlayer: audioPlayer, waveData: data, viewDimensions: viewDimensions))
            }
        }
    }
    
    func play() {
        audioPlayer.play()
    }
    
    func update() {
        let offset = 0.6;
        let currentTimeNormalized = (audioPlayer.currentTime + offset) / audioPlayer.duration
        let _ix = Double(waveData.count) * currentTimeNormalized
        var ix = Int(_ix)
        for sprites in waveSprites.reversed() {
            sprites.size.height = CGFloat((1 - waveData[ix]) * 200)
            ix -= 1
            if ix < 0 {
                break
            }
            
            sprites.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5.0, height: sprites.size.height+SKTexture(imageNamed: "Surfer").size().height*1.2))
            sprites.physicsBody?.isDynamic = false
            sprites.physicsBody?.categoryBitMask = 2
            sprites.physicsBody?.collisionBitMask = 1
            sprites.physicsBody?.contactTestBitMask = 1
        }
    }
}
