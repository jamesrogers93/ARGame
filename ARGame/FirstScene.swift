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
        
        let entity1 = ("player2", EntityAnimated(ModelLoader.loadAnimatedModelFromFile("Maria1", "fbx")))
        
        addEntityAnimated(entity1)
        
        let entity = ("player1", EntityAnimated(ModelLoader.loadAnimatedModelFromFile("Beta", "fbx")))
        
        if !super.addEntityAnimated(entity)
        {
            print("Could not add Entity: \(entity.0) to scene")
        }
        
        let animation1 = ("breathing_idle", AnimationLoader.loadAnimationFromFile("breathing_idle", "fbx")!)
        let animation2 = ("warming_up", AnimationLoader.loadAnimationFromFile("warming_up", "fbx")!)

        if !super.addAnimation(animation1)
        {
            print("Could not add Animation: \(animation1.0) to scene")
        }
        
        if !super.addAnimation(animation2)
        {
            print("Could not add Animation: \(animation2.0) to scene")
        }
        
        entity.1.glModel.animationController.play(animation1)
    }
}
