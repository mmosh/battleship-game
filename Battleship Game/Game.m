//
//  Game.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Game.h"

@implementation Game
-(void) SetGame
{
    player = [[User alloc] init];
    [player SetUser:@"PLAYER"];
    enemy = [[AI alloc] init];
    [enemy SetUser:@"ENEMY"];
    [player AddAshipRandomly:4];
    [player AddAshipRandomly:4];
    [player AddAshipRandomly:5];
    [enemy AddAshipRandomly:4];
    [enemy AddAshipRandomly:4];
    [enemy AddAshipRandomly:5];
    playerturn = true;
}
-(int)EnemyCheckships
{
    return [enemy CheckShips];
}
-(void) SetTurn: (bool)b
{
    playerturn = b;
}
-(bool) GetTurn
{
    return playerturn;
}
-(bool) GameResult
{
    if ([enemy CheckShips]>[player CheckShips])
        return false;
    else
        return true;
}
-(NSMutableArray*) GetGrids
{
    NSMutableArray *theboard = [[NSMutableArray alloc] init];
    [theboard addObjectsFromArray:[enemy GetPresentation]];
    [theboard addObjectsFromArray:[player GetPresentation]];
    return theboard;
}
-(Signal*) PlayerAttack: (int)i
{
    int row = i / 10;
    int col = i % 10;
    Signal *response = [enemy SetPosition:col :row];
    return response;
}
-(Signal*) EnemyAttack
{
    NSMutableArray *target = [[NSMutableArray alloc] init];
    target= [enemy Command];
    Signal *response = [[Signal alloc] init];
    response = [player SetPosition:(int)[[target objectAtIndex:0] integerValue] :(int)[[target objectAtIndex:1] integerValue]];
    [enemy Record:response];
    return response;
}
-(bool) GameOn
{
    if([player CheckShips]>0 && [enemy CheckShips]>0)
        return true;
    else
        return false;
}
@end
