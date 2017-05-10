//
//  CharacterSelectionController.swift
//  ARGame
//
//  Created by James Rogers on 07/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

import GLKit
import OpenGLES

class CharacterSelectionController: GLKViewController
{

    var context: EAGLContext? = nil
    
    let scene: Scene = CharacterSelectionScene()
    
    // Gestures
    
    
    deinit
    {
        //self.tearDownGL()
        
        if EAGLContext.current() === self.context
        {
            EAGLContext.setCurrent(nil)
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES3)
        
        if !(self.context != nil)
        {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        self.setupGL()
        
        
        // Set up the asyncronous texture loader
        TexturePool.initaliseAsyncTextureLoader(sharegroup: (self.context?.sharegroup)!)
        
        // Initalise the scene from xml file
        self.scene.initalise(xml: "character-selection")
        
        // Set up projection and pose matrices
        let aspect = fabsf(Float(self.view.bounds.size.width / self.view.bounds.size.height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 1000.0)
        let poseMatrix = GLKMatrix4MakeLookAt(0.0, 50.0, 100.0,   // Camera Position
                                              0.0, 50.0, 0.0,      // Lookat Position
                                              0.0, 1.0, 0.0)      // Up
        
        // Give the matrices to the shaders
        if self.scene.effectMaterial != nil
        {
            self.scene.effectMaterial?.setProjection(projectionMatrix)
            self.scene.effectMaterial?.setView(poseMatrix)
        }
        
        if self.scene.effectMaterialAnimated != nil
        {
            self.scene.effectMaterialAnimated?.setProjection(projectionMatrix)
            self.scene.effectMaterialAnimated?.setView(poseMatrix)
        }
        
        // Start the animation
        if let entity = self.scene.getEntityAnimated("beta")
        {
            if !entity.glModel.animationController.isPlaying
            {
                if let animation = self.scene.getAnimation("beta_breathing_idle")
                {
                    entity.glModel.animationController.loop(("beta_breathing_idle", animation))
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? FightGameController {
            
            // Initalise the fight game view controller opengl context and pass the sharegroup to it
            destinationViewController.context = EAGLContext(api: .openGLES3, sharegroup: self.context?.sharegroup)
            destinationViewController.sharingShareGroup = true
            
            // Initalise the fight game view controller scene with the scene in this file
            destinationViewController.scene.initalise(scene: self.scene)
            
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil)
        {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context
            {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
            
            self.scene.destroyScene()
        }
    }
    
    func setupGL()
    {
        // Set current GL context
        EAGLContext.setCurrent(self.context)
        
        // Allow depth testing
        glEnable(GLenum(GL_DEPTH_TEST))
    }
    
    func tearDownGL()
    {
        EAGLContext.setCurrent(self.context)
        
        self.scene.destroyScene()
    }
    
    // Update view in here
    func update()
    {
        self.scene.updateScene()
        self.scene.updateAnimations()
        
        
    }
    
    // Draw OpenGL content here
    override func glkView(_ view: GLKView, drawIn rect: CGRect)
    {
        glClearColor(1.0, 1.0, 1.0, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        // Draw the object
        self.scene.render()
        
    }
    
    func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer)
    {
        
        let child = self.scene as! CharacterSelectionScene
            
        switch gesture.direction
        {
        case UISwipeGestureRecognizerDirection.right:
            child.previousCharacter()
            break
        case UISwipeGestureRecognizerDirection.left:
            child.nextCharacter()
            break
        default:
            break
        }
    }

}
