//
//  Signal.h
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

enum State{MISSED,GOTHIT,GOTDESTROYED,EXPLORED};
@interface Signal : NSObject
{
    enum State status;
    NSMutableArray *positions;
    NSMutableString *notification;
}

- (void) SetSignal: (enum State)s : (NSMutableArray*)p;
- (void) SetSignal: (enum State)s : (NSMutableArray*)p : (NSMutableString*)n;
- (void) initialize;
- (NSMutableString*) GetMessage;
- (enum State) GetState;
- (NSMutableArray*) GetPositions;
- (void) Notify;
@end