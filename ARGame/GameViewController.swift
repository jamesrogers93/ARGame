//
//  GameViewController.swift
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import GLKit
import OpenGLES

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer?
{
    return UnsafeRawPointer(bitPattern: i)
}

class GameViewController: GLKViewController
{
    
    var context: EAGLContext? = nil
    
    let scene: FirstScene = FirstScene()
    
    var arHandler: ARHandler = ARHandler()
    
    deinit
    {
        self.tearDownGL()
        
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

        self.scene.initaliseScene()
        
        // Initalise the AR handler
        self.arHandler.onViewLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        // Start the AR handler
        self.arHandler.start()
        
        //glViewport(-105, 0, 851, 1136);
        glViewport(0,0, self.arHandler.camWidth, self.arHandler.camHeight)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Stop the AR handler
        self.arHandler.stop()
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
    
    var rotation: Float = 0.0
    
    // Update view in here
    func update()
    {
        
        if self.arHandler.running
        {
            
            // Update the projection matrix and camera view
            if self.scene.effectMaterial != nil
            {
                self.scene.effectMaterial?.setProjection(self.arHandler.camProjection)
                self.scene.effectMaterial?.setView(self.arHandler.camPose)
            }
            
            if self.scene.effectMaterialAnimated != nil
            {
                self.scene.effectMaterialAnimated?.setProjection(self.arHandler.camProjection)
                self.scene.effectMaterialAnimated?.setView(self.arHandler.camPose)
            }
            
            if let entity = self.scene.getEntityAnimated("player1")
            {
                if let animation = self.scene.getAnimation(entity.glModel.animationController.animation)
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
    
    // Draw OpenGL content here
    override func glkView(_ view: GLKView, drawIn rect: CGRect)
    {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        if self.arHandler.running
        {
            self.arHandler.setViewport()
        
            // Draw the camera view
            self.arHandler.draw()
        
            // Draw the object
            self.scene.render()
        }
    }
}
