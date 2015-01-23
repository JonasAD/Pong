
import SpriteKit

struct PhysicsCategory {
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Ball         : UInt32 = 0x1 << 1
    static let TopWall      : UInt32 = 0x1 << 2
    static let ButtomWall   : UInt32 = 0x1 << 3
}

class PlayerNode: SKSpriteNode {
    var moveableByUser = true   // Node can be moved by a user
    var life = 9                // Starting with a number of lifes
    var label = SKLabelNode()   // Label for displaying lifes
    func updateLife() {         // Updates the life
        self.life -= 1
        self.label.text = String(self.life)
    }
}

class ScoreLabel: SKLabelNode {
    func update(text: String){
        self.text = text
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player1 = PlayerNode(imageNamed: "rectangle_red")
    let player2 = PlayerNode(imageNamed: "rectangle_blue")
    let ball = SKSpriteNode(imageNamed: "ball_aqua")
    
    override func didMoveToView(view: SKView) {
        /* Scene setup */
        backgroundColor = SKColor.whiteColor()
        // Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody?.friction = 0.0
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        // Contact
        self.physicsWorld.contactDelegate = self
        
        
        /* Player 1 - Buttom bar / home */
        player1.name = "moveableByUser"
        player1.setScale(0.1)
        player1.position = CGPoint(x: size.width/2, y: size.height*0.1)
        addChild(player1)
        // Physics
        player1.physicsBody = SKPhysicsBody(rectangleOfSize: player1.size)
        player1.physicsBody?.dynamic = false
        player1.physicsBody?.friction = 0.0
        player1.physicsBody?.restitution = 1.0
        
        
        /* Player 2 - Top bar / opponent */
        player2.name = "moveableByUser"
        player2.setScale(0.1)
        player2.position = CGPoint(x: size.width/2, y: size.height*0.5)
        addChild(player2)
        // Physics
        player2.physicsBody = SKPhysicsBody(rectangleOfSize: player1.size)
        player2.physicsBody?.dynamic = false
        player2.physicsBody?.friction = 0.0
        player2.physicsBody?.restitution = 1.0
        
        
        /* Ball */
        ball.setScale(0.1)
        ball.position = CGPoint(x: size.width/2, y: size.height*0.3)
        addChild(ball)
        // Physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.size.height/2)
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.restitution = 1.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.angularDamping = 0.0
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.applyForce(CGVectorMake(0.2, -0.2))
        // Contact
        ball.physicsBody!.categoryBitMask = PhysicsCategory.Ball
 
        
        
        /* Buttom */
        let buttomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let buttom = SKNode()
        addChild(buttom)
        // Physics
        buttom.physicsBody = SKPhysicsBody(edgeLoopFromRect: buttomRect)
        // Contact
        buttom.physicsBody!.categoryBitMask = PhysicsCategory.ButtomWall
        buttom.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        
        
        /* Top */
        let topRect = CGRectMake(frame.origin.x, frame.size.height, frame.size.width, 1)
        let top = SKNode()
        addChild(top)
        // Physics
        top.physicsBody = SKPhysicsBody(edgeLoopFromRect: topRect)
        // Contact
        top.physicsBody!.categoryBitMask = PhysicsCategory.TopWall
        top.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        
        /* Life-label player 1 */
        player1.label.text = String(player1.life)
        player1.label.fontColor = SKColor.redColor()
        player1.label.zRotation = CGFloat(3*M_PI/2)
        player1.label.position = CGPoint(x: size.width*0.9, y: size.height*0.45)
        addChild(player1.label)
        
        /* Life-label player 2 */
        player2.label.text = String(player2.life)
        player2.label.fontColor = SKColor.blueColor()
        player2.label.zRotation = CGFloat(3*M_PI/2)
        player2.label.position = CGPoint(x: size.width*0.9, y: size.height*0.55)
        addChild(player2.label)
        
    }
    

    /* Dictonary for determing which node is selected */
    var selectedNodes:[UITouch:SKSpriteNode] = [UITouch:SKSpriteNode]()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            let node:PlayerNode? = self.nodeAtPoint(location) as? PlayerNode
            // Add the selected node to dictionary "selectedNodes"
            if (node?.moveableByUser == true) {
                let touchObj = touch as UITouch
                selectedNodes[touchObj] = node!
            }
        }
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let xLocation = touch.locationInNode(self).x
            let touchObj = touch as UITouch
            // Update position of sprites
            if let node:SKSpriteNode? = selectedNodes[touchObj] {
                node?.runAction(SKAction.moveToX(xLocation, duration: 0))
            }
        }
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let touchObj = touch as UITouch
            // Remove selected node from dictionary "selectedNodes"
            if let exists:AnyObject? = selectedNodes[touchObj] {
                selectedNodes[touchObj] = nil
            }
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // Ball hits bottom - player 1 looses life
        if firstBody.categoryBitMask == PhysicsCategory.Ball && secondBody.categoryBitMask == PhysicsCategory.ButtomWall {
            println("Hit BOTTOM")
            player1.updateLife()
        }
        // Ball hits top - player 2 looses life
        if firstBody.categoryBitMask == PhysicsCategory.Ball && secondBody.categoryBitMask == PhysicsCategory.TopWall {
            println("Hit TOP")
            player2.updateLife()
        }
    }

    
}
