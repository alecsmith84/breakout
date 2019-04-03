//
//  GameScene.swift
//  Bamboo Breakout
/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */ 

import SpriteKit

let BallCategoryName = "ball"
let PaddleCategoryName = "paddle"
let BlockCategoryName = "block"
let GameMessageName = "gameMessage"


class GameScene: SKScene {
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    
    // 1 creates edge based body that does not have mass or volume
    let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
    // 2 friction set to 0 so that the ball is not slowed down when colliding with the border
    borderBody.friction = 0
    // 3 attach physics body to the scene
    self.physicsBody = borderBody
    
    // make it move
    // remove all gravity
    physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    // set the ball from the child nodes
    let ball = childNode(withName: BallCategoryName) as! SKSpriteNode
    ball.physicsBody!.applyImpulse(CGVector(dx: 2.0, dy: -2.0))
    
  }
    
    var isFingerOnPaddle = false
    
    // This adds a event in the console saying that you have touched the paddle to begin movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch!.location(in: self)
        
        if let body = physicsWorld.body(at: touchLocation) {
            if body.node!.name == PaddleCategoryName {
                print("Began touch on paddle")
                isFingerOnPaddle = true
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 1 are we touching
        if isFingerOnPaddle {
            // 2 update position depending on how finger is moved
            let touch = touches.first
            let touchLocation = touch!.location(in: self)
            let previousLocation = touch!.previousLocation(in: self)
            // 3 get sprite for the paddle
            let paddle = childNode(withName: PaddleCategoryName) as! SKSpriteNode
            // 4 current position and difference between new and previous
            var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
            // 5 limit position from going off the screen
            paddleX = max(paddleX, paddle.size.width/2)
            paddleX = min(paddleX, size.width - paddle.size.width/2)
            // 6 set new position as calculated
            paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
        }
    }
    // random comment
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnPaddle = false 
    }
  
  
}
