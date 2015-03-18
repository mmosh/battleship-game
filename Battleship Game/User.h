//
//  User.h
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import "Cell.h"
#import "Signal.h"
#import "Ship.h"

@interface User : NSObject
{
    NSString* Name;
    enum Cell Grid[GRID_SIZE];
    NSMutableArray* MyShips;
}

-(void) SetUser: (NSString*)n;
-(NSString*) GetName;
-(int) CheckShips;
-(void) Presentation;
-(NSMutableArray*) GetPresentation;
-(Signal*) SetPosition: (int)col : (int)row;
-(void) AddAshipRandomly: (int)length;
@end