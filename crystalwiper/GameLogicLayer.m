//
//  GameLogicLayer.m

#import "ParticleFunctions.h"
#import "GameLogicLayer.h"
#import "SimpleAudioEngine.h"
#import "AdViewController.h"
#import "MainMenu.h"
#import "GameKit/GameKit.h"
#import "GameCenter.h"
#import "FloatScore.h"


// list private methods here
@interface GameLogicLayer (private)

- (void) startGame;
- (void) clearBoard;
- (void) tryCreateBrick;
- (void) createNewBricks;
- (void) gameOver;
- (void) removeBricks;
- (void) moveBricksDown;
- (void) updateInfoDisplays;
- (void) moveBrickDown:(Brick *)brick;
- (void) resetScores;
- (void) checkWinStatus;
- (void) showMenu;
- (void) fortsettSpill;
- (void) restartGame;
- (void) nextChallenge;
- (float) scale;
- (BOOL) isIpad;
- (void) retrieveHighScore;
@end



@implementation GameLogicLayer



- (id) init {
    self = [super init];
    if (self != nil) {
		if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
            playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
            CCLOG(@"MUSIC IS: %i",playAudio);
        }
        else {
            playAudio=YES;  
        }
        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
            playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
            CCLOG(@"SOUNDFX IS: %i",playSoundFX);
        }
        else {
            playSoundFX=YES;  
        }
        [[GameCenter sharedInstance] authenticateLocalUser];

        [self lagreHighscore];
        [self startGame];		
         
    }
    
    return self;
}



/// GAME CENTER ////
- (void) retrieveHighScore {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init]; 
    if (leaderboardRequest != nil) {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal; 
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime; 
        leaderboardRequest.range = NSMakeRange(1,1);
        [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
            if (error != nil) {
                // handle the error. if (scores != nil)
            }
            if (scores != nil){
                // process the score information.
                CCLOG(@"************** HIGHScore: %lld", ((GKScore*)[scores objectAtIndex:0]).value);
            } 
        }];
    }
}



- (void) reportScore: (int64_t) reportScore forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = reportScore;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            CCLOG(@"'*!*!*!**!*!*!*!* reportScore: %lld' error: %@!",reportScore,error);
        }
        else 
        {
            NSLog(@"'*************** reportScore: %lld' successful!",reportScore);
        }
    }];
}
/*
- (void) reportScore: (int64_t) reportScore forCategory: (NSString*) category
{
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:category];
    scoreReporter.value = reportScore;
    CCLOG(@"reporting scofre %i",reportScore);
    
    
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // handle the reporting error
            CCLOG(@"SCORE submission FAILED");
        }
        else {
            CCLOG(@"SCORE REPORTED!");
        }
    }];
}
 */

- (void) dealloc {
    [self clearBoard];
	
}

-(BOOL) isIpad{
    if([[UIDevice currentDevice].model hasPrefix:@"iPad"])
        return YES;
    else
        return NO;
}

- (void) initMenu{
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    int menuOffset=20,menuPosition=s.height-menuOffset,menuXmultiplier=1,scoreXpos=194,multiplierX=190,bobleX=180,scorevalueXpos=274,fontsize=14,text1Xpos=100,text1YPos=55*menuXmultiplier,multiplierFont=12;
    BOOL showFaceAndBubble=YES;
    if([self isIpad]){
       menuXmultiplier=2; 
        scoreXpos=295;
        multiplierX=100;
        scorevalueXpos=345;
        fontsize=18;
        bobleX=190;
        showFaceAndBubble=YES;
        text1Xpos=215;
        text1YPos=100;
        multiplierFont=20;
    }
    
   
    
    NSString *fontname=@"American Typewriter";
    //NSString *txtMultiplier=NSLocalizedString(@"txtMultiplier", @"");
    NSString *gname=NSLocalizedString(@"Menu", @"");
    
    
    //MENU
    CCMenu *menutop = [CCMenu node];
    menutop.position=ccp(55*menuXmultiplier,menuPosition);
    
    
    [CCMenuItemFont setFontName:fontname];
    [CCMenuItemFont setFontSize:24];
    CCMenuItemFont *mitem1 = [CCMenuItemFont itemWithString:gname block:^(id sender) {
        if(!gameisPaused) [self pauseGame]; 
    }];
    mitem1.color=ccc3(255,255,255);
    [menutop addChild:mitem1];
    [self addChild:menutop z:500];

    
    
    //NSString *txtDifficultyLevel;
    //txtDifficultyLevel=[[NSString alloc] initWithFormat:@"%i",difficultyLevel];
 
    difficultyText = [CCLabelTTF labelWithString:@" " fontName:fontname fontSize:multiplierFont];
    //difficultyText.position = ccp(200,55);
    difficultyText.position = ccp(text1Xpos+80,text1YPos);
    difficultyText.color=ccc3(0,0,0); 
    [self addChild:difficultyText z:30];
    
    
    NSString *scorel=NSLocalizedString(@"Score", @"");
    scoreLabel = [CCLabelTTF labelWithString:scorel fontName:fontname fontSize:22];
    scoreLabel.position =  ccp( scoreXpos*menuXmultiplier, menuPosition );
    scoreLabel.color=ccc3(0,0,0); 
    [self addChild:scoreLabel z:30];
    scoreLabel = [CCLabelTTF labelWithString:scorel fontName:fontname fontSize:22];
    scoreLabel.position =  ccp( (scoreXpos*menuXmultiplier)+1, menuPosition+1 );
    scoreLabel.color=ccc3(255,255,255); 
    [self addChild:scoreLabel z:31];
    
    scoreValueShadow = [CCLabelTTF labelWithString:@"  0" fontName:fontname fontSize:22];
    scoreValueShadow.position =  ccp( scorevalueXpos*menuXmultiplier, menuPosition );
    scoreValueShadow.color=ccc3(0,0,0); 
    [self addChild:scoreValueShadow z:30];
    scoreValue = [CCLabelTTF labelWithString:@"  0" fontName:fontname fontSize:22];
    scoreValue.position =  ccp( (scorevalueXpos*menuXmultiplier)+1, menuPosition+1 );
    scoreValue.color=ccc3(255,255,255); 
    [self addChild:scoreValue z:31];
   
    
    
    
    //MULTIPLIERTEXT
    bobletext = [CCLabelTTF labelWithString:@"" fontName:fontname fontSize:multiplierFont];
    bobletext.position = ccp(183*menuXmultiplier,76*menuXmultiplier);
    bobletext.color=ccc3(0,0,0); 
    [self addChild:bobletext z:30];
    
    Multiplier = [CCLabelTTF labelWithString:@"" fontName:fontname fontSize:multiplierFont];
    Multiplier.position = ccp(text1Xpos,text1YPos);
    Multiplier.color=ccc3(0,0,0); 
    [self addChild:Multiplier z:30];
    //showFaceAndBubble=YES;
    if(showFaceAndBubble){
        
    // BACKGROUND
    CCSprite *face;
    face = [CCSprite spriteWithFile:@"face.png"];
    face.position = ccp(35*menuXmultiplier,60*menuXmultiplier);
    [self addChild:face z:0];
    
    CCSprite *boble;
    boble = [CCSprite spriteWithFile:@"boble.png"];
    boble.position = ccp(bobleX*menuXmultiplier,60*menuXmultiplier);
    boble.opacity=180;
    [self addChild:boble z:0];
    }
    
    
    // clear the board
	memset(board, 0, sizeof(board));
	
    score = 0;
	frameCount = 0;
	moveCycleRatio = 45; // every 3/4 second
}

-(void) resetScores{
    allCrystals=0;
    blueCrystals=0;
    greenCrystals=0;
    reqCrystals=1000;
    redCrystals=0;
    yellowCrystals=0;
    purpleCrystals=0;
    iceCrystals=0;
    difficultyLevel=1;
    levelWon=NO;
    gameIsOver=NO;
    //CCLOG(@"gamemode %i",GameMode);
    
    switch(GameMode){
        case 0:
            //Maraton mode
            reqCrystals=100000;
            difficultyLevel=1;
            break;
            
        case 1:
            // Level 1
            reqCrystals=250;
            difficultyLevel=1;
            
            
            break;
        case 2:
            // Level 2
            reqCrystals=175;
            difficultyLevel=1;
            
            break;
        case 3:
            // Level 3
            reqCrystals=150;
            difficultyLevel=1;
            
            break;
        case 4:
            // Level 4
            reqCrystals=100;
            difficultyLevel=2;
            
            break;
        case 5:
            // Level 5
            difficultyLevel=3;
            reqCrystals=45;
            break;
        case 6:
            // Level 5
            difficultyLevel=3;
            reqCrystals=35;
            break;
        case 7:
            // Level 5
            difficultyLevel=4;
            reqCrystals=25;
            break;
        case 8:
            // FINAL LEVEL
            difficultyLevel=4;
            reqCrystals=7500000;
            break;
            
            
    }
    //DEBUG
    //reqCrystals=1; 
    //STOP
}

-(void) checkWinStatus{
    int menuXYmultiplier=1,text1Xpos=190,text1YPos=69*menuXYmultiplier,fontsize=12;
    if([self isIpad]){
        menuXYmultiplier=2;
        text1Xpos=500;
        text1YPos=150;
        fontsize=18;
    }
    levelWon=NO;
    if(GameMode>8)GameMode=8;
    //CCLOG(@"gamemode %i",GameMode);
    //CCLOG(@"allCrystals %i reqCrystals %i redCrystals %i",allCrystals,reqCrystals,redCrystals);
    NSString *txtGamemode;
    NSString *txtTmp;
    int remainingCrystals=0;
    txtTmp=@"";
    int playersHighscore=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] != nil) { 
        playersHighscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] intValue];
    }
    
    //Localized strings
    NSString *igjen=NSLocalizedString(@"igjen", @"");
    NSString *krystaller=NSLocalizedString(@"krystaller", @"");
    NSString *beatyourscore=NSLocalizedString(@"beatyourscore", @"");
    NSString *beatultimatehighscore=NSLocalizedString(@"beatultimatehighscore", @"");
    
    
    NSString *poeng=NSLocalizedString(@"poeng", @"");
    NSString *goal=NSLocalizedString(@"goal", @"");
    NSString *red=NSLocalizedString(@"red", @"");
    NSString *blue=NSLocalizedString(@"blue", @"");
    NSString *purple=NSLocalizedString(@"purple", @"");
    NSString *green=NSLocalizedString(@"green", @"");
    NSString *yellow=NSLocalizedString(@"yellow", @"");
    NSString *ice=NSLocalizedString(@"ice", @"");
    
    NSString *txtSetnewhighscore=NSLocalizedString(@"Setnewhighscore", @"");

    
    remainingCrystals=0;
    switch(GameMode){
        case 0:
            //Maraton mode
            txtGamemode=txtSetnewhighscore;
            if(playersHighscore>0)
                txtGamemode=[[NSString alloc] initWithFormat:@"%@ (%i %@) ",beatyourscore,playersHighscore,poeng];
            
            break;
            
        case 1:
            // Level 1
            if(allCrystals<reqCrystals) remainingCrystals=reqCrystals-allCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@  - %i %@ ",reqCrystals,krystaller,txtTmp,remainingCrystals,igjen];
            if(allCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 2:
            
            // Level 1 -røde krystaller
            if(redCrystals<reqCrystals) remainingCrystals=reqCrystals-redCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,red,krystaller,txtTmp,remainingCrystals,igjen];
            if(redCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 3:
            // Level 3
            if(yellowCrystals<reqCrystals) remainingCrystals=reqCrystals-yellowCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,yellow,krystaller,txtTmp,remainingCrystals,igjen];
            
            
            if(yellowCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 4:
            // Level 3
            if(greenCrystals<reqCrystals) remainingCrystals=reqCrystals-greenCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,green,krystaller,txtTmp,remainingCrystals,igjen];
            
            
            if(greenCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 5:
            // Level 4
            if(purpleCrystals<reqCrystals) remainingCrystals=reqCrystals-purpleCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,purple,krystaller,txtTmp,remainingCrystals,igjen];
            
            if(purpleCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 6:
            // Level 4
            if(blueCrystals<reqCrystals) remainingCrystals=reqCrystals-blueCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,blue,krystaller,txtTmp,remainingCrystals,igjen];
            
            if(blueCrystals>=reqCrystals)
                levelWon=YES;
            break;
            
        case 7:
            // Level 7-iskrystaller
            if(iceCrystals<reqCrystals) remainingCrystals=reqCrystals-iceCrystals;
            txtGamemode=[[NSString alloc] initWithFormat:@"%i %@ %@ %@  - %i %@ ",reqCrystals,ice,krystaller,txtTmp,remainingCrystals,igjen];
            
            if(iceCrystals>=reqCrystals)
                levelWon=YES;
            break;   
            
        case 8:
            // Level 8-final
            if(playersHighscore>0)
                txtGamemode=[[NSString alloc] initWithFormat:@"%@ (%i %@) ",beatultimatehighscore,playersHighscore,poeng];
            
            break;       
            
    }
   
    if(levelWon){
        
        [self leverOver];
    }
 
    NSString *fontname=@"American Typewriter";
    int multiplierFont=12;
    if([self isIpad]) multiplierFont=20;
    NSString *nytempStr =
    [[NSString alloc] initWithFormat:@"%@: %@",goal,txtGamemode];
    if([self isIpad]) { text1Xpos=338;text1YPos-=15;}
    //bobletext = [CCLabelTTF labelWithString:@"" fontName:fontname fontSize:multiplierFont];
    bobletext.position = ccp(text1Xpos,text1YPos);
    bobletext.color=ccc3(0,0,0);
    [bobletext setFontName:fontname];
    [bobletext setString:nytempStr];
    [bobletext draw];
    

    
}

- (void) nextChallenge{
    [self restartGame];
    
}



- (void) startGame {
    self.isTouchEnabled = YES;  
    gameisPaused=NO;
    //CHECK GAMEMODE
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] != nil) { 
        GameMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] intValue];
    }
    //CCLOG(@"playmode %i",GameMode);
    /*
     0 = Marathon
     1 > 10 = Challenge modes
     
     */

    [self resetScores];
    MaxLevels=8;
    GameModeChanged=NO;
    shakes=0;
    shadowscore=0;
    sprites = [[NSMutableArray alloc] init];  
    tagtab=0;
    gameIsOver=NO;
    GameOver=NO;
    //difficultyLevel=1;
    
    tries=0; 
    maxbricks=3;
    remainingshakes=3;
    rand1=random()%kLastColumn-1;
    if(rand1<1) rand1=1; 
    
    rand2=rand1+1;
    CGSize s = [[CCDirector sharedDirector] winSize];

    if([[UIDevice currentDevice].model hasPrefix:@"iPad"]){
        winY=s.height*0.76;
        //winX=200;
        brickSize=72;
        winXoffset=-25;
    } else {
        winY=s.height*0.81;
        winX=200;
        brickSize=36;
        winXoffset=20;
    }

    
    [self initMenu];
    [self fillTable];
    [self checkWinStatus];
   
    // Execute updateBoard 60 times per second.
	[self schedule:@selector(updateBoard:) interval: 1.0 / 60.0];
}

- (void) tryCreateBrick {
    BOOL makeBricks;
    makeBricks=YES;
    for(int l=0;l<=kLastColumn;l++){
        if(nil!=board[l][0]){
            makeBricks=NO;
        }
    }
    
    if(makeBricks) {
	    [self createNewBricks];
    }
    
}
- (void) tryCreateFiveBricks {
    BOOL makeBricks;
    makeBricks=YES;
    for(int l=1;l<kLastColumn;l++){
        if(nil!=board[l][0]){
            makeBricks=NO;
        }
    }
    
    if(makeBricks) {
	    [self createFiveBricks];
    }
    
}


- (void) removeText:(id) sender {
    // CCLOG(@"called removetext in logic");
    [self removeChild:sender cleanup:YES];
    [self updateInfoDisplays];
}


- (void) fillTable{
    for(int y=0;y<kLastRow+1;y++){
        
        for(int x=1;x<=kLastColumn;x++){
            if(nil==board[x][y]){
                [sprites addObject:[NSNumber numberWithInt:tagtab]];
                
                
                brick1 = [Brick newBrick:difficultyLevel];
                board[x][y] = brick1;
                brick1.boardX = x; brick1.boardY = y;
                brick1.position = COMPUTE_X_Y(x,y,winY,winXoffset,brickSize);
                //CCLOG(@"brickposition %i",brick1.position);
                //CCLOG(@"tag %i",tagtab);
                brick1.tag=tagtab;
                [self addChild:brick1 z:2];
                tagtab++;
            }
        } 
    }
    
    
}



- (void) createNewBricks {
    for(int x=1;x<kLastColumn+1;x++){
        [sprites addObject:[NSNumber numberWithInt:tagtab]];
        brick1 = [Brick  newBrick:difficultyLevel];
        board[x][0] = brick1;
        brick1.tag=tagtab;
        brick1.boardX = x; brick1.boardY = 0;
        brick1.position = COMPUTE_X_Y(x,0,winY,winXoffset,brickSize);
        [self addChild:brick1 z:5];
        tagtab++;
	}
    
}


- (void) createFiveBricks {
    for(int x=2;x<kLastColumn;x++){
        [sprites addObject:[NSNumber numberWithInt:tagtab]];
        brick1 = [Brick  newBrick:difficultyLevel];
        board[x][0] = brick1;
        brick1.tag=tagtab;
        brick1.boardX = x; brick1.boardY = 0;
        brick1.position = COMPUTE_X_Y(x,0,winY,winXoffset,brickSize);
        [self addChild:brick1 z:5];
        tagtab++;
	}
    
}
- (void) tryCreateSomeBricks {
    [self moveBricksDown];
    BOOL createBricks=NO;
    for(int x=1;x<=kLastColumn;x++){
        if(nil==board[x][0]){
            createBricks=YES;
            [sprites addObject:[NSNumber numberWithInt:tagtab]];
            brick1 = [Brick  newBrick:difficultyLevel];
            board[x][0] = brick1;
            brick1.tag=tagtab;
            brick1.boardX = x; brick1.boardY = 0;
            brick1.position = COMPUTE_X_Y(x,0,winY,winXoffset,brickSize);
            [self addChild:brick1 z:5];
            tagtab++;
        }
    }
    [self checkWinStatus];
    if(!createBricks){
        [self isGameOver];
    }
    
}




- (void) clearBoard{
    // REMOVES EVERYTHING
    [self resetScores];
    [self blankWindow];
    
    [self removeAllChildrenWithCleanup:YES];
    
    gameIsOver=NO;
    GameOver=NO;
    
}
- (void) fortsettSpill{
    gameisPaused=NO;
    [self blankWindow];
    [self removeChildByTag:100991 cleanup:YES];
    [self removeChildByTag:100993 cleanup:YES];
    [self removeChildByTag:100994 cleanup:YES];
    
    [self removeChildByTag:100995 cleanup:YES];
    [self removeChildByTag:100996 cleanup:YES];
    [self removeChildByTag:100992 cleanup:YES];
    [self removeChildByTag:100990 cleanup:YES];
    [self schedule:@selector(updateBoard:) interval: 1.0 / 60.0];
    self.isTouchEnabled = YES;
    //[[CCDirector sharedDirector] startAnimation];
}

- (void) showMenu{
    [[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

- (void) blankWindow{
    // BLANKS WINDOW
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    //CCLOG(@"winsize %i %i",s.width,s.height);
    CCSprite *temp=[CCSprite spriteWithFile:@"whitepixel.png"];
    temp.position=ccp(s.width/2,s.height/2);
    [self addChild:temp z:50000];    //set as most top layer
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        temp.scaleX=s.width*2;
        temp.scaleY=s.height*2;
    } else {
        temp.scaleX=s.width;
        temp.scaleY=s.height;
    }
    temp.opacity=255; // this will cover whole screen with white color
    [temp runAction:[CCFadeTo actionWithDuration:1 opacity:0]];  //255 to 0
    
}



- (void) restartGame {
    gameisPaused=NO;
    //[[CCDirector sharedDirector] stopAnimation];
    /*
    if(GameMode!=0 && GameModeChanged){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:(GameMode--) forKey:@"kPlayLastMode"];
        [defaults synchronize];
        GameModeChanged=NO;
        GameMode--;
    }
    */
        
    
    // REMOVES EVERYTHING
    [self removeAllChildrenWithCleanup:YES];
    
    // ADDS GAMETEXT, SCORES ETC
    [self initMenu];
    [self resetScores];
    
    [self blankWindow];
    
    
    gameIsOver=NO;
    GameOver=NO;
    moveCycleRatio = 45;
    shakes=0;
    shadowscore=0;
   
    //[self fillTable];
    [self schedule:@selector(updateBoard:) interval: 1.0 / 60.0];
    self.isTouchEnabled = YES;
    
    
}




- (void)changeText
{
    [self removeChildByTag:100 cleanup:YES];
}

- (void) dimScreen{
    // DIMS WINDOW
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    //CCLOG(@"winsize %i %i",s.width,s.height);
    CCSprite *temp=[CCSprite spriteWithFile:@"whitepixel.png"];
    temp.position=ccp(s.width/2,s.height/2);
    [self addChild:temp z:80];    //set as most top layer
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
        temp.scaleX=s.width*2;
        temp.scaleY=s.height*2;
    } else {
        temp.scaleX=s.width;
        temp.scaleY=s.height;
    }
    temp.opacity=150; // this will cover whole screen with white color
    temp.tag=100994;
    //[temp runAction:[CCFadeTo actionWithDuration:1 opacity:30]];  //255 to 0
    
    
}


- (void) pauseGame{
    self.isTouchEnabled = NO;
    [self unschedule: @selector(updateBoard:)];

    [self dimScreen];
    gameisPaused=YES;
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    int menuXYmultiplier=1,fontsize=13,xPos=s.width/2-10,svenardoXpos=180,feedbackXpos=160,menuXpos=s.width/2-10,menuYpos=290*menuXYmultiplier,pauseYpos=340*menuXYmultiplier,pauseFontsize=18;
    if([self isIpad]){
        CCLOG(@"IS IPAD!iph-y %i y%i",290*menuXYmultiplier,menuYpos);
        menuXYmultiplier=2;
        fontsize=24;
        pauseFontsize=30;
        xPos=s.width/2;
        svenardoXpos=s.width/2+100;
        feedbackXpos=s.width/2;
        menuXpos=s.width/2;
        menuYpos=s.height/2+100;
        pauseYpos=360*menuXYmultiplier;
    }
    
    // SVENARDO + FEEDBACKBOKS
    CCSprite *feedback;
    feedback = [CCSprite spriteWithFile:@"feedback.png"];
    feedback.position = ccp(feedbackXpos,240*menuXYmultiplier);
    feedback.tag=100995;
    feedback.opacity=230;
    [self addChild:feedback z:90];
    
    CCSprite *svenardo;
    svenardo = [CCSprite spriteWithFile:@"svenardo1.png"];
    svenardo.position = ccp(svenardoXpos,180*menuXYmultiplier);
    svenardo.tag=100992;
    [self addChild:svenardo z:90];
    
    
    
    
    
    NSString *text=NSLocalizedString(@"txtPause", @"");
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"American Typewriter" size:pauseFontsize]
                       constrainedToSize:CGSizeMake(self.contentSize.width-100, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"American Typewriter" fontSize:18.0f];
    textLabel.color=ccc3(222,161,87);
    textLabel.tag=100993;
    // CGSize s = [[CCDirector sharedDirector] winSize]; 
    //textLabel.position=ccp(s.width/2,s.height/2);
    textLabel.position=ccp(s.width/2,pauseYpos);
    
    [self addChild: textLabel z:100];
    
    
    //OPTIONS
    NSString *txtContinue=NSLocalizedString(@"txtUCContinue", @"");
    NSString *txtRestartGame=NSLocalizedString(@"Restart", @"");
    
    NSString *txtMenu=NSLocalizedString(@"Main", @"");
    
    NSString *fontname=@"LCD";
    
    
    CCLabelTTF *lblText1 = [CCLabelTTF labelWithString:txtMenu fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lblText1 target:self selector:@selector(showMenu)];
    item1.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText2 = [CCLabelTTF labelWithString:txtRestartGame fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lblText2 target:self selector:@selector(restartGame)];
    item2.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText3 = [CCLabelTTF labelWithString:txtContinue fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:lblText3 target:self selector:@selector(fortsettSpill)];
    item3.color=ccc3(222,161,87);
    
    
    
    
    CCMenu *menu = [CCMenu menuWithItems:
                    item1, item2, item3,
                    
                    nil]; // 3 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:3],
     nil
     ]; 
    
    [self addChild: menu z:10099 tag:100996];
    [menu setPosition:ccp(menuXpos,menuYpos)];
    
        
}

- (void) leverOver{
    CCLOG(@"******************* LEVEL OVER");
    self.isTouchEnabled = NO;
    [self unschedule: @selector(updateBoard:)];

    [self lagreHighscore];
    
    gameisPaused=YES;
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    int menuXYmultiplier=1,fontsize=13,xPos=s.width/2-10,svenardoXpos=180,feedbackXpos=160,menuXpos=s.width/2-10,menuYpos=290*menuXYmultiplier,pauseYpos=340*menuXYmultiplier,pauseFontsize=18,xPadding=100;
    if([self isIpad]){
        CCLOG(@"IS IPAD!iph-y %i y%i",290*menuXYmultiplier,menuYpos);
        menuXYmultiplier=2;
        fontsize=24;
        pauseFontsize=30;
        xPos=s.width/2;
        svenardoXpos=s.width/2+100;
        feedbackXpos=s.width/2;
        menuXpos=s.width/2;
        menuYpos=s.height/2+100;
        pauseYpos=360*menuXYmultiplier;
        
        xPadding=180;
    }

    
    [self dimScreen]; 
   
    //SETT NESTE LEVEL UNLOCKED
    
    int levelsUnlocked=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] != nil) { 
        levelsUnlocked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] intValue];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(GameMode<MaxLevels){
        GameMode++;
        CCLOG(@"**** neste level: %i",GameMode);
        [defaults setInteger:(GameMode) forKey:@"kPlayLastMode"];
        [defaults synchronize];
        GameModeChanged=YES;
    }
    
    if(levelsUnlocked<=GameMode && GameMode<MaxLevels){
        [defaults setInteger:(GameMode) forKey:@"kLevelsUnlocked"];
        [defaults synchronize];
    }
    
    
    
    // SVENARDO + FEEDBACKBOKS
    CCSprite *feedback;
    feedback = [CCSprite spriteWithFile:@"feedback.png"];
    feedback.position = ccp(feedbackXpos,240*menuXYmultiplier);
    feedback.tag=100995;
    feedback.opacity=230;
    [self addChild:feedback z:90];
    
    CCSprite *svenardo;
    svenardo = [CCSprite spriteWithFile:@"svenardo1.png"];
    svenardo.position = ccp(svenardoXpos,180*menuXYmultiplier);
    svenardo.tag=100992;
    [self addChild:svenardo z:90];
    
    
    
    
    
    NSString *text=NSLocalizedString(@"txtleveldone1", @"");
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"American Typewriter" size:pauseFontsize]
                       constrainedToSize:CGSizeMake(self.contentSize.width-xPadding, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"American Typewriter" fontSize:pauseFontsize];
    textLabel.color=ccc3(222,161,87);
    textLabel.tag=100993;
    // CGSize s = [[CCDirector sharedDirector] winSize]; 
    //textLabel.position=ccp(s.width/2,s.height/2);
    textLabel.position=ccp(s.width/2,pauseYpos);
    
    [self addChild: textLabel z:100];
    
    
    //OPTIONS
    NSString *txtNextLevel=NSLocalizedString(@"nextLevel", @"");
    NSString *txtRestartGame=NSLocalizedString(@"Restart", @"");
    NSString *txtMenu=NSLocalizedString(@"Menu", @"");
    
    NSString *fontname=@"LCD";
    CCLabelTTF *lblText1 = [CCLabelTTF labelWithString:txtMenu fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lblText1 target:self selector:@selector(showMenu)];
    item1.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText2 = [CCLabelTTF labelWithString:txtRestartGame fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lblText2 target:self selector:@selector(restartGame)];
    item2.color=ccc3(222,161,87);
    
    
    CCLabelTTF *lblText3 = [CCLabelTTF labelWithString:txtNextLevel fontName:fontname fontSize:fontsize ];
    CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:lblText3 target:self selector:@selector(nextChallenge)];
    item3.color=ccc3(222,161,87);
    
    
    CCMenu *menu = [CCMenu menuWithItems:
                    item1,  item3,
                    
                    nil]; // 7 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     nil
     ]; 
    
    [self addChild: menu z:10099];
    [menu setPosition:ccp(s.width/2,290*menuXYmultiplier)];
    //[self unschedule: @selector(updateBoard:)];
    
    
}

- (void) lagreHighscore{
    int playersHighscore=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] != nil) { 
        playersHighscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] intValue];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"ACTUAL SCORE: %i",score);
    NSLog(@"PLAYER sHIGHSCORE: %i",playersHighscore);
    
    if(score>playersHighscore){
        //Lagre ny highscore
        [defaults setInteger:score forKey:@"kHighscore"];
        int64_t highscore;
        highscore=(int64_t)playersHighscore;
        //Send til gamecenter
    }
    int64_t highscore;
    highscore=(int64_t)playersHighscore;
    highscore=(int64_t)1000;
    
    [self reportScore:(int64_t)playersHighscore forCategory:@"wiperchamps"];
    
    int kAllCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kAllCrystals"] != nil) { 
        kAllCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kAllCrystals"] intValue];
    }
    [defaults setInteger:kAllCrystals+allCrystals forKey:@"kAllCrystals"];
    
    int kRedCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kRedCrystals"] != nil) { 
        kRedCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kRedCrystals"] intValue];
        //CCLOG(@" red er %i",kRedCrystals);
    }
    [defaults setInteger:kRedCrystals+redCrystals forKey:@"kRedCrystals"];
     //CCLOG(@"setter red %i",kRedCrystals+redCrystals);
    
    int kGreenCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kGreenCrystals"] != nil) { 
        kGreenCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kGreenCrystals"] intValue];
    }
    [defaults setInteger:kGreenCrystals+greenCrystals forKey:@"kGreenCrystals"];
    
    
    int kBlueCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kBlueCrystals"] != nil) { 
        kBlueCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kBlueCrystals"] intValue];
    }
    [defaults setInteger:kBlueCrystals+blueCrystals forKey:@"kBlueCrystals"];
    
    int kYellowCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kYellowCrystals"] != nil) { 
        kYellowCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kYellowCrystals"] intValue];
    }
    [defaults setInteger:kYellowCrystals+yellowCrystals forKey:@"kYellowCrystals"];
    
    int kIceCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kIceCrystals"] != nil) { 
        kIceCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kIceCrystals"] intValue];
    }
    [defaults setInteger:kIceCrystals+iceCrystals forKey:@"kIceCrystals"];
    
    
    int kPurpleCrystals=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPurpleCrystals"] != nil) { 
        kPurpleCrystals = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPurpleCrystals"] intValue];
    }
    [defaults setInteger:kPurpleCrystals+purpleCrystals forKey:@"kPurpleCrystals"];
    
    
    
    [defaults synchronize];
    
    [self reportScore:highscore forCategory:@"wiperchamps"];
    
}


- (void) gameOver {
    self.isTouchEnabled = NO;
    [self unschedule: @selector(updateBoard:)];

    gameIsOver=YES;
    [self lagreHighscore];
    [self dimScreen];
    
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    int menuXYmultiplier=1,fontsize=13,xPos=s.width/2-10,svenardoXpos=180,feedbackXpos=160,menuXpos=s.width/2-10,menuYpos=290*menuXYmultiplier,pauseYpos=340*menuXYmultiplier,pauseFontsize=18,xPadding=100;
    if([self isIpad]){
        CCLOG(@"IS IPAD!iph-y %i y%i",290*menuXYmultiplier,menuYpos);
        menuXYmultiplier=2;
        fontsize=24;
        pauseFontsize=30;
        xPos=s.width/2;
        svenardoXpos=s.width/2+100;
        feedbackXpos=s.width/2;
        menuXpos=s.width/2;
        menuYpos=s.height/2+100;
        pauseYpos=360*menuXYmultiplier;
        xPadding=180;
    }
    
    // SVENARDO + FEEDBACKBOKS
    CCSprite *feedback;
    feedback = [CCSprite spriteWithFile:@"feedback.png"];
    feedback.position = ccp(feedbackXpos,240*menuXYmultiplier);
    feedback.tag=100995;
    feedback.opacity=230;
    [self addChild:feedback z:90];
    
    CCSprite *svenardo;
    svenardo = [CCSprite spriteWithFile:@"svenardo2.png"];
    svenardo.position = ccp(svenardoXpos,180*menuXYmultiplier);
    svenardo.tag=100992;
    [self addChild:svenardo z:90];
    
    NSString *text=NSLocalizedString(@"txtgameover", @"");
    
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"American Typewriter" size:pauseFontsize]
                       constrainedToSize:CGSizeMake(self.contentSize.width-xPadding, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"American Typewriter" fontSize:pauseFontsize];
    textLabel.color=ccc3(222,161,87);
    textLabel.tag=100993;
    // CGSize s = [[CCDirector sharedDirector] winSize]; 
    //textLabel.position=ccp(s.width/2,s.height/2);
    textLabel.position=ccp(s.width/2,pauseYpos);
    
    [self addChild: textLabel z:100];
    
    NSString *txtRestartGame=NSLocalizedString(@"Restart", @"");
    NSString *txtMenu=NSLocalizedString(@"Menu", @"");
    NSString *fontname=@"LCD";
    
    CCLabelTTF *lblText1 = [CCLabelTTF labelWithString:txtMenu fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lblText1 target:self selector:@selector(showMenu)];
    item1.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText2 = [CCLabelTTF labelWithString:txtRestartGame fontName:fontname fontSize:fontsize];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lblText2 target:self selector:@selector(restartGame)];
    item2.color=ccc3(222,161,87);
    
    CCMenu *menu = [CCMenu menuWithItems:
                    item1, item2,
                    
                    nil]; // 7 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     nil
     ]; 
    
    [self addChild: menu z:10099];
    [menu setPosition:ccp(s.width/2,menuYpos)];
    
}

// This method is the game logic loop. It gets called 60 times per second
- (void) updateBoard:(ccTime)dt {
	frameCount++;
	[self moveBricksDown];
    // [self isGameOver];

    if(!gameIsOver){
        [self removeBricks];
        
        if (frameCount % moveCycleRatio == 0) {
            [self tryCreateSomeBricks]; 
            
            if(playAudio){
                if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
                    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"funny_loop.mp3" loop:YES];
            }
                   
        }
    }
}





- (void) isGameOver{
    tempGrouping = [[NSMutableArray alloc] init];
    BOOL keepchecking,brickfound,foundThree;
    int x,y,m,bricktype;
    
    foundThree=NO;
    //DEBUg
    /*
     for (int l=0;l<[sprites count];l++){
        Brick *brick3 = (Brick *)[self getChildByTag:l];
        brick3.opacity=255;
    }
    */
    
    for (int l=0;l<[sprites count];l++){
        
        
        if(!foundThree){
            Brick *brick3 = (Brick *)[self getChildByTag:l];
            
            x=brick3.boardX;
            y=brick3.boardY;
            m=0;
            
            if(nil!=brick3){
                [tempGrouping addObject:brick3];
                Brick *nbrick;                
                
                keepchecking=YES;
                while(keepchecking){
                    
                    brickfound=NO;
                    /*
                     for (int l=0;l<[tempGrouping count];l++){
                        //CCLOG(@"loopround %i ",l);
                        Brick *brick = [tempGrouping objectAtIndex:l];
                        //CCLOG(@"bricktype %i",brick.brickType);
                        if(brick.boardY>0 && brick.boardY <=kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY-1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{    
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                        
                                    }
                                }
                            } }
                        
                        if(brick.boardY>=0 && brick.boardY <kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY+1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;   
                                    }
                                }    
                            } }                     
                        
                        if(brick.boardX>0 && brick.boardX <kLastColumn){ 
                            nbrick=board[brick.boardX-1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;   
                                    }
                                }
                            } }
                        
                        if(brick.boardX>0 && brick.boardX <kLastColumn){ 
                            nbrick=board[brick.boardX+1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                        
                                    }
                                }
                            } }
                        
                        
                    }
                    */
                    for (int l=0;l<[tempGrouping count];l++){
                        //CCLOG(@"loopround %i ",l);
                        Brick *brick = [tempGrouping objectAtIndex:l];
                        //CCLOG(@"bricktype %i",brick.brickType);
                        if(brick.boardY>0 && brick.boardY <=kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY-1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    bricktype=brick3.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{    
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        if(brick.boardY>=0 && brick.boardY <kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY+1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    bricktype=brick3.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }    
                            } }                     
                        
                        if(brick.boardX>0 && brick.boardX <=kLastColumn){ 
                            nbrick=board[brick.boardX-1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){ 
                                    bricktype=brick3.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        if(brick.boardX>0 && brick.boardX <kLastColumn){ 
                            nbrick=board[brick.boardX+1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick3.brickType){
                                    bricktype=brick3.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        
                    }

                    
                    if(brickfound) keepchecking=YES; else keepchecking=NO;
                }
                
            }  
        }
        if([tempGrouping count] > 2){
            foundThree=YES;
            
        }
        
        
        //DEBUG
       /*
        for (int kk=0;kk<[tempGrouping count];kk++){
            Brick *brick = [tempGrouping objectAtIndex:kk];
            brick.disappearing=YES;
        }
        */
        
        //FJERN DUPLIKATER
        for (int kk=0;kk<[tempGrouping count];kk++){
            Brick *brick = [tempGrouping objectAtIndex:kk];
            if(brick.brickType!= bricktype) [tempGrouping removeObjectAtIndex:kk];
        }
        
        /*
         for (int kk=0;kk<[tempGrouping count];kk++){
            Brick *brick = [tempGrouping objectAtIndex:kk];
            brick.opacity=90;
        }
        */
         
        
        //CCLOG(@"FOund %i!",[tempGrouping count]);
        [tempGrouping removeAllObjects];
        
    } 
    
    if(!foundThree){
        //CCLOG(@"GAME OVER!"); 
        [self gameOver];
        GameOver=YES;
    }
    
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
  	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    tempGrouping = [[NSMutableArray alloc] init];
    
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    //point.y = 480 - point.y;
    point.y = s.height - point.y;
    
    locationX = s.height - point.y;
	locationY = s.width - point.x;
    BOOL keepchecking;
    BOOL brickfound;
    brickfound=NO;
    int x,y,m,bricktype;
    /*
     if((int)point.y>0 && (int)point.y<=80
     && (int)point.x>120 && (int)point.x <= 240){
     //CCLOG(@"restart");
     [self restartGame];
     } 
    if((int)point.y>450 && (int)point.y<=480
       && (int)point.x>0 && (int)point.x <= 90){
        [self pauseGame];        
    } 
    CCLOG(@"x%i y%i",(int)point.x,(int)point.y);
    */
    for (int l=0;l<[sprites count];l++){
        
        Brick *brick3 = (Brick *)[self getChildByTag:l];
        
        if (CGRectContainsPoint([brick3 boundingBox], point)){
            //CCLOG(@"touched brick type: %i %i - disapp: %i",brick3.boardX,brick3.boardY,brick3.disappearing);
            x=brick3.boardX;
            y=brick3.boardY;
            m=0;
            if(nil!=brick3){
                [tempGrouping addObject:brick3];
                Brick *nbrick;                
                
                keepchecking=YES;
                while(keepchecking){
                    
                    brickfound=NO;
                    for (int l=0;l<[tempGrouping count];l++){
                        //CCLOG(@"loopround %i ",l);
                        Brick *brick = [tempGrouping objectAtIndex:l];
                        //CCLOG(@"bricktype %i",brick.brickType);
                        if(brick.boardY>0 && brick.boardY <=kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY-1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick.brickType){ 
                                    bricktype=brick.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{    
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        if(brick.boardY>=0 && brick.boardY <kLastRow){ 
                            nbrick=board[brick.boardX][brick.boardY+1];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick.brickType){ 
                                    bricktype=brick.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }    
                            } }                     
                        
                        if(brick.boardX>0 && brick.boardX <=kLastColumn){ 
                            nbrick=board[brick.boardX-1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick.brickType){ 
                                    bricktype=brick.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        if(brick.boardX>0 && brick.boardX <kLastColumn){ 
                            nbrick=board[brick.boardX+1][brick.boardY];
                            if(nil!=nbrick){ 
                                if(nbrick.brickType==brick.brickType){
                                    bricktype=brick.brickType;
                                    if ([tempGrouping containsObject:nbrick]){
                                    }else{
                                        [tempGrouping addObject:nbrick];
                                        brickfound=YES;     
                                    }
                                }
                            } }
                        
                        
                    }
                    
                    if(brickfound) keepchecking=YES; else keepchecking=NO;
                }
                
            }  
        } 
    }
    for (int kk=0;kk<[tempGrouping count];kk++){
        Brick *brick = [tempGrouping objectAtIndex:kk];
        // CCLOG(@"brick vs type %i %i",brick.brickType, bricktype);
        if(brick.brickType!= bricktype) [tempGrouping removeObjectAtIndex:kk];
    }
    
    if([tempGrouping count] > 2){
        for (int l=0;l<[tempGrouping count];l++){
            Brick *brick = [tempGrouping objectAtIndex:l];
            brick.disappearing=YES;
           
            //DEBUG
            /*
             brick.opacity=100;
            
            if ([touch tapCount] == 2) {
                brick.disappearing=YES;
            }
             */
            
        }
    }
    
    
    
}

-(float) scale{
    return 1; 
}


- (void) moveBrickDown:(Brick *)brick {
	board[brick.boardX][brick.boardY] = nil;
    if(nil==board[brick.boardX][brick.boardY + 1]){
        board[brick.boardX][brick.boardY + 1] = brick;
        [brick moveDown];
    }
    
}



- (void) removeBricks {	
	//Brick *brick = nil;
    //sprites = [[NSMutableArray alloc] init];  
    BOOL playsound1;
    playsound1=NO;
	BOOL playsound2;
    playsound2=NO;
	j=1;
    for (int x = 0; x <= kLastColumn; x++) {
		for (int y = 0; y <= kLastRow; y++) {
			
			brick1 = board[x][y];
			
			// Is this block disappearing?
			if (nil != brick1 && brick1.disappearing) {
				allCrystals++;
                //CCLOG(@"brick %d",brick1);
                switch(brick1.brickType){
                    case 0: redCrystals++; break;
                    case 1: yellowCrystals++; break;
                    case 2: greenCrystals++; break;
                    case 3: purpleCrystals++; break;
                    case 4: blueCrystals++; break;
                    case 5: iceCrystals++; break;
                }
                playsound1=YES;
                if(j>4){
                    playsound1=NO;
                    playsound2=YES;
                }
                float remx=(float)brick1.position.x;
                float remy=(float)brick1.position.y;
                [sprites removeObject:brick1];
                //CCLOG(@"removing brick %i %i",brick1.boardX,brick1.boardY);
                [self removeChild:brick1 cleanup:YES];
                score += (((difficultyLevel)*8)*(2+j));
                shadowscore +=(((difficultyLevel)*8)*(2+j));
                //CCLOG(@"shadowscore: %i",shadowscore);
                //CCLOG(@"difficulty: %i",difficultyLevel);
                [FloatScore createExplosionX:remx y:remy localScore:(((difficultyLevel)*5)*(2+j)) inParent:self];
                
                if(shadowscore > 30000){
                    difficultyLevel++;
                    shadowscore=0;
                }
                    NSString *txtMultiplier=NSLocalizedString(@"txtMultiplier", @"");
                
                    NSString *tempDiff = 
                    [[NSString alloc] initWithFormat:@"%@ %d",txtMultiplier,difficultyLevel];
                    
                    [difficultyText setString:tempDiff];
                    [difficultyText draw];
                    
                
                
                brick1 = nil;
                board[x][y] = nil;
                [ParticleFunctions createExplosionX:remx y:remy inParent:self];
                j++;
                 //CCLOG(@"red:%i yel:%i green:%i lilla:%i blue:%i ice:%i",redCrystals,yellowCrystals,greenCrystals,purpleCrystals,blueCrystals,iceCrystals);
			}
            
		}
       
        
	}
    
    //CCLOG(@"playSoundFX %i",playSoundFX);    
    if(playSoundFX){
        if(playsound1) [[SimpleAudioEngine sharedEngine] playEffect:@"button-39.mp3"];
        if(playsound2) [[SimpleAudioEngine sharedEngine] playEffect:@"button-38.mp3"];
    }
}


- (void) moveBricksDown {	
    
    [self tryCreateBrick];
	
	for (int x = kLastColumn; x >= 0; x--) {
		for (int y = kLastRow; y >= 0; y--) {
			
			brick1 = board[x][y];
			if (nil != brick1 && !brick1.disappearing) {
				if ( kLastRow != y && (nil == board[x][y + 1]) ) {
					
					[self moveBrickDown:brick1];
                    
					
				} 
				
			} 
			
		} 
	} 
	
}

- (void) updateInfoDisplays {
	static int oldScore = 0;
    
	
    if (oldScore != score) {
		oldScore = score;
		NSString *tempStr = 
        [[NSString alloc] initWithFormat:@"%d",score];
		[scoreValue setString:tempStr];
		[scoreValue draw];
		[scoreValueShadow setString:tempStr];
		[scoreValueShadow draw];
		//[tempStr release];
		//tempStr = nil;
    }
    
    
    
}

@end