//
//  GameScene.swift
//  ZombieConga
//
//  Created by tkit on 9/26/16.
//  Copyright (c) 2016 Tang Kit. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let playableRect: CGRect
    
    var lastTouchLocation: CGPoint?;
    
    let zombie = SKSpriteNode(imageNamed: "zombie1");
    
    var lastUpdateTime: NSTimeInterval = 0;
    var dt: NSTimeInterval = 0;
    
    let zombieMovePointsPerSec: CGFloat = 480.0;
    var velocity = CGPoint.zero;

    override init(size: CGSize) {
        let maxAspectRatio:CGFloat = 16.0/9.0;
        let playableHeight = size.width / maxAspectRatio;
        let playableMargin = (size.height - playableHeight)/2.0;
        playableRect = CGRect(x: 0, y: playableMargin, width: size.width, height: playableHeight);
        super.init(size: size);
    }

    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented");
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(imageNamed: "background1");
        background.position = CGPoint(x: size.width / 2, y: size.height / 2);
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        background.zPosition = -1;
        addChild(background)
        
        zombie.position = CGPoint(x: 400, y: 400);
        addChild(zombie);
        
        debugDrawPlayableArea();
    }
    
    func moveZombieToward(location: CGPoint) {
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y);
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y));
        let direction = CGPoint(x: offset.x / CGFloat(length), y: offset.y / CGFloat(length));
        
        print("Direction is \(direction)");
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSec, y: direction.y * zombieMovePointsPerSec);
        print("Velocity is \(velocity)");
    }

    func moveSprite(sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt));
        print("Amount to move: \(amountToMove)");
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y);
    }
    
    func boundsCheckZombie(){
        let bottomLeft = CGPoint(x: 0, y: CGRectGetMinY(playableRect));
        let topRight = CGPoint(x: size.width, y: CGRectGetMaxY(playableRect));
    
        if zombie.position.x <= bottomLeft.x{
            zombie.position.x = bottomLeft.x;
            velocity.x = -velocity.x;
        }
        if zombie.position.x >= topRight.x{
            zombie.position.x = topRight.x;
            velocity.x = -velocity.x;
        }
        if zombie.position.y <= bottomLeft.y{
            zombie.position.y = bottomLeft.y;
            velocity.y = -velocity.y;
        }
        if zombie.position.y >= topRight.y{
            zombie.position.y = topRight.y;
            velocity.y = -velocity.y;
        }

    }
    
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime;
        } else {
            dt = 0;
        }
        lastUpdateTime = currentTime;
        print("\(dt*1000) millseconds since last update");
//        moveSprite(zombie, velocity: CGPoint(x: zombieMovePointsPerSec, y: 0));
        
        if let lastTouchLocation = lastTouchLocation {
                let diff = lastTouchLocation - zombie.position
            if (diff.length() <= zombieMovePointsPerSec * CGFloat(dt)) {
                zombie.position = lastTouchLocation;
                velocity = CGPointZero;
            } else {
                moveSprite(zombie, velocity: velocity)
                rotateSprite(zombie, direction: velocity)
            }
        }
        
        boundsCheckZombie();
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self);
        lastTouchLocation = touchLocation;
        moveZombieToward(touchLocation);
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.locationInNode(self);
        lastTouchLocation = touchLocation;
        moveZombieToward(touchLocation);
    }
    
    func rotateSprite(sprite: SKSpriteNode, direction: CGPoint) {
        sprite.zRotation = direction.angle
    }
    
    func debugDrawPlayableArea(){
        let shape = SKShapeNode();
        let path = CGPathCreateMutable();
        CGPathAddRect(path, nil, playableRect);
        shape.path = path;
        shape.strokeColor = SKColor.redColor();
        shape.lineWidth = 4.0;
        addChild(shape);
    }
}

