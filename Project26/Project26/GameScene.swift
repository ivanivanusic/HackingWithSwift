//
//  GameScene.swift
//  Project26
//
//  Created by Ivan Ivanušić on 01/10/2020.
//

import CoreMotion
import SpriteKit

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var levelNum = 3
    var startPosition = CGPoint(x: 96, y: 672)
    
    override func didMove(to view: SKView) {
        loadLevel()
        createPlayer(position: startPosition)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func loadLevel() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        background.name = "background"
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        scoreLabel.name = "score"
        addChild(scoreLabel)
        
        guard let levelURL = Bundle.main.url(forResource: "level\(levelNum)", withExtension: ".txt") else {
            fatalError("Could not find level\(levelNum).txt in the app bundle.")
        }
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find level\(levelNum).txt in the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                if letter == "x" {
                    // Load a wall
                    let node = SKSpriteNode(imageNamed: "block")
                    node.position = position
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
                    node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
                    node.physicsBody?.isDynamic = false
                    addChild(node)
                } else if letter == "v" {
                    // Load a vortex
                    createNode(for: "vortex", type: CollisionTypes.vortex, position: position)
                } else if letter == "s" {
                    // Load a star
                    createNode(for: "star", type: CollisionTypes.star, position: position)
                } else if letter == "f" {
                    // Load a finish point
                    createNode(for: "finish", type: CollisionTypes.finish, position: position)
                } else if letter == "t" {
                    // Load a teleport point
                    createNode(for: "teleport", type: CollisionTypes.teleport, position: position)
                } else if letter == " " {
                    // This is the empty spave, do nothing!
                } else {
                    fatalError("Unknown level letter: \(letter)")
                }
            }
        }
    }
    
    func createNode(for name: String, type: CollisionTypes, position: CGPoint) {
        let node = SKSpriteNode(imageNamed: name)
        node.name = name
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.categoryBitMask = type.rawValue
        node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
        node.physicsBody?.collisionBitMask = 0
        node.position = position
        
        if name == "vortex" {
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
        }
        
        addChild(node)
    }
    
    func createPlayer(position: CGPoint) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard isGameOver == false else { return }
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) {
                [weak self] in
                self?.createPlayer(position: self!.startPosition)
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            player.removeFromParent()
            levelNum += 1
            score = 0
            removeAllChildren()
            loadLevel()
            createPlayer(position: startPosition)
            physicsWorld.gravity = .zero
            physicsWorld.contactDelegate = self
            motionManager = CMMotionManager()
            motionManager?.startAccelerometerUpdates()
        } else if node.name == "teleport" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            let size = player.size.height
            let sequence = SKAction.sequence([move, scale, remove])
            player.run(sequence) {
                [weak self, node, size] in
                for nodeT in self!.children {
                    if nodeT.name == "teleport" {
                        if nodeT.position != node.position {
                            let point = CGPoint(x: nodeT.position.x, y: nodeT.position.y + size*2)
                            self?.createPlayer(position: point)
                        }
                    }
                }
                self?.isGameOver = false
            }
        }
    }
}
