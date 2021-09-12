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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "Score: \(score)"
    }

}
