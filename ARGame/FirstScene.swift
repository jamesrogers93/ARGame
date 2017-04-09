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
        
        let entity = ("player1", EntityAnimated(ModelLoader.loadAnimatedModelFromFile("beta", "fbx")))
        //entity.translate(GLKVector3Make(0.0, 0.0, -100.0))
        if !super.addEntityAnimated(entity)
        {
            print("Could not add Entity: \(entity.0) to scene")
        }
        
        let animation1 = ("beta_breathing_idle", AnimationLoader.loadAnimationFromFile("beta_breathing_idle", "fbx")!)
        if !super.addAnimation(animation1)
        {
            print("Could not add Animation: \(animation1.0) to scene")
        }
        
        let animation2 = ("beta_warming_up", AnimationLoader.loadAnimationFromFile("beta_warming_up", "fbx")!)
        if !super.addAnimation(animation2)
        {
            print("Could not add Animation: \(animation2.0) to scene")
        }
        
        let animation3 = ("beta_elbow_punch", AnimationLoader.loadAnimationFromFile("beta_elbow_punch", "fbx")!)
        if !super.addAnimation(animation3)
        {
            print("Could not add Animation: \(animation3.0) to scene")
        }
        
        entity.1.glModel.animationController.play(animation2)
        
        
        /*let entity1 = ("player2", EntityAnimated(ModelLoader.loadAnimatedModelFromFile("maria", "fbx")))
        //entity1.1.rotate(-1.5, GLKVector3Make(1.0, 0.0, 0.0))
        if !super.addEntityAnimated(entity1)
        {
            print("Could not add Entity: \(entity1.0) to scene")
        }
        
        let animation3 = ("maria_warming_up", AnimationLoader.loadAnimationFromFile("maria_warming_up", "fbx")!)
        if !super.addAnimation(animation3)
        {
           print("Could not add Animation: \(animation3.0) to scene")
        }
        
        entity1.1.glModel.animationController.loop(animation3)*/
    }
}
