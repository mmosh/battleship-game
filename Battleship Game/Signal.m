//
//  Signal.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Signal.h"

@implementation Signal
- (void) SetSignal: (enum State)s : (NSMutableArray*)p
{
    positions = [[NSMutableArray alloc]init];
    notification = [[NSMutableString alloc] init];
    status = s;
    positions = p;
    [self initialize];
}
- (void) SetSignal: (enum State)s : (NSMutableArray*)p : (NSMutableString*)n
{
    positions = [[NSMutableArray alloc]init];
    notification = [[NSMutableString alloc] init];
    status = s;
    positions = p;
    notification = n;
    [self initialize];
}
- (void) initialize
{
    if (status == EXPLORED)
        [notification appendString:@"THIS POINT'S BEEN EXPLORED, TRY OTHERS"];
    else if (status == GOTHIT)
        [notification appendString:@"IT'S A HIT"];
}
- (NSMutableString*) GetMessage
{
    return notification;
}
- (enum State) GetState
{
    return status;
}
- (NSMutableArray*) GetPositions
{
    return positions;
}
- (void) Notify
{
    NSLog(@"%@",notification);
}
@end
