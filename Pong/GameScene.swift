
import SpriteKit


class GameScene: SKScene {
    
    let player1 = SKSpriteNode(imageNamed: "rectangle_red")
    let player2 = SKSpriteNode(imageNamed: "rectangle_blue")
    let ball = SKSpriteNode(imageNamed: "ball_aqua")
    
    override func didMoveToView(view: SKView) {
        /* Scene setup */
        backgroundColor = SKColor.whiteColor()
        // Physics
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody?.friction = 0.0
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        
        
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
        ball.physicsBody?.applyForce(CGVectorMake(1, -1))
        
        
        /* Buttom */
        let buttomRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 1)
        let buttom = SKNode()
        addChild(buttom)
        // Physics
        buttom.physicsBody = SKPhysicsBody(edgeLoopFromRect: buttomRect)
        
    }
    

    /* Dictonary for determing which node is selected */
    var selectedNodes:[UITouch:SKSpriteNode] = [UITouch:SKSpriteNode]()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            let node:SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
            // Add the selected node to dictionary "selectedNodes"
            if (node?.name == "moveableByUser") {
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
    
}
