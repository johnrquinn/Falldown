//
//  GameScene.swift
//  WKFalldown Extension
//
//  Created by John Quinn on 7/23/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import SpriteKit

enum ColliderType: UInt32 {
    
    case Ball = 1
    case Line = 2
    case GameOver = 4
    case Edge = 8
    case Gap = 16
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    
    var highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
    
    var latestScore = UserDefaults.standard.integer(forKey: "LATESTSCORE")
    
    let moveUp = SKAction.moveBy(x: 0, y:600, duration:5.0)
    
    var gameOver = false
    
    var ball = SKSpriteNode()
    
    let gameOverTest = SKSpriteNode()
    
    let rightEdge = SKSpriteNode()
    
    let leftEdge = SKSpriteNode()
    
    let bottomEdge = SKSpriteNode()
    
    var gapWidth = 48
    
    var halfGap = 0
    
    var bg = SKSpriteNode()
    
    var scoreLabel = SKLabelNode()
    
    var gameOverLabel = SKLabelNode()
    
    var gameOverScoreLabel = SKLabelNode()
    
    var highScoreLabel = SKLabelNode()
    
    var gameOverScoreInstructions = SKLabelNode()
    
    var wait = SKAction()
    
    var createForever = SKAction()
    
    override func sceneDidLoad() {
        
        physicsWorld.contactDelegate = self as SKPhysicsContactDelegate
        
        setUpGame()
        
    }
    
    func setUpGame() {
        
        // TODO: add app icon, background image on menu, fix background spawning, fix removing lines and gaps when they hit gameovertest, store scores on external server to show leaderboard
        
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        score = 0
        gapWidth = 55
        
        gameOver = false
        
        scene!.isPaused = false
        
        self.removeAllChildren()
        self.removeAllActions()
        
        // SET UP THE BALL
        
        let ballTexture = SKTexture(imageNamed: "falldownBall.png")
        ball = SKSpriteNode(texture: ballTexture)
     
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        ball.physicsBody!.categoryBitMask = ColliderType.Ball.rawValue
        ball.physicsBody!.collisionBitMask = ColliderType.Line.rawValue | ColliderType.Edge.rawValue
        ball.physicsBody!.contactTestBitMask = ColliderType.GameOver.rawValue | ColliderType.Gap.rawValue | ColliderType.Line.rawValue
        
        ball.physicsBody!.allowsRotation = false
        
        ball.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
        
        self.addChild(ball)

        // SET UP THE GAME OVER TRIGGER
        
        gameOverTest.alpha = 0
        
        gameOverTest.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 5))
        
        gameOverTest.physicsBody!.isDynamic = false
        
        gameOverTest.physicsBody!.categoryBitMask = ColliderType.GameOver.rawValue
        gameOverTest.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue | ColliderType.Line.rawValue | ColliderType.Gap.rawValue
        
        gameOverTest.position = CGPoint(x: self.frame.midX, y: self.frame.maxY + 20)
        
        self.addChild(gameOverTest)
        
        // SET UP THE LEFT EDGE
        
        leftEdge.alpha = 0
        
        leftEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.size.height))
        
        leftEdge.physicsBody!.isDynamic = false
        
        leftEdge.physicsBody!.categoryBitMask = ColliderType.Edge.rawValue
        leftEdge.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        
        leftEdge.position = CGPoint(x: self.frame.minX, y: self.frame.midY)
        
        self.addChild(leftEdge)
        
        // SET UP THE RIGHT EDGE
        
        rightEdge.alpha = 0
        
        rightEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 5, height: self.size.height))
        
        rightEdge.physicsBody!.isDynamic = false
        rightEdge.physicsBody!.affectedByGravity = false
        
        rightEdge.physicsBody!.categoryBitMask = ColliderType.Edge.rawValue
        rightEdge.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        
        rightEdge.position = CGPoint(x: self.frame.maxX, y: self.frame.midY)
        
        self.addChild(rightEdge)
        
        // SET UP THE BACKGROUND
        
        //* TODO: figure out why top part of screen isn't covered when game starts
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: 0, dy: bgTexture.size().height), duration: 11)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: 0, dy: -bgTexture.size().height), duration: 0)
        
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: self.frame.midX, y: -bgTexture.size().height * i)
            
            bg.size.width = self.frame.width
            
            bg.run(moveBGForever)
            
            bg.zPosition = -2
            
            self.addChild(bg)
            
            i += 1
            
        }
        
        // SET UP THE BOTTOM EDGE
        
        bottomEdge.alpha = 0
        
        bottomEdge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        
        bottomEdge.physicsBody!.isDynamic = false
        bottomEdge.physicsBody!.affectedByGravity = false
        
        bottomEdge.physicsBody!.categoryBitMask = ColliderType.Edge.rawValue
        bottomEdge.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        
        bottomEdge.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 1)
        
        self.addChild(bottomEdge)
        
        // SET UP THE SCORE LABEL
        
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        
        scoreLabel.position = CGPoint(x: self.frame.maxX - 5, y: self.frame.maxY - 51)
        
        scoreLabel.fontName = "Helvetica Bold"
        scoreLabel.fontSize = 36
        scoreLabel.zPosition = 1
        
        scoreLabel.text = String(score)
        
        self.addChild(scoreLabel)
        
        // LOOP LINE CREATION 
        
        let screenWidth = self.frame.maxX
        halfGap = gapWidth / 2
        
        createLine(at: CGPoint(x: CGFloat(arc4random_uniform(UInt32((Int(screenWidth) - halfGap) - halfGap)) + UInt32(halfGap)), y: self.frame.minY + 1), with: (CGFloat(self.gapWidth)))
        
        let create = SKAction.run { self.createLine(at: CGPoint(x: CGFloat(arc4random_uniform(UInt32((Int(screenWidth) - self.halfGap) - self.halfGap)) + UInt32(self.halfGap)), y: self.frame.minY + 1), with: (CGFloat(self.gapWidth))) }
        
        wait = SKAction.wait(forDuration: 0.7)
    
        createForever = SKAction.sequence([wait, create])
        
        // MARK: QUESTION: why does changing this from "wait, create" to "create, wait" screw it up so badly?
        
        self.run(SKAction.repeatForever(createForever), withKey: "createForever")
        
    }
    
    func createLine(at location: CGPoint, with gapWidth: CGFloat) {
        
        let lineTexture = SKTexture(imageNamed: "horizontalLine.png")
        
        let line = SKSpriteNode(texture: lineTexture)
        let line2 = SKSpriteNode(texture: lineTexture)
        
        let gap = SKSpriteNode()
    
        line.physicsBody = SKPhysicsBody(rectangleOf: line.size)
        line.physicsBody!.categoryBitMask = ColliderType.Line.rawValue
        line.physicsBody!.contactTestBitMask = ColliderType.GameOver.rawValue
        line.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        line.physicsBody!.isDynamic = false
        
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: gapWidth, height: (line.size.height / 4)))
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.collisionBitMask = 0
        gap.physicsBody!.contactTestBitMask = ColliderType.Ball.rawValue | ColliderType.GameOver.rawValue
        gap.physicsBody!.isDynamic = false
        
        line2.physicsBody = SKPhysicsBody(rectangleOf: line2.size)
        line2.physicsBody!.categoryBitMask = ColliderType.Line.rawValue
        line2.physicsBody!.contactTestBitMask = ColliderType.GameOver.rawValue
        line2.physicsBody!.collisionBitMask = ColliderType.Ball.rawValue
        line2.physicsBody!.isDynamic = false
        
        gap.position = CGPoint(x: location.x, y: location.y - (line.size.height / 2))
        self.addChild(gap)
        
        line.position = CGPoint(x: (location.x - (gapWidth / 2) - (line.size.width / 2)), y: location.y)
        line2.position = CGPoint(x: (location.x + (gapWidth / 2) + (line2.size.width / 2)), y: location.y)
        
        self.addChild(line)
        self.addChild(line2)
        
        line.run(moveUp)
        gap.run(moveUp)
        line2.run(moveUp)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // MARK: COLLISION DETECTION
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 4) {
            // if ball hit GameOverTest
            gameOver = true
            
            scene!.isPaused = true
            
            gameOverLabel.fontName = "Helvetica Bold"
            gameOverLabel.fontSize = 36
            gameOverLabel.zPosition = 1

            highScoreLabel.fontName = "Helvetica"
            highScoreLabel.fontSize = 36
            highScoreLabel.zPosition = 1
            
            gameOverScoreLabel.fontName = "Helvetica"
            gameOverScoreLabel.fontSize = 36
            gameOverScoreLabel.zPosition = 1
            
            gameOverScoreInstructions.fontName = "Helvetica"
            gameOverScoreInstructions.fontSize = 36
            gameOverScoreInstructions.zPosition = 1
            
            gameOverLabel.text = "Game Over!"
            gameOverScoreLabel.text = "You scored \(score)."
            gameOverScoreInstructions.text = "Tap to play again."
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 80)
            gameOverScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 20)
            gameOverScoreInstructions.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 60)
            
            UserDefaults.standard.set(score, forKey: "LATESTSCORE")
            
            if score > highScore {
                
                saveHighScore()
                
                highScoreLabel.fontSize = 26
                
                highScoreLabel.text = "Your new high score is \(score)!"
            
                
            } else {
                
                highScoreLabel.text = "High score is \(highScore)."
                
            }
            
            if gameOverLabel.parent == nil && highScoreLabel.parent == nil{
                self.addChild(gameOverLabel)
                self.addChild(gameOverScoreLabel)
                self.addChild(highScoreLabel)
                self.addChild(gameOverScoreInstructions)
            }
            
            if score == 11 || score == 21 || score == 31 {
                
                self.run(SKAction.repeatForever(createForever), withKey: "createForever")

            }
            
        }
        
        if (firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 4 ) { // FIXME: THIS DOESN'T SEEM TO BE WORKING
            // if line hit game over test
            print("removing line")
            contact.bodyA.node?.removeFromParent()
        }
        
        if (firstBody.categoryBitMask == 4 && secondBody.categoryBitMask == 16 ) {
            // if gap hit game over test
            print("removing gap")
            contact.bodyB.node?.removeFromParent()
        }

        if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 16) {
            // if ball hit gap
            
            if gameOver == false {
                score += 1
                scoreLabel.text = String(score)
            }
            
            switch score {
                
            // MAKE THE GAME HARDER AS SCORE INCREASES
                
            case 0...10:
                gapWidth = 48
                halfGap = gapWidth / 2
                wait = SKAction.wait(forDuration: 0.7)
            case 11...20:
                gapWidth = 46
                halfGap = gapWidth / 2
                wait = SKAction.wait(forDuration: 0.7, withRange: 0.1)
            case 21...30:
                gapWidth = 44
                halfGap = gapWidth / 2
                wait = SKAction.wait(forDuration: 0.6, withRange: 0.1)
            case 31...1000:
                gapWidth = 42
                halfGap = gapWidth / 2
                wait = SKAction.wait(forDuration: 0.5, withRange: 0.1)
            default:
                gapWidth = 48
                halfGap = gapWidth / 2
                
            }
            
        }
        
    }
    
    func moveBallLeft() {
        ball.isPaused = false
        ball.physicsBody!.applyImpulse(CGVector(dx: -1, dy: 0))
        
    }
    
    func moveBallRight() {
        ball.isPaused = false
        ball.physicsBody!.applyImpulse(CGVector(dx: 1, dy: 0))
    }
    
    func stopBall() {
        ball.isPaused = true
    }
    
    func restartGame() {
        if gameOver == true {
            self.removeAllActions()
            self.removeAllChildren()
            
            setUpGame()
        
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    

func saveHighScore() {
    UserDefaults.standard.set(score, forKey: "HIGHSCORE")
}

}
