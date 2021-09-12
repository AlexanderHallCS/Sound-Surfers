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

    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    
    @IBOutlet var winOrLoseImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Score: \(score)"
        if(gameOver) {
            winOrLoseImage.image = UIImage(named: "GameOverText")
        } else {
            winOrLoseImage.image = UIImage(named: "YouWonText")
        }
    }

}
