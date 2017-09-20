//
//  InterfaceController.swift
//  WKFalldown Extension
//
//  Created by John Quinn on 7/23/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController, WKCrownDelegate {
    
    private var game: GameScene!

    @IBOutlet var skInterface: WKInterfaceSKScene!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        crownSequencer.delegate = self
        crownSequencer.focus()
        
        // Configure interface objects here.
        
        // Load the SKScene from 'GameScene.sks'
        if let scene = GameScene(fileNamed: "GameScene") {
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            game = scene
            
            // Present the scene
            self.skInterface.presentScene(scene)
            
            crownSequencer.delegate = self
            crownSequencer.focus()
            
            // Use a value that will maintain a consistent frame rate
            self.skInterface.preferredFramesPerSecond = 30
            
        }
    }
    
    func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
               
        if rotationalDelta > 0 {
            game.moveBallRight()
            
        } else if rotationalDelta < 0 {
            game.moveBallLeft()
        }
    }
    
    func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        game.stopBall()
    }
    
    @IBAction func handleSingleTap(_ sender: Any) {
        
        game.restartGame()
    
    }
    
    @IBAction func menuPressed() {
        // RETURN PLAYER TO MENU
        
        UserDefaults.standard.set(self.game.score, forKey: "LATESTSCORE")
        
        WKInterfaceController.reloadRootControllers(withNames: ["Menu"], contexts: ["Menu"])
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        crownSequencer.delegate = self
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
