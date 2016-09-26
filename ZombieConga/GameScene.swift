//
//  GameScene.swift
//  ZombieConga
//
//  Created by tkit on 9/26/16.
//  Copyright (c) 2016 Tang Kit. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(imageNamed: "background1");
        background.position = CGPoint(x: size.width / 2, y: size.height / 2);
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        background.zPosition = -1;
        addChild(background)
    }
}
