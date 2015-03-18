//
//  AI.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AI.h"

@implementation AI
-(void) SetUser: (NSString*)n
{
    Rows = [[NSMutableArray alloc] init];
    for(int i=0; i<10; i++)
    {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for(int j=0; j<10; j++)
        {
            [temp addObject:[NSNumber numberWithInt:j]];
        }
        [Rows addObject:temp];
    }
    HitPoint = -1;
    Fitsize = 3;
    DestroyersGone = 0;
    [super SetUser:n];
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
        if(Grid[i] == SHIPUNIT)
            temp = [@(WATER) stringValue];
        [print appendString: temp];
    }
    NSLog(@"%@",print);
}
-(NSMutableArray*) GetPresentation
{
    NSMutableArray* thegrid = [[NSMutableArray alloc]init];
    for(int i=0; i<GRID_SIZE; i++)
    {
        if(Grid[i] == SHIPUNIT)
            [thegrid addObject:[NSNumber numberWithInt:WATER]];
        else
            [thegrid addObject:[NSNumber numberWithInt:Grid[i]]];
    }
    return thegrid;
}
-(void) Record: (Signal*)s
{
    if([s GetState]== EXPLORED)	return;
    NSMutableArray *targeted = [s GetPositions];
    for(int i=0; i<[targeted count]; i++)
    {
        Map[(int)[[targeted objectAtIndex:i] integerValue]] = (int)([s GetState]+2);
    }
    if([s GetState]==GOTHIT && HitPoint<0)
    {
        HitPoint = (int)[[[s GetPositions]objectAtIndex:0] integerValue];//s.GetPositions()[0];
    }
    else if([s GetState]==GOTDESTROYED)
    {
        [s Notify];
        HitPoint = -1;
        for(int i =0; i<GRID_SIZE;i++)
        {
            if(Map[i]==HIT){HitPoint=i;break;}
        }
        if([[s GetPositions]count]==4)DestroyersGone++;
        if(DestroyersGone==2)Fitsize++;
    }
}
-(NSMutableArray*) Command
{
    if (HitPoint>=0)	return [self Destroy];
    else 				return [self Search];
}
-(NSMutableArray*) CheckEligibility: (int)c : (int)r
{
    int horizontal = 0; int vertical = 0;
    bool h = true; bool v = true;
    for(int i=c+1; i<10;i++)
    {
        if(Map[(r*10)+i]==DESTROYED || Map[(r*10)+i]==MISS)break;
        else horizontal++;
    }
    for(int i=c-1; i>=0;i--)
    {
        if(Map[(r*10)+i]==DESTROYED || Map[(r*10)+i]==MISS)break;
        else horizontal++;
    }
    if(horizontal<Fitsize) h = false;
    for(int i=r+1; i<10;i++)
    {
        if(Map[(i*10)+c]==DESTROYED || Map[(i*10)+c]==MISS)break;
        else vertical++;
    }
    for(int i=r-1; i>=0;i--)
    {
        if(Map[(i*10)+c]==DESTROYED || Map[(i*10)+c]==MISS)break;
        else vertical++;
    }
    if(vertical<Fitsize) v = false;
    NSMutableArray *orientations = [[NSMutableArray alloc] init];
    [orientations addObject:[NSNumber numberWithBool:h]];
    [orientations addObject:[NSNumber numberWithBool:v]];
    return orientations;
}
-(NSMutableArray*) Search
{
    int largestrow = 0;
    NSMutableArray *chosenrows = [[NSMutableArray alloc] init];
    for(int i=0; i<[Rows count]; i++)
    {
        if([[Rows objectAtIndex:i] count]>largestrow)
            largestrow = (int)[[Rows objectAtIndex:i] count];
    }
    for(int i=0; i<[Rows count]; i++)
    {
        if([[Rows objectAtIndex:i] count]==largestrow)
            [chosenrows addObject:[NSNumber numberWithInt:i]];
    }
    int randomIndex = arc4random_uniform((int)[chosenrows count]);
    int r = (int)[[chosenrows objectAtIndex:randomIndex] integerValue];
    int largestcol = 0;
    NSMutableArray *colcounts = [[NSMutableArray alloc] init];
    for(int i=0; i<[[Rows objectAtIndex:r] count]; i++)
    {
        [colcounts addObject:[NSNumber numberWithInt:0]];
        int tempcol = (int)[[[Rows objectAtIndex:r] objectAtIndex:i] integerValue];
        for(int j=0; j<10; j++)
        {
            if(Map[(j*10)+tempcol] != 2)
            {
                int tempval = (int)[[colcounts objectAtIndex:([colcounts count]-1)] integerValue];
                [colcounts replaceObjectAtIndex:([colcounts count]-1) withObject:[NSNumber numberWithInt:tempval+1]];
            }
        }
        if([colcounts[[colcounts count]-1] integerValue]>largestcol)
            largestcol = (int)[colcounts[[colcounts count]-1] integerValue];
    }
    NSMutableArray *chosencols = [[NSMutableArray alloc] init];
    for(int i=0; i<colcounts.count; i++)
    {
        if([colcounts[i] integerValue]==largestcol)
            [chosencols addObject:[NSNumber numberWithInt:i]];
    }
    randomIndex = arc4random_uniform((int)[chosencols count]);
    int c1 = (int)[[chosencols objectAtIndex:randomIndex] integerValue];
    int c = (int)[[[Rows objectAtIndex:r] objectAtIndex:c1] integerValue];
    [[Rows objectAtIndex:r] removeObjectAtIndex:c1];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    temp = [self CheckEligibility:c :r];
    if (Map [(r * 10) + c] > 1)
    {
        [temp replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];
        [temp replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:false]];
    }
    if ([[temp objectAtIndex:0] boolValue]==false&&[[temp objectAtIndex:1] boolValue]==false)
    {
        return [self Search];
    }
    else
    {
        NSMutableArray *returnValue = [[NSMutableArray alloc] init];
        [returnValue addObject:[NSNumber numberWithInt:c]];
        [returnValue addObject:[NSNumber numberWithInt:r]];
        return returnValue;
    }
}
-(NSMutableArray*) Destroy
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    int c = HitPoint%10;
    int r = HitPoint/10;
    NSMutableArray *eligible = [self CheckEligibility:c :r];
    bool h = [[eligible objectAtIndex:0] boolValue];
    bool v = [[eligible objectAtIndex:1] boolValue];
    int tempcol = c;
    int temprow = r;
    
    int up = ((r+1)*10)+c;
    int down = ((r-1)*10)+c;
    int left = (r*10)+c-1;
    int right = (r*10)+c+1;
    
    NSMutableArray *u1 = [[NSMutableArray alloc] init];
    [u1 addObject:[NSNumber numberWithBool:true]];
    [u1 addObject:[NSNumber numberWithBool:false]];
    
    NSMutableArray *d1 = [[NSMutableArray alloc] init];
    [d1 addObject:[NSNumber numberWithBool:true]];
    [d1 addObject:[NSNumber numberWithBool:false]];
    
    NSMutableArray *l1 = [[NSMutableArray alloc] init];
    [l1 addObject:[NSNumber numberWithBool:true]];
    [l1 addObject:[NSNumber numberWithBool:false]];
    
    NSMutableArray *r1 = [[NSMutableArray alloc] init];
    [r1 addObject:[NSNumber numberWithBool:true]];
    [r1 addObject:[NSNumber numberWithBool:false]];
    
    if(r==9)[u1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];
    if(r==0)[d1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];
    if(c==0)[l1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];
    if(c==9)[r1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];
    
    if([[u1 objectAtIndex:0]boolValue]&&Map[up]==HIT)
        [u1 replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:true]];
    if([[d1 objectAtIndex:0] boolValue]&&Map[down]==HIT)
        [d1 replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:true]];
    if([[l1 objectAtIndex:0] boolValue]&&Map[left]==HIT)
        [l1 replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:true]];
    if([[r1 objectAtIndex:0]boolValue]&&Map[right]==HIT)
        [r1 replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:true]];
    
    int nextup=-1;
    int nextdown=-1;
    int nextleft=-1;
    int nextright=-1;
    
    while (temprow<9 && Map[(temprow*10)+tempcol]==HIT) {temprow++;}
    if (Map [(temprow * 10) + tempcol] == WATER && v) {nextup=temprow;}
    else{[u1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];}
    tempcol = c;
    temprow = r;
    while (temprow>0 && Map[(temprow*10)+tempcol]==HIT) {temprow--;}
    if (Map [(temprow * 10) + tempcol] == WATER && v) {nextdown = temprow;}
    else{[d1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];}
    tempcol = c;
    temprow = r;
    while (tempcol>0 && Map[(temprow*10)+tempcol]==HIT) {tempcol--;}
    if (Map [(temprow * 10) + tempcol] == WATER && h) {nextleft=tempcol;}
    else{[l1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];}
    tempcol = c;
    temprow = r;
    while (tempcol<9 && Map[(temprow*10)+tempcol]==HIT) {tempcol++;}
    if (Map [(temprow * 10) + tempcol] == WATER && h) {nextright=tempcol;}
    else{[r1 replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:false]];}
    NSMutableArray *therows = [[NSMutableArray alloc] init];
    NSMutableArray *thecols = [[NSMutableArray alloc] init];
    
    if(([[u1 objectAtIndex:1] boolValue]||[[d1 objectAtIndex:1] boolValue]) && ([[u1 objectAtIndex:0] boolValue]||[[d1 objectAtIndex:0] boolValue])&& v)
    {
        if([[u1 objectAtIndex:0] boolValue])
        {
            [thecols addObject:[NSNumber numberWithInt:c]];
            [therows addObject:[NSNumber numberWithInt:nextup]];
        }
        if([[d1 objectAtIndex:0] boolValue])
        {
            [thecols addObject:[NSNumber numberWithInt:c]];
            [therows addObject:[NSNumber numberWithInt:nextdown]];
        }
    }
    if(([[l1 objectAtIndex:1] boolValue]||[[r1 objectAtIndex:1] boolValue]) && ([[l1 objectAtIndex:0] boolValue]||[[r1 objectAtIndex:0] boolValue])&& h)
    {
        
        if([[l1 objectAtIndex:0] boolValue])
        {
            [thecols addObject:[NSNumber numberWithInt:nextleft]];
            [therows addObject:[NSNumber numberWithInt:r]];
        }
        if([[r1 objectAtIndex:0] boolValue])
        {
            [thecols addObject:[NSNumber numberWithInt:nextright]];
            [therows addObject:[NSNumber numberWithInt:r]];
        }
    }
    if([thecols count]>0)
    {
        int select = arc4random_uniform((int)[thecols count]);
        [results addObject:[thecols objectAtIndex:select]];
        [results addObject:[therows objectAtIndex:select]];
    }
    else
    {
        if([[u1 objectAtIndex:0] boolValue] && v)
        {
            [thecols addObject:[NSNumber numberWithInt:c]];
            [therows addObject:[NSNumber numberWithInt:nextup]];
        }
        if([[d1 objectAtIndex:0] boolValue] && v)
        {
            [thecols addObject:[NSNumber numberWithInt:c]];
            [therows addObject:[NSNumber numberWithInt:nextdown]];
        }
        if([[l1 objectAtIndex:0] boolValue] && h)
        {
            [thecols addObject:[NSNumber numberWithInt:nextleft]];
            [therows addObject:[NSNumber numberWithInt:r]];
        }
        if([[r1 objectAtIndex:0] boolValue] && h)
        {
            [thecols addObject:[NSNumber numberWithInt:nextright]];
            [therows addObject:[NSNumber numberWithInt:r]];
        }
        int select = arc4random_uniform((int)[thecols count]);
        [results addObject:[thecols objectAtIndex:select]];
        [results addObject:[therows objectAtIndex:select]];
    }
    return results;
}
@end
