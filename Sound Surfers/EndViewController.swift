//
//  EndViewController.swift
//  Sound Surfers
//
//  Created by Alexander Hall on 9/11/21.
//

import UIKit
import SpriteKit
import GameplayKit

class EndViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            let scene = EndScene()
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            
            // Present the scene
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.contentMode = .scaleToFill
        }
    }

}
