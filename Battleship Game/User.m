//
//  User.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@implementation User
-(void) SetUser: (NSString*)n
{
    Name = n;
    MyShips = [[NSMutableArray alloc]init];
}
-(NSString*) GetName
{
    return Name;
}
-(int) CheckShips
{
    return (int)MyShips.count;
}
-(void) Presentation
{
    NSMutableString *print = [[NSMutableString alloc]initWithString:@"\r"];
    for(int i=0; i<GRID_SIZE; i++)
    {
        if(i%10==0 && i>0)
        {
            [print appendString:@"\r"];
        }
        NSString *temp = [@(Grid[i]) stringValue];
        [print appendString: temp];
    }
    NSLog(@"%@",print);
}
-(NSMutableArray*) GetPresentation
{
    NSMutableArray* thegrid = [[NSMutableArray alloc]init];
    for(int i=0; i<GRID_SIZE; i++)
    {
        [thegrid addObject:[NSNumber numberWithInt:Grid[i]]];
    }
    return thegrid;
}
-(Signal*) SetPosition: (int)col : (int)row
{
    int location = (row * 10)+col;
    NSMutableArray *targeted = [[NSMutableArray alloc] init];
    [targeted addObject:[NSNumber numberWithInt:location]];
    if(Grid[location]<2)
    {
        if(Grid[location]==WATER)
        {
            Grid [location] = MISS;
            Signal *missedState= [[Signal alloc] init];
            [missedState SetSignal:MISSED :targeted];
            return missedState;
        }
        else
        {
            Grid[location] = HIT;
            for(int i =0; i<MyShips.count;i++)
            {
                Ship *thisShip = [[Ship alloc] init];
                thisShip = [MyShips objectAtIndex:i];
                NSMutableArray *parts = [thisShip GetBody];
                bool alive = false;
                for (int j =0; j<parts.count; j++)
                {
                    int segment = (int)[[parts objectAtIndex:j] integerValue];
                    if(Grid[segment]== SHIPUNIT){alive = true;}
                }
                if (!alive)
                {
                    for (int k =0; k<parts.count; k++)
                    {
                        int segment = (int)[[parts objectAtIndex:k] integerValue];
                        Grid[segment]= DESTROYED;
                    }
                    NSString *shipname = [thisShip GetShipType];
                    NSMutableString *note = [[NSMutableString alloc]initWithString:@""];
                    [note appendString: Name];
                    [note appendString: @"'s "];
                    [note appendString: shipname];
                    [note appendString: @" has sunk"];
                    targeted = parts;
                    [MyShips removeObjectAtIndex:i];
                    Signal *destroyedState= [[Signal alloc] init];
                    [destroyedState SetSignal:GOTDESTROYED :targeted:note];
                    return destroyedState;
                }
            }
            Signal *hitState= [[Signal alloc] init];
            [hitState SetSignal:GOTHIT :targeted];
            return hitState;
        }
    }
    Signal *exploredState= [[Signal alloc] init];
    [exploredState SetSignal:EXPLORED :targeted];
    return exploredState;
}
-(void) AddAshipRandomly: (int)length
{
    NSMutableArray *points = [[NSMutableArray alloc]init];
    bool eligible = false;
    while(!eligible)
    {
        eligible = true;
        int x;
        int y;
        int orientation = arc4random_uniform(100);
        int location;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        if (orientation < 50)
        {
            x = arc4random_uniform(10-(length-1));
            y = arc4random_uniform(10);
            for(int i=0; i<length; i++)
            {
                location = (y*10)+(x+i);
                [temp addObject:[NSNumber numberWithInt:location]];
                if(Grid[location] != WATER){eligible=false;break;}
            }
        }
        else
        {
            x = arc4random_uniform(10);
            y = arc4random_uniform(10-(length-1));
            for(int i=0; i<length; i++)
            {
                location = ((y+i)*10)+x;
                [temp addObject:[NSNumber numberWithInt:location]];
                if(Grid[location] != WATER){eligible=false; break;}
            }
        }
        if(eligible)
        {
            points = temp;
            for(int i=0; i<points.count; i++)
            {
                Grid[[[points objectAtIndex:i] integerValue]] = SHIPUNIT;
            }
        }
    }
    Ship *Aship = [[Ship alloc] init];
    [Aship SetShip:points];
    [MyShips addObject:Aship];
}
@end
