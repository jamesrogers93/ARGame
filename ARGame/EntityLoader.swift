//
//  EntityLoader.swift
//  ARGame
//
//  Created by James Rogers on 28/04/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class EntityLoader : NSObject, XMLParserDelegate
{
    private var entityName:String = ""
    private var entityType:String = ""
    private var modelName:String = ""
    private var modelType:String = ""
    private var entityTranslation: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    private var entityScale: GLKVector3 = GLKVector3Make(0.0, 0.0, 0.0)
    private var entityRotation: GLKVector4 = GLKVector4Make(0.0, 0.0, 0.0, 0.0)
    
    private var success = true
    
    override init()
    {
        
    }
    
    public func loadEntityFromFile(_ resource: String, _ scene:Scene) -> Bool
    {
        var status: Bool = false
        
        // Find path of resource
        let path = Bundle.main.path(forResource: resource.lowercased(), ofType: "xml")
        var parser: XMLParser?
        
        if path != nil
        {
            parser = XMLParser(contentsOf: URL(fileURLWithPath: path!))
        }
        else
        {
            NSLog("Failed to find \(resource).xml")
        }
        
        if parser != nil {
            
            parser!.delegate = self
            parser!.parse()
            
            if self.success
            {
                switch(self.entityType)
                {
                case "static":
                    
                    // If the entity does not exist
                    if !scene.isEntityStaticExist(self.entityName)
                    {
                        let entity = (self.entityName,
                                      EntityStatic(ModelLoader.loadStaticModelFromFile(self.modelName,
                                                                                       self.modelType)))
                        entity.1.translate(self.entityTranslation)
                        entity.1.scale(self.entityScale)
                        if self.entityRotation[3] != 0.0
                        {
                            entity.1.rotate(self.entityRotation[3],
                                            GLKVector3Make(self.entityRotation[0],
                                                           self.entityRotation[1],
                                                           self.entityRotation[2]))
                        }
                        
                        if !scene.addEntityStatic(entity)
                        {
                            print("Could not add Entity: \(entity.0) to scene")
                        }
                        else
                        {
                            status = true
                        }
                    }
                    break
                    
                case "animated":
                    
                    // If the entity does not exist
                    if !scene.isEntityAnimatedExist(self.entityName)
                    {
                        let entity = (self.entityName,
                                      EntityAnimated(ModelLoader.loadAnimatedModelFromFile(self.modelName,
                                                                                           self.modelType)))
                        
                        entity.1.translate(self.entityTranslation)
                        entity.1.scale(self.entityScale)
                        if self.entityRotation[3] != 0.0
                        {
                            entity.1.rotate(self.entityRotation[3],
                                            GLKVector3Make(self.entityRotation[0],
                                                           self.entityRotation[1],
                                                           self.entityRotation[2]))
                        }
                        
                        if !scene.addEntityAnimated(entity)
                        {
                            print("Could not add Entity: \(entity.0) to scene")
                        }
                        else
                        {
                            status = true
                        }
                    }
                    
                    break
                    
                default:
                    
                    break
                }
            }
        }
        
        return status
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {

        switch(elementName.lowercased())
        {
        case "entity":
            self.processEntity(attributeDict)
            break
        case "model":
            self.processModel(attributeDict)
            break
        case "translation":
            self.processVector3(&self.entityTranslation, attributeDict)
            break
        case "scale":
            self.processVector3(&self.entityScale, attributeDict)
            break
        case "rotation":
            self.processVector4(&self.entityRotation, attributeDict)
            break
        default:
            self.success = false
            break
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        
    }
    
    private func processEntity(_ attributeDict: [String : String])
    {
        if let name = attributeDict["name"]
        {
            if let type = attributeDict["type"]
            {
                self.entityName = name.lowercased()
                self.entityType = type.lowercased()
                return
            }
        }
        
        self.success = false
    }
    
    private func processModel(_ attributeDict: [String : String])
    {
        if let name = attributeDict["name"]
        {
            if let type = attributeDict["type"]
            {
                self.modelName = name.lowercased()
                self.modelType = type.lowercased()
                return
            }
        }
        
        self.success = false
    }
    
    private func processVector3(_ vector: inout GLKVector3, _ attributeDict: [String : String])
    {
        if let x = attributeDict["x"]
        {
            if let y = attributeDict["y"]
            {
                if let z = attributeDict["z"]
                {
                    let xx: Float = Float(x)!
                    let yy: Float = Float(y)!
                    let zz: Float = Float(z)!
                    vector = GLKVector3Make(xx, yy, zz)
                    return
                }
            }
        }
        
        self.success = false
    }
    
    private func processVector4(_ vector: inout GLKVector4, _ attributeDict: [String : String])
    {
        if let x = attributeDict["x"]
        {
            if let y = attributeDict["y"]
            {
                if let z = attributeDict["z"]
                {
                    if let w = attributeDict["w"]
                    {
                        let xx: Float = Float(x)!
                        let yy: Float = Float(y)!
                        let zz: Float = Float(z)!
                        let ww: Float = Float(w)!
                        vector = GLKVector4Make(xx, yy, zz, ww)
                        return
                    }
                }
            }
        }
        
        self.success = false
    }
}
