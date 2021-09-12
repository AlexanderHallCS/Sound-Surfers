//
//  StartScene.swift
//
//  Created by Matthew Tran on 9/11/21.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "StartBG")
        let playText = SKSpriteNode(imageNamed: "PlayText")

        background.size = self.size
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -1;
        addChild(background)
        
        playText.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playText.position = CGPoint(x: 0, y: -self.size.height/6)
        playText.setScale(0.7)
        playText.zPosition = 2
        addChild(playText)
        
        let fadeOut = SKAction.fadeAlpha(to: 0.1, duration: 1.1)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.1)
        playText.run(SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn])))
    }
    
    func touchDown(atPoint pos : CGPoint) {}
    
    func touchMoved(toPoint pos : CGPoint) {}
    
    func touchUp(atPoint pos : CGPoint) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
}
