//
//  GameScene.m
//  Battleship Game
//
//  Created by Max on 11/03/2015.
//  Copyright (c) 2015 newcastlecv. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

CGFloat width;
CGFloat height;
bool resultReleased;
-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    battleship = [[Game alloc] init];
    [battleship SetGame];
    resultReleased = false;
    CGFloat r = 0.905; CGFloat g = 0.850; CGFloat b = 0.780; CGFloat a = 1;
    self.backgroundColor = [SKColor colorWithRed:r green:g blue:b alpha:a];
    SKLabelNode *enemyLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    enemyLabel.text = @"Enemy's Grid";
    enemyLabel.fontSize = 20;
    enemyLabel.fontColor= [SKColor redColor];
    enemyLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+365);
    [self addChild:enemyLabel];
    SKLabelNode *playerLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate"];
    playerLabel.text = @"Your Grid";
    playerLabel.fontSize = 20;
    playerLabel.fontColor= [SKColor blueColor];
    playerLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-370);
    [self addChild:playerLabel];
    
    width = CGRectGetMidX(self.frame);
    height = CGRectGetMidY(self.frame);
    
    int Xposition = width-190;
    int Yposition = height+345;
    for (int i =0; i<10; i++)
    {
        for (int j =0; j<20; j++)
        {
            Xposition =width-190 + (i*42);
            Yposition = height+345 + (-j*36);
            NSMutableString *nameId = [[NSMutableString alloc] init];
            if(j>9)
            {
                nameId = [[NSMutableString alloc]initWithString:@"b"];
                [nameId appendString:[[NSNumber numberWithInt:i] stringValue]];
                [nameId appendString:[[NSNumber numberWithInt:j-10] stringValue]];
            }
            else
            {
                nameId = [[NSMutableString alloc]initWithString:@"c"];
                [nameId appendString:[[NSNumber numberWithInt:i] stringValue]];
                [nameId appendString:[[NSNumber numberWithInt:j] stringValue]];
            }
            [self makeCell:nameId: WATER: Xposition: Yposition];
        }
    }
    [self   UpdateView];
    
    //Border between grids
    SKSpriteNode *border = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(self.frame.size.width, 5)];
    CGPoint borderPosition = CGPointMake(Xposition,Yposition+(9.5*36));
    border.position = borderPosition;
    [self addChild:border];
}

-(void) makeCell: (NSString*)nameId:(enum Cell)type:(int)Xcord:(int)Ycord
{
    CGPoint loc = CGPointMake(Xcord,Ycord);
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    if(type == WATER)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"water"];
    else if (type == SHIPUNIT)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"metal"];
    else if (type == MISS)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"sand"];
    else if (type == HIT)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"flame"];
    else if (type == DESTROYED)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"rust"];
    
    sprite.name = nameId;
    sprite.xScale = 0.09;
    sprite.yScale = 0.07;
    sprite.position = loc;
    [self addChild:sprite];
}
-(void) makeCell: (NSString*)nameId:(enum Cell)type:(CGPoint)pos
{
    CGPoint loc = pos;
    SKSpriteNode *sprite = [[SKSpriteNode alloc] init];
    if(type == WATER)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"water"];
    else if (type == SHIPUNIT)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"metal"];
    else if (type == MISS)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"sand"];
    else if (type == HIT)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"flame"];
    else if (type == DESTROYED)
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"rust"];
    
    sprite.name = nameId;
    sprite.xScale = 0.09;
    sprite.yScale = 0.07;
    sprite.position = loc;
    [self addChild:sprite];
}
-(void) UpdateView
{
    NSMutableArray *thegrids = [battleship GetGrids];
    for (int i=0; i<100; i++)
    {
        int m = (int)[[thegrids objectAtIndex:i] integerValue];
        int Xcoord = i%10;
        int Ycoord = i/10;
        NSMutableString *tempString = [[NSMutableString alloc] initWithString:@"c"];
        [tempString appendString:[[NSNumber numberWithInt:Xcoord] stringValue]];
        [tempString appendString:[[NSNumber numberWithInt:Ycoord] stringValue]];
        SKNode *temp = [self childNodeWithName:tempString];
        [temp removeFromParent];
        [self makeCell:tempString: m : temp.position];
    }
    for (int i=100; i<200; i++)
    {
        int m = (int)[[thegrids objectAtIndex:i] integerValue];
        int Xcoord = i%10;
        int Ycoord = (i-100)/10;
        NSMutableString *tempString = [[NSMutableString alloc] initWithString:@"b"];
        [tempString appendString:[[NSNumber numberWithInt:Xcoord] stringValue]];
        [tempString appendString:[[NSNumber numberWithInt:Ycoord] stringValue]];
        SKNode *temp = [self childNodeWithName:tempString];
        [temp removeFromParent];
        [self makeCell:tempString: m : temp.position];
    }
}
-(void) DisplayResult:(NSString*)gameResult
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:gameResult message:@"Press okay to quit"
    delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    alert.tag = -1;
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == -1)
    {
        if (buttonIndex == 0)
        {
            exit(0);
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *touchedNode = [self nodeAtPoint:location];
        NSString *theName = [touchedNode name];
        if([theName characterAtIndex:0]=='c' && [battleship GetTurn])
        {
            int Xpos = ((int)[theName characterAtIndex:1])%48;
            int Ypos = ((int)[theName characterAtIndex:2])%48;
            [battleship PlayerAttack:Xpos+(Ypos*10)];
            [self UpdateView];
            if([battleship EnemyCheckships]!=0)
            {
                [battleship EnemyAttack];
                [self UpdateView];
            }
        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(![battleship GameOn] && !resultReleased)
    {
        resultReleased = true;
        if([battleship GameResult])
            [self DisplayResult:@"YOU WON!"];
        else
            [self DisplayResult:@"YOU LOST!"];
    }
}

@end
