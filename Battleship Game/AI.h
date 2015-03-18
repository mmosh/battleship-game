//
//  AI.h
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import "User.h"

@interface AI : User
{
    enum Cell Map[GRID_SIZE];
    NSMutableArray *Rows;
    int HitPoint;
    int Fitsize;
    int DestroyersGone;
}

-(void) Record: (Signal*)s;
-(NSMutableArray*) Command;
-(NSMutableArray*) CheckEligibility: (int)c : (int)r;
-(NSMutableArray*) Search;
-(NSMutableArray*) Destroy;
@end
