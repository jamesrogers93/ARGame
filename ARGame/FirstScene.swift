//
//  FirstScene.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FirstScene : Scene
{
    public func initaliseScene()
    {
        super.effectMaterial = EffectMaterial()
        super.effectMaterialAnimated = EffectMatAnim()
        
        let entity = ("player1", EntityAnimated(ModelLoader.loadAnimatedModelFromFile("Beta", "fbx")))
        
        if !super.addEntityAnimated(entity)
        {
            print("Could not add Entity: \(entity.0) to scene")
        }
        
        let animation = ("breathing_idle", AnimationLoader.loadAnimationFromFile("breathing_idle", "fbx")!)

        if !super.addAnimation(animation)
        {
            print("Could not add Animation: \(animation.0) to scene")
        }
        
        let animationController = AnimationPlayBack(animation.1)
        animationController.loop()
        if !super.addAnimationController(("player1_breathing_idle", animationController))
        {
            print("Could not add AnimationController: player1_breathing_idle to scene")
        }
    }
}
