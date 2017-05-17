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

class FightGameController: GLKViewController
{
    
    var context: EAGLContext? = nil
    
    // Indicates if context was create
    var sharingShareGroup: Bool = false
    
    let scene: FightGameScene = FightGameScene()
    
    var arHandler: ARHandler = ARHandler()
    
    @IBOutlet weak var playerHealthBar: UIProgressView!
    @IBOutlet weak var enemyHealthBar: UIProgressView!
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var endMessage: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    
    deinit
    {
        
        
        self.tearDownGL()
        
        if EAGLContext.current() === self.context
        {
            EAGLContext.setCurrent(nil)
        }
        
        self.arHandler.stop()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.context == nil
        {
            self.context = EAGLContext(api: .openGLES3)
        }
        
        if !(self.context != nil)
        {
            print("Failed to create ES context")
        }
        
        let view = self.view as! GLKView
        view.context = self.context!
        view.drawableDepthFormat = .format24
        
        self.setupHealthBar()
        
        self.setupGL()
        
        glFlush()

        //self.scene.initaliseScene()
        //self.scene.initalise(xml: "character-selection")
        
        self.scene.setupGame()
        
        // Initalise the AR handler
        self.arHandler.onViewLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        self.presentedViewController?.dismiss(animated: false, completion: nil)
        
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
        
        /*if self.isViewLoaded && (self.view.window != nil)
        {
            self.view = nil
            
            self.tearDownGL()
            
            if EAGLContext.current() === self.context
            {
                EAGLContext.setCurrent(nil)
            }
            self.context = nil
            
        }*/
    }
    
    func setupHealthBar()
    {
        let transform: CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        
        self.playerHealthBar.setProgress(0.0, animated: false)
        self.enemyHealthBar.setProgress(0.0, animated: false)
        
        self.playerHealthBar.transform = transform
        self.enemyHealthBar.transform = transform
    }
    
    func setupGL()
    {
        // Set current GL context
        EAGLContext.setCurrent(self.context)
        
        // Allow depth testing
        glEnable(GLenum(GL_DEPTH_TEST))
        
        if sharingShareGroup
        {
            // Update the VAOs of the objects as VAOs are not shared between contexts
            for (_, entity) in self.scene.entitesStatic
            {
                entity.glModel.updateModelVAO()
            }
        
            for (_, entity) in self.scene.entitesAnimated
            {
                entity.glModel.updateModelVAO()
            }
        }
    }
    
    func tearDownGL()
    {
        EAGLContext.setCurrent(self.context)
        
        self.scene.destroyScene()
    }
    
    // Update view in here
    func update()
    {
        
        // If the game is over, blur the screen
        if self.scene.gameOver
        {
            UIView.animate(withDuration: 0.5)
            {
                self.blurEffect.alpha = 1.0
            }
            
            self.continueButton.isHidden = false
            self.endMessage.isHidden = false
            
            if self.scene.player.hasWon
            {
                self.endMessage.text = "You Won"
            }
            else
            {
                self.endMessage.text = "You Lose"
            }
        }
        
        if self.arHandler.running
        {
            // Update the health bar
            let playerHealth = self.scene.player.startHealth - self.scene.player.health
            if playerHealth > 0
            {
                self.playerHealthBar.setProgress(Float(playerHealth) / Float(self.scene.player.startHealth), animated: true)
            }
            let enemyHealth = self.scene.enemy.startHealth - self.scene.enemy.health
            if enemyHealth > 0
            {
                self.enemyHealthBar.setProgress(Float(enemyHealth) / Float(self.scene.enemy.startHealth), animated: true)
            }
            
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
            
            self.scene.updateScene(delta: self.timeSinceLastUpdate)
            self.scene.updateAnimations()
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
    
    
    @IBAction func moveLeftButtonDown(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.activateMoveLeft()
        }
    }
    
    @IBAction func moveLeftButtonUp(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.deactivateMoveLeft()
        }
    }
    
    @IBAction func moveRightButtonDown(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.activateMoveRight()
        }
    }
    
    @IBAction func moveRightButtonUp(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.deactivateMoveRight()
        }
    }

    @IBAction func punchButton(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.punch()
        }
    }
    
    @IBAction func kickButton(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.kick()
        }
    }
    
    @IBAction func blockButton(_ sender: UIButton)
    {
        if !self.scene.gameOver
        {
            self.scene.player.block()
        }
    }
    
    @IBAction func moveLeftButtonDoubleTap(_ sender: UIButton, _ event: UIEvent)
    {
        if !self.scene.gameOver
        {
            let t: UITouch = event.allTouches!.first!
            if t.tapCount == 2
            {
                self.scene.player.activateDashLeft()
            }
    
        }
    }
    
    @IBAction func moveRightButtonDoubleTap(_ sender: UIButton, _ event: UIEvent)
    {
        if !self.scene.gameOver
        {
            let t: UITouch = event.allTouches!.first!
            if t.tapCount == 2
            {
                self.scene.player.activateDashRight()
            }
        }
    }
    
    @IBAction func destroyController(_ sender: UIButton, _ event: UIEvent)
    {
        self.tearDownGL()
        
        if EAGLContext.current() === self.context
        {
            EAGLContext.setCurrent(nil)
        }
        
        self.arHandler.stop()
        
        //self.dismiss(animated: false, completion: nil)
        //self.dismiss(animated: false, completion: nil)
        
        let presentingViewController = self.presentingViewController
        self.dismiss(animated: false, completion: {
            presentingViewController!.dismiss(animated: true, completion: {})
        })
        
        //self.dismiss(animated: true, completion: nil)
        //var presentingViewController2: UIViewController! = self.presentedViewController
        
        //self.dismiss(animated: false) {

        //    presentingViewController2?.dismiss(animated: false, completion: nil)
        //}
    }
}
