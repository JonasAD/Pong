
import SpriteKit

class GameScene: SKScene {
    
    let player1 = SKSpriteNode(imageNamed: "rectangle_red")
    let player2 = SKSpriteNode(imageNamed: "rectangle_blue")
    
    override func didMoveToView(view: SKView) {
        /* Scene setup */
        backgroundColor = SKColor.blackColor()
        
        /* Player 1 */
        player1.name = "sprite"
        player1.setScale(0.1)
        player1.position = CGPoint(x: size.width/2, y: size.height*0.1)
        addChild(player1)
        
        /* Player 2 */
        player2.name = "sprite"
        player2.setScale(0.1)
        player2.position = CGPoint(x: size.width/2, y: size.height*0.5)
        addChild(player2)
    }
    

    /* Dictonary for determing which node is selected */
    var selectedNodes:[UITouch:SKSpriteNode] = [UITouch:SKSpriteNode]()
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch:AnyObject in touches {
            let location = touch.locationInNode(self)
            let node:SKSpriteNode? = self.nodeAtPoint(location) as? SKSpriteNode
            // Add the selected node to dictionary "selectedNodes"
            if (node?.name == "sprite") {
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
