//
//  GameViewController.swift
//  ARGame
//
//  Created by James Rogers on 16/02/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import GLKit
import OpenGLES
import AVFoundation

func BUFFER_OFFSET(_ i: Int) -> UnsafeRawPointer?
{
    return UnsafeRawPointer(bitPattern: i)
}

class GameViewController: GLKViewController {
    
    var context: EAGLContext? = nil
    var effect: GLKBaseEffect? = nil
    
    var obj: Object? = nil
    
    var cameraFeed: CameraFeed? = nil
    
    deinit
    {
        self.tearDownGL()
        
        if EAGLContext.current() === self.context {
            EAGLContext.setCurrent(nil)
        }
        
        // Stop camera
        self.cameraFeed?.stopCapture()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.context = EAGLContext(api: .openGLES2)
        
        if !(self.context != nil) {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        self.setupGL()
        
        // Create object with model
        self.obj = Object(ModelLoader.loadModelFromFile("robot"))
        
        self.cameraFeed = CameraFeed(self.context!)
        //self.cameraFeed?.setCameraFeedDelegate(delegate: self)

        // Load dummy texture and give to camerafeed
        let opt:[String : NSNumber] = [GLKTextureLoaderOriginBottomLeft : false, GLKTextureLoaderApplyPremultiplication : false]
        let url = URL(string: "https://www.qdtricks.net/wp-content/uploads/2016/05/hd-road-wallpaper.jpg")
        let tex:GLKTextureInfo?
        do
        {
            tex = try GLKTextureLoader.texture(withContentsOf: url!, options: opt) //put `try` just before the method call
            cameraFeed?.setCameraBuffer(tex!)
        } catch
        {
            tex = nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        
        if(!(self.cameraFeed?.startCapture())!)
        {
            print("Could not start camera capture")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        self.cameraFeed?.stopCapture()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        // Update the projection matrix
        self.setupProjectionMatrix(size.width, size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        if self.isViewLoaded && (self.view.window != nil) {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
        }
    }
    
    func setupGL()
    {
        // Set current GL context
        EAGLContext.setCurrent(self.context)
        
        // Set up renderer
        self.effect = GLKBaseEffect()   // Init renderer
        self.effect!.light0.enabled = GLboolean(GL_TRUE)    // Add light
        self.effect!.light0.diffuseColor = GLKVector4Make(1.0, 0.4, 0.4, 1.0)   // Set light colour
        
        // Allow depth testing
        glEnable(GLenum(GL_DEPTH_TEST))
        
        // Setup the projection matrix
        self.setupProjectionMatrix(self.view.bounds.size.width, self.view.bounds.size.height)
    }
    
    func setupProjectionMatrix(_ width:CGFloat, _ height:CGFloat)
    {
        // Set up projection matrix
        let aspect = fabsf(Float(width / height))
        let projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 0.1, 100.0)
        self.effect?.transform.projectionMatrix = projectionMatrix
    }
    
    func tearDownGL()
    {
        EAGLContext.setCurrent(self.context)
        
        // Delete renderer
        self.effect = nil
    }
    
    var rotation: Float = 0.0
    // Update view in here
    func update()
    {
        // Update ARCameraFeed
        self.obj?.translate(GLKVector3Make(0.0, 0.0, -5.5))
        self.obj?.rotate(rotation, GLKVector3Make(0.0, 1.0, 0.0))
        //self.obj?.scale(GLKVector3Make(1.5, 0.5, 1.0))
        rotation+=0.01
    }
    
    // Draw OpenGL content here
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.65, 0.65, 0.65, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))
        
        self.obj?.draw(self.effect)
        
        self.cameraFeed?.draw()
    }
}
