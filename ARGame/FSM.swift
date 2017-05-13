//
//  FSM.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

class FSM <Parent>
{
    private var parent: Parent
    private var states: Array<STATE<Parent>>
    private var _currentState: Int
    
    init(_ parent: Parent)
    {
        self.parent = parent
        self.states = Array<STATE<Parent>>()
        self._currentState = 0
    }
    
    public func update()
    {
        self.states[self._currentState].run(parent: self.parent)
    }
    
    public func addState(_ state: STATE<Parent>)
    {
        self.states.append(state)
    }
    
    var currentState:Int
    {
        get
        {
            return self._currentState
        }
        
        set(newVal)
        {
            if self._currentState < self.states.count && self._currentState >= 0
            {
                self._currentState = newVal
            }
            else
            {
                print("Cannot set state")
            }
        }
    }
}
