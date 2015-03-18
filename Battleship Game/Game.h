//
//  Game.h
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import "AI.h"

@interface Game : NSObject
{
    User *player;
    AI *enemy;
    bool playerturn;
}

-(void) SetGame;
-(void) SetTurn: (bool)b;
-(bool) GetTurn;
-(NSMutableArray*) GetGrids;
-(Signal*) PlayerAttack: (int)i;
-(Signal*) EnemyAttack;
-(bool) GameOn;
-(bool) GameResult;
-(int) EnemyCheckships;
@end
