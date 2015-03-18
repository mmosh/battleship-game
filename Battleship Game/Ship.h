//
//  Ship.h
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

//enum ShipType{DESTROYER,BATTLESHIP};
@interface Ship : NSObject
{
    NSString *name;
    NSMutableArray *body;
}

- (void) SetShip: (NSMutableArray*) subset;
- (NSMutableArray*) GetBody;
- (NSString*) GetShipType;
@end