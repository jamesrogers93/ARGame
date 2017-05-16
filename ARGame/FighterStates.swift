//
//  FighterStates.swift
//  ARGame
//
//  Created by James Rogers on 13/05/2017.
//  Copyright © 2017 James Rogers. All rights reserved.
//

import Foundation

enum FighterStates: Int
{
    case S_END = -1
    case S_COMBAT = 0
    case S_MOVETOPLAYER = 1
    case S_WIN = 2
    case S_LOSE = 3
}
