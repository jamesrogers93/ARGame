//
//  SceneLoader.swift
//  ARGame
//
//  Created by James Rogers on 07/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class SceneLoader : NSObject, XMLParserDelegate
{
    private var scene: Scene? = nil
    private var entityLoader: EntityLoader = EntityLoader()
    
    private var entitesToParse: [(String, String)] = [(String, String)]()
    private var animationsToParse: [(String,String)] = [(String, String)]()
    private var success = true
    
    override init()
    {
        
    }
    
    public func loadSceneFromFile(_ resource: String, _ scene:Scene) -> Bool
    {
        var status: Bool = false
        self.scene = scene
        
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
                // Now parse all entites and animations found
                // This is because only one xml parser can run at a time, preventing us from loading these entites and animations while parsing the scene xml file
                for i in 0..<self.entitesToParse.count
                {
                    if(!self.entityLoader.loadEntityFromFile(entitesToParse[i].1, self.scene!))
                    {
                        self.success = false
                    }
                }
                
                for i in 0..<self.animationsToParse.count
                {
                    let animation = (animationsToParse[i].0, AnimationLoader.loadAnimationFromFile(animationsToParse[i].1, "bvh")!)
                    if !(self.scene?.addAnimation(animation))!
                    {
                        self.success = false
                    }
                }
                
                status = true
            }
            else
            {
                status = false
            }
        }
        
        return status
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        
        switch(elementName.lowercased())
        {
        case "scene":
            break
        case "entities":
            break
        case "animations":
            break
        case "entity":
            self.processEntity(attributeDict)
            break
        case "animation":
            self.processAnimation(attributeDict)
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
            if let file = attributeDict["file"]
            {
                self.entitesToParse.append((name,file))
                return
            }
        }
        self.success = false
    }

    private func processAnimation(_ attributeDict: [String : String])
    {
        if let name = attributeDict["name"]
        {
            if let file = attributeDict["file"]
            {
                self.animationsToParse.append((name, file))
                return
            }
        }
        self.success = false
    }

}
