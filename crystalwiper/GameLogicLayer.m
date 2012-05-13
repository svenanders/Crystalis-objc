//
//  GameLogicLayer.m

#import "ParticleFunctions.h"
#import "GameLogicLayer.h"
#import "SimpleAudioEngine.h"
#import "AdViewController.h"
#import "MainMenu.h"


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
- (void) restartGame;
- (void) nextChallenge;
- (float) scale;
- (void) retrieveHighScore;
@end



@implementation GameLogicLayer



- (id) init {
    self = [super init];
    if (self != nil) {
		// this tells Cocos2d to call our touch event handlers
		self.isTouchEnabled = YES;
        
        self.isAccelerometerEnabled = NO;
        
        //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/60];
        //shake_once = false;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
            playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
        }
        else {
            playAudio=YES;  
        }
        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
            playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
        }
        else {
            playAudio=YES;  
        }
        
        
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
                CCLOG(@"My Score: %d", ((GKScore*)[scores objectAtIndex:0]).value);
            } 
        }];
    }
}


- (void) dealloc {
    [self clearBoard];
	
}
- (void) initMenu{
    
    NSString *gname=NSLocalizedString(@"GameName", @"");
    NSString *fontname=@"American Typewriter";
    logotext = [CCLabelTTF labelWithString:gname fontName:fontname fontSize:24];
    logotext.position = ccp(49,461);
    logotext.color=ccc3(255,255,255); 
    [self addChild:logotext z:30];
    logotext = [CCLabelTTF labelWithString:gname fontName:fontname fontSize:24];
    logotext.position = ccp(50,460);
    logotext.color=ccc3(0,0,0); 
    [self addChild:logotext z:30];
    
    NSString *txtDifficultyLevel;
    txtDifficultyLevel=[[NSString alloc] initWithFormat:@"%i",difficultyLevel];
    
    /*difficultyText = [CCLabelTTF labelWithString:txtDifficultyLevel fontName:fontname fontSize:24];
    difficultyText.position = ccp(149,461);
    difficultyText.color=ccc3(255,255,255); 
    [self addChild:difficultyText z:30];
    */
    difficultyText = [CCLabelTTF labelWithString:txtDifficultyLevel fontName:fontname fontSize:24];
    difficultyText.position = ccp(150,461);
    difficultyText.color=ccc3(0,0,0); 
    [self addChild:difficultyText z:30];
    
    
    NSString *scorel=NSLocalizedString(@"Score", @"");
    scoreLabel = [CCLabelTTF labelWithString:scorel fontName:fontname fontSize:22];
    scoreLabel.position =  ccp( 204, 459 );
    scoreLabel.color=ccc3(255,255,255); 
    [self addChild:scoreLabel z:30];
    scoreLabel = [CCLabelTTF labelWithString:scorel fontName:fontname fontSize:22];
    scoreLabel.position =  ccp( 205, 460 );
    scoreLabel.color=ccc3(0,0,0); 
    [self addChild:scoreLabel z:30];
    
    scoreValueShadow = [CCLabelTTF labelWithString:@"  0" fontName:fontname fontSize:22];
    scoreValueShadow.position =  ccp( 274, 459 );
    scoreValueShadow.color=ccc3(255,255,255); 
    [self addChild:scoreValueShadow z:30];
    scoreValue = [CCLabelTTF labelWithString:@"  0" fontName:fontname fontSize:22];
    scoreValue.position =  ccp( 275, 460 );
    scoreValue.color=ccc3(0,0,0); 
    [self addChild:scoreValue z:30];
    
    
    
    //BOBLETEKST
    bobletext = [CCLabelTTF labelWithString:@"WELCOME" fontName:fontname fontSize:14];
    bobletext.position = ccp(110,70);
    bobletext.color=ccc3(0,0,0); 
    [self addChild:bobletext z:30];
    /*
     bobletext = [CCLabelTTF labelWithString:gname fontName:@"American Typewriter" fontSize:14];
    bobletext.position = ccp(110,69);
    bobletext.color=ccc3(0,0,0); 
    [self addChild:bobletext z:30];
    */
    
    
    // BACKGROUND
    CCSprite *face;
    face = [CCSprite spriteWithFile:@"face.png"];
    face.position = ccp(35,68);
    [self addChild:face z:0];
    
    CCSprite *boble;
    boble = [CCSprite spriteWithFile:@"boble.png"];
    boble.position = ccp(180,68);
    boble.opacity=180;
    [self addChild:boble z:0];
    
    
    
    /*
    tbutton2 = [CCLabelTTF labelWithString:NSLocalizedString(@"Restart", @"") fontName:@"LCD" fontSize:22];
    tbutton2.position = ccp(158,68);
    tbutton2.color=ccc3(255,255,255);
    [self addChild:tbutton2 z:30];
    tbutton2 = [CCLabelTTF labelWithString:NSLocalizedString(@"Restart", @"") fontName:@"LCD" fontSize:22];
    tbutton2.position = ccp(157,67);
    tbutton2.color=ccc3(0,0,0);
    [self addChild:tbutton2 z:30];
    */
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
    
    levelWon=NO;
    gameIsOver=NO;
    CCLOG(@"gamemode %i",GameMode);
    
    switch(GameMode){
        case 0:
            //Maraton mode
            reqCrystals=100000;
            break;
            
        case 1:
            // Level 1
            reqCrystals=200;
            difficultyLevel=1;
            
            
            break;
        case 2:
            // Level 2
            reqCrystals=100;
            difficultyLevel=1;
            
            break;
        case 3:
            // Level 3
            reqCrystals=75;
            difficultyLevel=1;
            
            break;
        case 4:
            // Level 4
            reqCrystals=75;
            difficultyLevel=2;
            
            break;
        case 5:
            // Level 5
            difficultyLevel=3;
            reqCrystals=75;
            break;
        case 6:
            // Level 5
            difficultyLevel=3;
            reqCrystals=75;
            break;
        case 7:
            // Level 5
            difficultyLevel=4;
            reqCrystals=75;
            break;
        case 8:
            // FINAL LEVEL
            difficultyLevel=4;
            reqCrystals=75;
            break;
    
            
    }
reqCrystals=5;
    
}

-(void) checkWinStatus{
    levelWon=NO;
    //CCLOG(@"levelwon %i gameover %i gamemode %i",levelWon,gameIsOver,GameMode);
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
    
    
    
    remainingCrystals=0;
    switch(GameMode){
        case 0:
            //Maraton mode
            txtGamemode=@"Sett en ny highscore!";
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
            if(iceCrystals<reqCrystals) remainingCrystals=reqCrystals-iceCrystals;
            if(playersHighscore>0)
                txtGamemode=[[NSString alloc] initWithFormat:@"%@ (%i %@) ",beatultimatehighscore,playersHighscore,poeng];
            
            if(iceCrystals>=reqCrystals)
                levelWon=YES;
            break;       
            
    }
 
    if(levelWon){
        
        [self leverOver];
    }
    /*
     NSString *nytempStr = 
    [[NSString alloc] initWithFormat:@"%@ bare %i av %i",txtGamemode,redCrystals,reqCrystals];
*/
    NSString *nytempStr = 
    [[NSString alloc] initWithFormat:@"%@: %@",goal,txtGamemode];

    bobletext.position=ccp(190,69);
    bobletext.fontSize=12;
    [bobletext setString:nytempStr];
    [bobletext draw];
}

- (void) nextChallenge{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] != nil) { 
        GameMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] intValue];
    }
    GameMode++;
    

    [self restartGame];
    
}



- (void) startGame {
    //[self resetScores];
    
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
    
    shakes=0;
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
    [self initMenu];
    [self fillTable];
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

- (void) fillTable{
    
   
    
    
    for(int y=0;y<kLastRow+1;y++){
        
        for(int x=1;x<=kLastColumn;x++){
            [sprites addObject:[NSNumber numberWithInt:tagtab]];
            
            
            brick1 = [Brick newBrick:difficultyLevel];
            board[x][y] = brick1;
            brick1.boardX = x; brick1.boardY = y;
            brick1.position = COMPUTE_X_Y(x,y);
            brick1.tag=tagtab;
            [self addChild:brick1 z:2];
            tagtab++;
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
        brick1.position = COMPUTE_X_Y(x,0);
        [self addChild:brick1 z:5];
        tagtab++;
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
    //difficultyLevel=1;
    
    //[self removeChildByTag:999 cleanup:YES];
	
    
	for (int x = 0; x <= kLastColumn; x++) {
		for (int y = 0; y <= kLastRow; y++) {
			
			brick1= board[x][y];
			  
            score=0;
                [self removeChild:brick1 cleanup:YES];
                brick1 = nil;
                board[x][y] = nil;
              
			
		} // End of for y loop.
	} // End of for x loop.
    [self fillTable];
    
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
    temp.tag=994;
    //[temp runAction:[CCFadeTo actionWithDuration:1 opacity:30]];  //255 to 0
    
 
}

- (void) leverOver{
    CCLOG(@"******************* LEVEL OVER");
    gameIsOver=YES;
    [self lagreHighscore];
    
    [self dimScreen]; 
    
    //SETT NESTE LEVEL UNLOCKED
    
    int levelsUnlocked=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] != nil) { 
        levelsUnlocked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] intValue];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(levelsUnlocked<GameMode){
        CCLOG(@"*****!!** setter Levelsunlocked: %i",(GameMode+1));
        [defaults setInteger:(GameMode+1) forKey:@"kLevelsUnlocked"];
    }
    [defaults synchronize];
    
    // SVENARDO + FEEDBACKBOKS
    CCSprite *feedback;
    feedback = [CCSprite spriteWithFile:@"feedback.png"];
    feedback.position = ccp(160,240);
    feedback.tag=992;
    feedback.opacity=230;
    [self addChild:feedback z:90];
    
    CCSprite *svenardo;
    svenardo = [CCSprite spriteWithFile:@"svenardo1.png"];
    svenardo.position = ccp(180,180);
    svenardo.tag=992;
    [self addChild:svenardo z:90];
    
    
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    
    NSString *text=NSLocalizedString(@"txtleveldone1", @"");
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"American Typewriter" size:18.0f]
                       constrainedToSize:CGSizeMake(self.contentSize.width-100, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"American Typewriter" fontSize:18.0f];
    textLabel.color=ccc3(222,161,87);
    textLabel.tag=993;
   // CGSize s = [[CCDirector sharedDirector] winSize]; 
    //textLabel.position=ccp(s.width/2,s.height/2);
    textLabel.position=ccp(s.width/2,340);
    
    [self addChild: textLabel z:100];

    
    //OPTIONS
    NSString *txtNextLevel=NSLocalizedString(@"nextLevel", @"");
    NSString *txtRestartGame=NSLocalizedString(@"Restart", @"");
    NSString *txtMenu=NSLocalizedString(@"Menu", @"");
    
    
    CCLabelTTF *lblText1 = [CCLabelTTF labelWithString:txtMenu fontName:@"American Typewriter" fontSize:16];
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lblText1 target:self selector:@selector(showMenu)];
    item1.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText2 = [CCLabelTTF labelWithString:txtRestartGame fontName:@"American Typewriter" fontSize:16];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lblText2 target:self selector:@selector(restartGame)];
    item2.color=ccc3(222,161,87);
    
    
    CCLabelTTF *lblText3 = [CCLabelTTF labelWithString:txtNextLevel fontName:@"American Typewriter" fontSize:16];
    CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:lblText3 target:self selector:@selector(nextChallenge)];
    item3.color=ccc3(222,161,87);
    
    
    CCMenu *menu = [CCMenu menuWithItems:
                    item1, item2, item3,
                    
                    nil]; // 7 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:3],
     nil
     ]; 
    
    [self addChild: menu z:999];
    [menu setPosition:ccp(s.width/2,290)];
    
   
    
}

- (void) lagreHighscore{
    int playersHighscore=0;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] != nil) { 
        playersHighscore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kHighscore"] intValue];
    }
    if(score>playersHighscore){
        //Lagre ny highscore
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:score forKey:@"kHighscore"];
        [defaults synchronize];
    }
    
}


- (void) gameOver {
    gameIsOver=YES;
    [self lagreHighscore];
    [self dimScreen];
    
    // SVENARDO + FEEDBACKBOKS
    CCSprite *feedback;
    feedback = [CCSprite spriteWithFile:@"feedback.png"];
    feedback.position = ccp(160,240);
    feedback.tag=992;
    feedback.opacity=230;
    [self addChild:feedback z:90];
    
    CCSprite *svenardo;
    svenardo = [CCSprite spriteWithFile:@"svenardo2.png"];
    svenardo.position = ccp(180,180);
    svenardo.tag=992;
    [self addChild:svenardo z:90];
    
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    
    NSString *text=NSLocalizedString(@"txtgameover", @"");
    
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"American Typewriter" size:18.0f]
                       constrainedToSize:CGSizeMake(self.contentSize.width-100, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"American Typewriter" fontSize:18.0f];
    textLabel.color=ccc3(222,161,87);
    textLabel.tag=993;
    // CGSize s = [[CCDirector sharedDirector] winSize]; 
    //textLabel.position=ccp(s.width/2,s.height/2);
    textLabel.position=ccp(s.width/2,340);
    
    [self addChild: textLabel z:100];

    NSString *txtRestartGame=NSLocalizedString(@"Restart", @"");
    NSString *txtMenu=NSLocalizedString(@"Menu", @"");
    
    
    CCLabelTTF *lblText1 = [CCLabelTTF labelWithString:txtMenu fontName:@"American Typewriter" fontSize:20];
    CCMenuItemLabel *item1 = [CCMenuItemLabel itemWithLabel:lblText1 target:self selector:@selector(showMenu)];
    item1.color=ccc3(222,161,87);
    
    CCLabelTTF *lblText2 = [CCLabelTTF labelWithString:txtRestartGame fontName:@"American Typewriter" fontSize:20];
    CCMenuItemLabel *item2 = [CCMenuItemLabel itemWithLabel:lblText2 target:self selector:@selector(restartGame)];
    item2.color=ccc3(222,161,87);
    
    CCMenu *menu = [CCMenu menuWithItems:
                    item1, item2,
                    
                    nil]; // 7 items.
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInt:2],
     nil
     ]; 
    
    [self addChild: menu z:999];
    [menu setPosition:ccp(s.width/2,290)];
    
 
}

// This method is the game logic loop. It gets called 60 times per second
- (void) updateBoard:(ccTime)dt {
	frameCount++;
	[self moveBricksDown];
    
    if(!gameIsOver){
    [self removeBricks];
        
    [self checkWinStatus];
    
    [self updateInfoDisplays];
        
    if (frameCount % moveCycleRatio == 0) {
        [self isGameOver];
        
        [self tryCreateBrick];
        
        
        //CCLOG(@"playaudio %i",playAudio);        
        //CCLOG(@"crystals %i",allCrystals);        

        
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
    int x,y,m;
    foundThree=NO;
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
                
                if(brickfound) keepchecking=YES; else keepchecking=NO;
            }
            
        }  
        }
        if([tempGrouping count] > 2){
           foundThree=YES;
           /*
            //CCLOG(@"FOund %i!",[tempGrouping count]);
           for (int l=0;l<[tempGrouping count];l++){
               Brick *brick = [tempGrouping objectAtIndex:l];
             //  CCLOG(@"bricktype %i, %ix%i",brick.brickType,brick.boardX,brick.boardY);

           }
            */
       }
    
        [tempGrouping removeAllObjects];

    } 
    
    if(!foundThree){
        CCLOG(@"GAME OVER!"); 
        [self gameOver];
        GameOver=YES;
    }
    
       
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
  	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView: [touch view]];
    tempGrouping = [[NSMutableArray alloc] init];
    
    
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    point.y = 480 - point.y;
    locationX = s.height - point.y;
	locationY = s.width - point.x;
    BOOL keepchecking;
    BOOL brickfound;
    brickfound=NO;
    int x,y,m;
    
    if((int)point.y>0 && (int)point.y<=80
       && (int)point.x>120 && (int)point.x <= 240){
        //CCLOG(@"restart");
        [self restartGame];
    } 
    
    
    for (int l=0;l<[sprites count];l++){
        
        Brick *brick3 = (Brick *)[self getChildByTag:l];
        
        if (CGRectContainsPoint([brick3 boundingBox], point)){
            //CCLOG(@"touched brick type: %i %i - disapp: %i",brick.boardX,brick.boardY,brick.disappearing);
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
    
    
    if([tempGrouping count] > 2){
        for (int l=0;l<[tempGrouping count];l++){
            Brick *brick = [tempGrouping objectAtIndex:l];
            brick.disappearing=YES;
        }
    }
    
   
    
}

-(float) scale{
    return 1; 
}


 - (void) moveBrickDown:(Brick *)brick {
	board[brick.boardX][brick.boardY] = nil;
	board[brick.boardX][brick.boardY + 1] = brick;
    //brick.moveDown;
     [brick moveDown];
     
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
                //float remx=(float)brick1.position.x;
                //float remy=(float)brick1.position.y;
                [sprites removeObject:brick1];
                //CCLOG(@"removing brick %i %i",brick1.boardX,brick1.boardY);
                [self removeChild:brick1 cleanup:YES];
                score += (((difficultyLevel)*13)*j);
                brick1 = nil;
                board[x][y] = nil;
               // [ParticleFunctions createExplosionX:remx y:remy inParent:self];
                j++;
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
    int oldDifficultylevel = difficultyLevel;
	//CCLOG(@"*** diffi %i ****",difficultyLevel);
    
    if(score<5000){
        if(difficultyLevel<=1) difficultyLevel=1;
    }
    if(score>10000){
        if(difficultyLevel<2) difficultyLevel=2;
    }
    if(score>15000){
        if(difficultyLevel<3) difficultyLevel=3;
    }
    if(score>20000){
        if(difficultyLevel<4) difficultyLevel=4;
    }
    //CCLOG(@"*** diffi2 %i ****",difficultyLevel);

    if(oldDifficultylevel != difficultyLevel){
        NSString *tempDiff = 
        [[NSString alloc] initWithFormat:@"%d",difficultyLevel];
		
    	[difficultyText setString:tempDiff];
		[difficultyText draw];
        
	//	[scoreValueShadow setString:tempStr];
	//	[scoreValueShadow draw];
	
    }
    
	
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