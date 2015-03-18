//
//  Ship.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ship.h"

@implementation Ship
- (void) SetShip: (NSMutableArray*) subset
{
    body = [[NSMutableArray alloc]init];
    body = subset;
    if ([body count]>4) {
        name = @"Battleship";
    }
    else
    {
        name = @"Destroyer";
    }
}
- (NSMutableArray*) GetBody
{
    return body;
}
- (NSString*) GetShipType
{
    return name;
}
@end