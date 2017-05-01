//
//  Scene.swift
//  ARGame
//
//  Created by James Rogers on 07/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class Scene
{
    internal var effectMaterial: EffectMaterial?
    internal var effectMaterialAnimated: EffectMatAnim?
    
    private(set) var entitesStatic: [String: EntityStatic] = [String: EntityStatic]()
    private(set) var entitesAnimated: [String: EntityAnimated] = [String: EntityAnimated]()
    private(set) var animations: [String: Animation] = [String: Animation]()
    
    private func initaliseScene() {}
    
    public func destroyScene()
    {
        // Destroy the static entities
        for (_, entity) in self.entitesStatic
        {
            entity.glModel.destroy()
        }
        
        // Destroy the animated entites
        for (_, entity) in self.entitesAnimated
        {
            entity.glModel.destroy()
        }
        
        // Destroy effects
        if self.effectMaterial != nil
        {
            self.effectMaterial?.destroy()
        }
        
        if self.effectMaterialAnimated != nil
        {
            self.effectMaterialAnimated?.destroy()
        }
    }
    
    public func addEntityStatic(_ entity:(String, EntityStatic)) -> Bool
    {
        if (self.entitesStatic[entity.0] != nil)
        {
            return false
        }
        
        self.entitesStatic[entity.0] = entity.1
        return true
    }
    
    public func addEntityAnimated(_ entity:(String, EntityAnimated)) -> Bool
    {
        if (self.entitesAnimated[entity.0] != nil)
        {
            return false
        }
        
        self.entitesAnimated[entity.0] = entity.1
        return true
    }
    
    public func addAnimation(_ animation:(String, Animation)) -> Bool
    {
        if (self.animations[animation.0] != nil)
        {
            return false
        }
        
        self.animations[animation.0] = animation.1
        return true
    }
    
    public func getEntityStatic(_ name: String) -> EntityStatic?
    {
        return self.entitesStatic[name]
    }
    
    public func getEntityAnimated(_ name: String) -> EntityAnimated?
    {
        return self.entitesAnimated[name]
    }
    
    public func getAnimation(_ name: String) -> Animation?
    {
        return self.animations[name]
    }
    
    public func isEntityAnimatedExist(_ name: String) -> Bool
    {
        return self.entitesAnimated[name] != nil
    }
    
    public func isEntityStaticExist(_ name: String) -> Bool
    {
        return self.entitesStatic[name] != nil
    }
    
    public func isAnimationExist(_ name: String) -> Bool
    {
        return self.animations[name] != nil
    }
    
    public func render()
    {
    
        // Draw the static entites
        if self.effectMaterial != nil
        {
            for (_, entity) in self.entitesStatic
            {
                self.effectMaterial?.setModel(entity.model)
                entity.glModel.draw(self.effectMaterial!)
            }
        }
    
        // Draw the animated entites
        if self.effectMaterialAnimated != nil
        {
            for (_, entity) in self.entitesAnimated
            {
                self.effectMaterialAnimated?.setModel(entity.model)
                entity.glModel.draw(self.effectMaterialAnimated!)
            }
        }
    }
    
    public func updateAnimations()
    {
        // Animate the entites
        for (_, entity) in self.entitesAnimated
        {
            // If the animation is playing, update it
            if entity.glModel.animationController.isPlaying
            {
                if let animation = self.getAnimation(entity.glModel.animationController.animation)
                {
                    let frame = entity.glModel.animationController.frame
                    if frame >= 0
                    {
                        entity.glModel.animate(animation, frame)
                    }
                }
            }
        }
    }
}
