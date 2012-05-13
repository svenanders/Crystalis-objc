//
// Menu Demo
// a cocos2d example
// http://www.cocos2d-iphone.org
//

#import "SimpleAudioEngine.h"
#import "MainMenu.h"
#import "GameScene.h"



enum {
	kTagMenu = 1,
	kTagMenu0 = 0,
	kTagMenu1 = 1,
};


#pragma mark - MainMenu

@implementation MainMenu
-(id) init
{
	if( (self=[super init])) {
       
        // [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:playAudo] forKey:@"kPlayAudio"];
        //NSInteger highScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kHighScore"] intValue];    
        BOOL playAudio=YES;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
            playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
            CCLOG(@"************ AUDIO DEFINED! *** SET AS %i!",playAudio);
            
        }
        else {
            CCLOG(@"************ AUDIO NOT DEFINED *** SET AS YES!");
            
        }
        
        BOOL playSoundFX=YES;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
            playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
            CCLOG(@"************ SoundFX DEFINED! *** SET AS %i!",playSoundFX);
            
        }
        else {
            CCLOG(@"************ SoundFX NOT DEFINED *** SET AS YES!");
            
        }
            
        
                
        //PRELOAD SOUNDS
        [self preloadSounds];
        
        // BACKGROUND
        background4 = [CCSprite spriteWithFile:@"seigmenn.jpg"];
        background4.position = ccp(160,240);
        [self addChild:background4 z:0];
        
        //HAVE ANIMATION START AND INIT AUDIO
        [[CCDirector sharedDirector] startAnimation];
        audioInit=NO;    
        
        //GAME NAME
        NSString *gname=NSLocalizedString(@"GameName", @"");
        
#ifdef __CC_PLATFORM_IOS
        self.isTouchEnabled = YES;
#endif
		
        
        // Font Item
		CCMenuItemFont *item1 = [CCMenuItemFont itemWithString: gname block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
		}];
        
		[item1 setFontSize:48];
        [item1 setColor:ccc3(0,0,255)];
		[item1 setFontName:@"LCD"];
        const int FLASH_PERIOD=2;
        id action = [CCTintTo actionWithDuration:FLASH_PERIOD/2 red:255 green:255 blue:255];
        id actionReverse = [CCTintTo actionWithDuration:FLASH_PERIOD/2 red:0 green:0 blue:0];
        
        id sequence = [CCSequence actionOne:action two:actionReverse];
        action = sequence;
        int times=2;
        for(int i = 1; i < times; i++)
        {
            action = [CCSequence actionOne:sequence two:action];
        }
        
        [item1 runAction: action];
        
        // Font Item
        /*
         CCSprite *spriteNormal = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*2,115,23)];
         CCSprite *spriteSelected = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*1,115,23)];
         CCSprite *spriteDisabled = [CCSprite spriteWithFile:@"menuitemsprite.png" rect:CGRectMake(0,23*0,115,23)];
         CCMenuItemSprite *item1 = [CCMenuItemSprite itemWithNormalSprite:spriteNormal selectedSprite:spriteSelected disabledSprite:spriteDisabled block:^(id sender) {
         [[CCDirector  sharedDirector] replaceScene:[GameScene node]];
         
         
         }];
         
         // Image Item
         CCMenuItem *item2 = [CCMenuItemImage itemWithNormalImage:@"SendScoreButton.png" selectedImage:@"SendScoreButtonPressed.png" block:^(id sender) {
         CCScene *scene = [CCScene node];
         [scene addChild:[Layer3 node]];
         [[CCDirector sharedDirector] replaceScene:scene];
         }];
         
         // Label Item (LabelAtlas)
         CCLabelAtlas *labelAtlas = [CCLabelAtlas labelWithString:@"0123456789" charMapFile:@"fps_images.png" itemWidth:12 itemHeight:32 startCharMap:'.'];
         CCMenuItemLabel *item3 = [CCMenuItemLabel itemWithLabel:labelAtlas block:^(id sender) {
         // hijack all touch events for 5 seconds
         CCDirector *director = [CCDirector sharedDirector];
         #ifdef __CC_PLATFORM_IOS
         [[director touchDispatcher] setPriority:kCCMenuHandlerPriority-1 forDelegate:self];
         [self schedule:@selector(allowTouches) interval:5.0f repeat:0 delay:0];
         #elif defined(__CC_PLATFORM_MAC)
         [[director eventDispatcher] addMouseDelegate:self priority:kCCMenuHandlerPriority-1];
         [self schedule:@selector(allowTouches) interval:5.0f];
         #endif
         NSLog(@"TOUCHES DISABLED FOR 5 SECONDS");
         }];
         
         item3.disabledColor = ccc3(32,32,64);
         item3.color = ccc3(200,200,255);
         */
        
        NSString *playnow=NSLocalizedString(@"Play", @"");
        
		// Font Item
		CCMenuItemFont *item2 = [CCMenuItemFont itemWithString: playnow block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			//self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
            [[CCDirector  sharedDirector] replaceScene:[GameScene node]];
            
		}];
        
		[item2 setFontSize:32];
		[item2 setFontName:@"LCD"];
        item2.color=ccc3(0,0,0);
        
        
        // UTFORDRINGER
        NSString *utfordringer=NSLocalizedString(@"utfordringer", @"");
        
		CCMenuItemFont *item3 = [CCMenuItemFont itemWithString: utfordringer block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			//self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
            // [[CCDirector  sharedDirector] replaceScene:[GameScene node]];
            CCScene *scene = [CCScene node];
            [scene addChild:[menuChallenges node]];
            [[CCDirector sharedDirector] replaceScene:scene];
            
		}];
        
		[item3 setFontSize:32];
		[item3 setFontName:@"LCD"];
        item3.color=ccc3(0,0,0);
        
        
        // MARATON
        NSString *marathonmode=NSLocalizedString(@"Marathon", @"");
        
		CCMenuItemFont *item4 = [CCMenuItemFont itemWithString: marathonmode block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			//self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:0 forKey:@"kPlayLastMode"];
            [defaults synchronize];

            [[CCDirector  sharedDirector] replaceScene:[GameScene node]];
            
		}];
        
        
		[item4 setFontSize:32];
		[item4 setFontName:@"LCD"];
        item4.color=ccc3(0,0,0);
        
        
        
        // OM SPILLET
        NSString *txtSettings=NSLocalizedString(@"Settings", @"");
        
		CCMenuItemFont *item6 = [CCMenuItemFont itemWithString: txtSettings block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			//self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
            CCScene *scene = [CCScene node];
            [scene addChild:[menuSettings node]];
            [[CCDirector sharedDirector] pushScene:scene];			
            
            
		}];
        
		[item6 setFontSize:32];
		[item6 setFontName:@"LCD"];
        item6.color=ccc3(0,0,0);
        
        
        
        // OM SPILLET
        NSString *aboutgame=NSLocalizedString(@"About", @"");
        
		CCMenuItemFont *item5 = [CCMenuItemFont itemWithString: aboutgame block:^(id sender) {
			// IMPORTANT: It is safe to use "self" because CCMenuItem#cleanup will break any possible circular reference.
			//self->disabledItem.isEnabled = ~self->disabledItem.isEnabled;
            CCScene *scene = [CCScene node];
            [scene addChild:[LayerPriorityTest node]];
            [[CCDirector sharedDirector] pushScene:scene];			
         
            
		}];
        
		[item5 setFontSize:32];
		[item5 setFontName:@"LCD"];
        item5.color=ccc3(0,0,0);
        
        /*
        id color_action = [CCTintBy actionWithDuration:0.5f red:255 green:255 blue:255];
        id color_back = [color_action reverse];
        id seq = [CCSequence actions:color_action, color_back, nil];
        [item5 runAction:[CCRepeatForever actionWithAction:seq]];
        */
/*
 const int FLASH_PERIOD=2;
        id action = [CCTintTo actionWithDuration:FLASH_PERIOD/2 red:251 green:236 blue:94];
        id actionReverse = [CCTintTo actionWithDuration:FLASH_PERIOD/2 red:0 green:0 blue:0];
        
        id sequence = [CCSequence actionOne:action two:actionReverse];
        action = sequence;
        int times=2;
        for(int i = 1; i < times; i++)
        {
            action = [CCSequence actionOne:sequence two:action];
        }
        
        [item5 runAction: action];
*/
        
        
		// Label Item (CCLabelBMFont)
        /*
         CCLabelBMFont *label = [CCLabelBMFont labelWithString:playnow fntFile:@"bitmapFontTest3.fnt"];
         CCMenuItemLabel *item5 = [CCMenuItemLabel itemWithLabel:label block:^(id sender) {
         [[CCDirector  sharedDirector] replaceScene:[GameScene node]];
         }];
         
         // Testing issue #500
         item5.scale = 0.8f;
         
         // Events
         [CCMenuItemFont setFontName: @"Marker Felt"];
         CCMenuItemFont *item6 = [CCMenuItemFont itemWithString:@"Priority Test" block:^(id sender) {
         CCScene *scene = [CCScene node];
         [scene addChild:[LayerPriorityTest node]];
         [[CCDirector sharedDirector] pushScene:scene];			
         }];
         
         // Font Item
         [CCMenuItemFont setFontSize:30];
         [CCMenuItemFont setFontName: @"LCD"];
         CCMenuItemFont *item7 = [CCMenuItemFont itemWithString: @"Quit" block:^(id sender){
         CC_DIRECTOR_END();
         }];
         
         id color_action = [CCTintBy actionWithDuration:0.5f red:0 green:-255 blue:-255];
         id color_back = [color_action reverse];
         id seq = [CCSequence actions:color_action, color_back, nil];
         [item7 runAction:[CCRepeatForever actionWithAction:seq]];
         */
		CCMenu *menu = [CCMenu menuWithItems: item1, item2, item3, item4, item6, item5, nil];
		[menu alignItemsVertically];
        
        
		// elastic effect
		CGSize s = [[CCDirector sharedDirector] winSize];
		int i=0;
		for( CCNode *child in [menu children] ) {
			CGPoint dstPoint = child.position;
			int offset = s.width/2 + 50;
			if( i % 2 == 0)
				offset = -offset;
			child.position = ccp( dstPoint.x + offset, dstPoint.y);
			[child runAction:
			 [CCEaseElasticOut actionWithAction:
			  [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
										 period: 0.35f]
             ];
			i++;
		}
        
		
		[self addChild: menu];
		//[menu setPosition:ccp(s.width/2, s.height/2)];
        [menu setPosition:ccp(s.width/2, (s.height/2)+50)];
        
	}
    
	return self;
}

#ifdef __CC_PLATFORM_IOS
-(void) registerWithTouchDispatcher
{
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority+1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

#elif defined(__CC_PLATFORM_MAC)
-(BOOL) ccMouseDown:(NSEvent *)event
{
	return YES;
}
-(BOOL) ccMouseUp:(NSEvent *)event
{
	return YES;
}

-(BOOL) ccMouseMoved:(NSEvent *)event
{
	return YES;
}
-(BOOL) ccMouseDragged:(NSEvent *)event
{
	return YES;
}
#endif // __CC_PLATFORM_MAC

-(void) dealloc
{
    
}

-(void) allowTouches
{
	CCDirector *director = [CCDirector sharedDirector];
#ifdef __CC_PLATFORM_IOS
    [[director touchDispatcher] setPriority:kCCMenuHandlerPriority+1 forDelegate:self];
    [self unscheduleAllSelectors];
    
#elif defined(__CC_PLATFORM_MAC)
    [[director eventDispatcher] removeMouseDelegate:self];
#endif
    
	NSLog(@"TOUCHES ALLOWED AGAIN");
}



-(void) setupAudio{
    if(audioInit==YES){
        return;
    }else {
        audioInit=YES;
        NSOperationQueue *queue = [NSOperationQueue new];
        NSInvocationOperation *asyncSetupOperation =
        [[NSInvocationOperation alloc] initWithTarget:self
                                             selector:@selector(initAudioAsync)
                                               object:nil];
        [queue addOperation:asyncSetupOperation];
        
        
    }
    
}

-(void) preloadSounds {
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"button-38.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadEffect:@"button-39.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"funny_loop.mp3"];
}



- (void) startGame: (id) sender
{
    CGSize s = [[CCDirector sharedDirector] winSize]; 
    CCSprite *temp=[CCSprite spriteWithFile:@"blackpixel.png"];
    temp.position=ccp(s.width/2,s.height/2);
    [self addChild:temp z:50000];    //set as most top layer
    temp.scaleX=s.width;
    temp.scaleY=s.height;
    temp.opacity=0;
    [temp runAction:[CCFadeTo actionWithDuration:1 opacity:255]];  //0 to 255
    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    
}

@end

#pragma mark - Settings menu
@implementation menuSettings
-(id) init
{
    if( (self=[super init]) ) {
        
        // BACKGROUND
        background4 = [CCSprite spriteWithFile:@"seigmenn.jpg"];
        background4.position = ccp(160,240);
        [self addChild:background4 z:0];
        
        
      
        
        NSString *txtOn=NSLocalizedString(@"On", @"");
        NSString *txtOff=NSLocalizedString(@"Off", @"");
        NSString *txtMusic=NSLocalizedString(@"Music", @"");
        NSString *txtSound=NSLocalizedString(@"Lyd", @"");
        NSString *txtQuality=NSLocalizedString(@"Quality", @"");
        NSString *txtHigh=NSLocalizedString(@"High", @"");
        NSString *txtLow=NSLocalizedString(@"Low", @"");
        NSString *txtOrientation=NSLocalizedString(@"Orientation", @"");
        //NSString *txtMainmenu=NSLocalizedString(@"MainMenu", @"");
        NSString *txtBack=NSLocalizedString(@"Back", @"");
        
        
        BOOL playAudio=YES;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
            playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
        }
        else {
            
        }
        
        BOOL playSoundFX=YES;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
            playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
        }
        else {
            
        }
        
        
        
        
        
        [CCMenuItemFont setFontName: @"American Typewriter"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItemFont *title1 = [CCMenuItemFont itemWithString: txtSound];
		[title1 setIsEnabled:NO];
		[CCMenuItemFont setFontName: @"LCD"];
		[CCMenuItemFont setFontSize:34];
		CCMenuItemToggle *item1 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback2:) items:
                                   [CCMenuItemFont itemWithString: txtOn],
                                   [CCMenuItemFont itemWithString: txtOff],
                                   nil];
        item1.tag=1;
        if(playSoundFX){ item1.selectedIndex = 0; } else {item1.selectedIndex = 1;}
        
        
		[CCMenuItemFont setFontName: @"American Typewriter"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItemFont *title2 = [CCMenuItemFont itemWithString: txtMusic];
		[title2 setIsEnabled:NO];
		[CCMenuItemFont setFontName: @"LCD"];
		[CCMenuItemFont setFontSize:34];
		CCMenuItemToggle *item2 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback2:) items:
                                   [CCMenuItemFont itemWithString: txtOn],
                                   [CCMenuItemFont itemWithString: txtOff],
                                   nil];
        item2.tag=2;
        if(playAudio){ item2.selectedIndex = 0; } else {item2.selectedIndex = 1;}
        
		[CCMenuItemFont setFontName: @"American Typewriter"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItemFont *title3 = [CCMenuItemFont itemWithString: txtQuality];
		[title3 setIsEnabled:NO];
        [CCMenuItemFont setFontName: @"LCD"];
		[CCMenuItemFont setFontSize:34];
		CCMenuItemToggle *item3 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback2:) items:
                                   [CCMenuItemFont itemWithString: txtHigh],
                                   [CCMenuItemFont itemWithString: txtLow],
                                   nil];
        item3.tag=3;
        
		[CCMenuItemFont setFontName: @"American Typewriter"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItemFont *title4 = [CCMenuItemFont itemWithString: txtOrientation];
		[title4 setIsEnabled:NO];
        
		[CCMenuItemFont setFontName: @"LCD"];
		[CCMenuItemFont setFontSize:34];
		CCMenuItemToggle *item4 = [CCMenuItemToggle itemWithTarget:self selector:@selector(menuCallback2:) items:
                                   [CCMenuItemFont itemWithString: txtOff], nil];
        item4.tag=999;
		NSArray *more_items = [NSArray arrayWithObjects:
                               [CCMenuItemFont itemWithString: @"33%"],
                               [CCMenuItemFont itemWithString: @"66%"],
                               [CCMenuItemFont itemWithString: @"100%"],
                               nil];
		// TIP: you can manipulate the items like any other NSMutableArray
		[item4.subItems addObjectsFromArray: more_items];
        
		// you can change the one of the items by doing this
		item4.selectedIndex = 2;
        
		[CCMenuItemFont setFontName: @"Marker Felt"];
		[CCMenuItemFont setFontSize:34];
        
	    CCMenu *menu = [CCMenu menuWithItems:
                        title1, title2,
                        item1, item2,
                        
                        nil]; // 7 items.
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:2],
		 [NSNumber numberWithUnsignedInt:2],
         
         nil
         ]; // 2 + 2 + 1 + 1 + 1 = total count of 7.
        
        
		[self addChild: menu];
		CGSize s = [[CCDirector sharedDirector] winSize];
		[menu setPosition:ccp(s.width/2, s.height/2)];
        
        
        [CCMenuItemFont setFontName: @"LCD"];
		[CCMenuItemFont setFontSize:34];
        
		CCLabelTTF *lblText = [CCLabelTTF labelWithString:txtBack fontName:@"American Typewriter" fontSize:30];
		CCMenuItemLabel *mBack = [CCMenuItemLabel itemWithLabel:lblText target:self selector:@selector(backCallback:)];
        
        
		mBack.color=ccc3(0,0,0);
        CCMenu *menu1 = [CCMenu node];
        [menu1 setPosition:ccp(s.width/2, 100)];
        
        [menu1 addChild:mBack];
        
        [menu1 alignItemsVerticallyWithPadding:2  ];
        [self addChild:menu1 z:100];
        
        
    }       
    return self;
}

- (void) dealloc
{
	
}

-(void) menuCallback: (id) sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[MainMenu node]];
	[[CCDirector sharedDirector] replaceScene:scene];
}

-(void) menuCallback2: (id) sender
{
    int identifier = [sender tag];
    NSLog(@"Label clicked with tag %i",identifier);
    
    
    BOOL playAudio=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
        playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
    }
    else {
        
    }
    
    BOOL playSoundFX=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
        playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
    }
    else {
        
    }
    
    
    switch(identifier){
        case 1:
            //SOunDFX
            CCLOG(@"SOUNDFX is:%i",playSoundFX);
            if(playSoundFX){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:0 forKey:@"kPlaySoundFX"];
                [defaults synchronize];
                
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"kPlaySoundFX"];
                [defaults synchronize];
                
            }
            break;
            
        case 2:
            //AUDIO
            CCLOG(@"AUDIO is:%i",playAudio);
            if(playAudio){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:0 forKey:@"kPlayAudio"];
                [defaults synchronize];
                
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"kPlayAudio"];
                [defaults synchronize];
                
            }
            break;
            
    }
    
    
	disabledItem.isEnabled = ~disabledItem.isEnabled;
	[disabledItem stopAllActions];
}
-(void) backCallback: (id) sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[MainMenu node]];
	[[CCDirector sharedDirector] replaceScene:scene];
}
@end



#pragma mark - Challenges menu
@implementation menuChallenges
-(id) init
{
    if( (self=[super init]) ) {
        
        // BACKGROUND
        background4 = [CCSprite spriteWithFile:@"seigmenn.jpg"];
        background4.position = ccp(160,240);
        [self addChild:background4 z:0];
        
        
        //CHECK LAST PLAYED MODE
        int playLastMode=0;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] != nil) { 
            playLastMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayLastMode"] intValue];
        }
        
        /*
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:GameMode forKey:@"kPlayLastMode"];
        [defaults synchronize];
        */
        
        //NSString *txtOn=NSLocalizedString(@"On", @"");
        //NSString *txtBack=NSLocalizedString(@"Back", @"");
               
        
        
        // Testing empty menu
		CCMenu *menu1 = [CCMenu node];
       // menu1.position=ccp(150,100);
        
		CGSize s = [[CCDirector sharedDirector] winSize];
		[menu1 setPosition:ccp(s.width/2, s.height/2)];
        
        NSString *fontname=@"American Typewriter";
		int fontSize=24;
        
        NSString *txtReturn=NSLocalizedString(@"Returntomain", @"");
        
        NSString *txtLevel=NSLocalizedString(@"Level", @"");
        
        int levelsUnlocked=0;
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] != nil) { 
            levelsUnlocked = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kLevelsUnlocked"] intValue];
        }
        CCLOG(@"Levels unlocked: %i",levelsUnlocked);
    
        
        //DEbug
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:0 forKey:@"kLevelsUnlocked"];
        [defaults synchronize];
        //STOP
        
        
		// Menu 1
		[CCMenuItemFont setFontName:fontname];
		[CCMenuItemFont setFontSize:fontSize];
		CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:txtReturn block:^(id sender) {
			[[CCDirector sharedDirector] replaceScene:[MainMenu node]];
		}];
        
		
        
        
        CCMenuItemFont *item3 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"1"] block:^(id sender) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:1 forKey:@"kPlayLastMode"];
            [defaults synchronize];

		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    	}];
        item3.color=ccc3(87,117,112);
        
        
            
        CCMenuItemFont *item4 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"2"] block:^(id sender) {
        if(levelsUnlocked<2){
                CCLOG(@"Level 2 is locked");
        } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:2 forKey:@"kPlayLastMode"];
            [defaults synchronize];
            
		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    	}
        }];
        if(levelsUnlocked<2){item4.color=ccc3(0,0,0);} else {item4.color=ccc3(87,117,112);}
            
        
            
            
        CCMenuItemFont *item5 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"3"] block:^(id sender) {
            if(levelsUnlocked<3){
                CCLOG(@"Level 3 is locked");
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:3 forKey:@"kPlayLastMode"];
                [defaults synchronize];
                
                [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<3){item5.color=ccc3(0,0,0);} else {item5.color=ccc3(87,117,112);}
        
        CCMenuItemFont *item6 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"4"] block:^(id sender) {
            if(levelsUnlocked<4){
                CCLOG(@"Level 4 is locked");
            } else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:4 forKey:@"kPlayLastMode"];
            [defaults synchronize];
            
		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<4){item6.color=ccc3(0,0,0);} else {item6.color=ccc3(87,117,112);}
        
        
        
        CCMenuItemFont *item7 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"5"] block:^(id sender) {
            if(levelsUnlocked<5){
                CCLOG(@"Level 5 is locked");
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:5 forKey:@"kPlayLastMode"];
            [defaults synchronize];
            
		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<5){item7.color=ccc3(0,0,0);} else {item7.color=ccc3(87,117,112);}
        
        
        
        CCMenuItemFont *item8 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"6"] block:^(id sender) {
            if(levelsUnlocked<6){
                CCLOG(@"Level 6 is locked");
            } else {
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:6 forKey:@"kPlayLastMode"];
            [defaults synchronize];
            
		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<6){item8.color=ccc3(0,0,0);} else {item8.color=ccc3(87,117,112);}
        
        
        CCMenuItemFont *item9 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"7"] block:^(id sender) {
            if(levelsUnlocked<7){
                CCLOG(@"Level 7 is locked");
            } else {
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:7 forKey:@"kPlayLastMode"];
            [defaults synchronize];
            
		    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<7){item9.color=ccc3(0,0,0);} else {item9.color=ccc3(87,117,112); }
        
        
        CCMenuItemFont *item10 = [CCMenuItemFont itemWithString:[[NSString alloc] initWithFormat:@"%@ %@",txtLevel,@"8"] block:^(id sender) {
            if(levelsUnlocked<8){
                CCLOG(@"Level 8 is locked");
            } else {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:7 forKey:@"kPlayLastMode"];
                [defaults synchronize];
                
                [[CCDirector sharedDirector] replaceScene:[GameScene node]];
            }
    	}];
        if(levelsUnlocked<8){item10.color=ccc3(0,0,0);} else {item10.color=ccc3(87,117,112); }
        
        
        item1.color=ccc3(0,0,0);
        
        [menu1 addChild:item3];
        [menu1 addChild:item4];
        [menu1 addChild:item5];
        [menu1 addChild:item6];
        [menu1 addChild:item7];
        [menu1 addChild:item8];
        [menu1 addChild:item9];
		[menu1 addChild:item10];
		[menu1 addChild:item1];
        
        
        [menu1 alignItemsVerticallyWithPadding:5 ];
        [self addChild:menu1 z:100];
        
        
        
        /*
        
        [CCMenuItemFont setFontName: @"American Typewriter"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItem *item1 = [CCMenuItem itemWithTarget:self selector:@selector(menuCallback2:)];
        item1.tag=1;
                
        
        
	    CCMenu *menu = [CCMenu menuWithItems:
                        item1,
                        
                        nil]; // 7 items.
		[menu alignItemsInColumns:
		 [NSNumber numberWithUnsignedInt:1],
		 nil
         ]; 
        
        
		CGSize s = [[CCDirector sharedDirector] winSize];
		[menu setPosition:ccp(s.width/2, s.height/2)];
        
        
        [self addChild:menu];   
         */
        /*
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setInteger:GameMode forKey:@"kPlayLastMode"];
         [defaults synchronize];
       */  
    }       
    return self;
}

- (void) dealloc
{
	
}

-(void) menuCallback: (id) sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[MainMenu node]];
	[[CCDirector sharedDirector] replaceScene:scene];
}

-(void) menuCallback2: (id) sender
{
    int identifier = [sender tag];
    NSLog(@"Label clicked with tag %i",identifier);
    
    
    BOOL playAudio=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] != nil) { 
        playAudio = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlayAudio"] intValue];
    }
    else {
        
    }
    
    BOOL playSoundFX=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] != nil) { 
        playSoundFX = [[[NSUserDefaults standardUserDefaults] objectForKey:@"kPlaySoundFX"] intValue];
    }
    else {
        
    }
    
    
    switch(identifier){
        case 1:
            //SOunDFX
            CCLOG(@"SOUNDFX is:%i",playSoundFX);
            if(playSoundFX){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:0 forKey:@"kPlaySoundFX"];
                [defaults synchronize];
                
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"kPlaySoundFX"];
                [defaults synchronize];
                
            }
            break;
            
        case 2:
            //AUDIO
            CCLOG(@"AUDIO is:%i",playAudio);
            if(playAudio){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:0 forKey:@"kPlayAudio"];
                [defaults synchronize];
                
            } else {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"kPlayAudio"];
                [defaults synchronize];
                
            }
            break;
            
    }
    
    
	disabledItem.isEnabled = ~disabledItem.isEnabled;
	[disabledItem stopAllActions];
}
-(void) backCallback: (id) sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[MainMenu node]];
	[[CCDirector sharedDirector] replaceScene:scene];
}
@end

#pragma mark - StartMenu

@implementation Layer2

-(void) alignMenusH
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsHorizontally];
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(0,30));
            
		} else {
			// TIP: but padding is configurable
			[menu alignItemsHorizontallyWithPadding:40];
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(0,30));
		}
	}
}

-(void) alignMenusV
{
	for(int i=0;i<2;i++) {
		CCMenu *menu = (CCMenu*)[self getChildByTag:100+i];
		menu.position = centeredMenu;
		if(i==0) {
			// TIP: if no padding, padding = 5
			[menu alignItemsVertically];
			CGPoint p = menu.position;
			menu.position = ccpAdd(p, ccp(100,0));
		} else {
			// TIP: but padding is configurable
			[menu alignItemsVerticallyWithPadding:40];
			CGPoint p = menu.position;
			menu.position = ccpSub(p, ccp(100,0));
		}
	}
}

-(id) init
{
	if( (self=[super init]) ) {
        
	}
    
	return self;
}

// Testing issue #1018 and #1021
-(void) onEnter
{
	[super onEnter];
    
	// remove previously added children
	[self removeAllChildrenWithCleanup:YES];
    
	for( int i=0;i < 2;i++ ) {
		CCMenuItemImage *item1 = [CCMenuItemImage itemWithNormalImage:@"btn-play-normal.png" selectedImage:@"btn-play-selected.png" target:self selector:@selector(menuCallbackBack:)];
		CCMenuItemImage *item2 = [CCMenuItemImage itemWithNormalImage:@"btn-highscores-normal.png" selectedImage:@"btn-highscores-selected.png" target:self selector:@selector(menuCallbackOpacity:)];
		CCMenuItemImage *item3 = [CCMenuItemImage itemWithNormalImage:@"btn-about-normal.png" selectedImage:@"btn-about-selected.png" target:self selector:@selector(menuCallbackAlign:)];
        
		item1.scaleX = 1.5f;
		item2.scaleY = 0.5f;
		item3.scaleX = 0.5f;
        
		CCMenu *menu = [CCMenu menuWithItems:item1, item2, item3, nil];
        
		CGSize s = [[CCDirector sharedDirector] winSize];
		[menu setPosition:ccp(s.width/2, s.height/2)];
        
		menu.tag = kTagMenu;
        
		[self addChild:menu z:0 tag:100+i];
		centeredMenu = menu.position;
	}
    
	alignedH = YES;
	[self alignMenusH];
}

-(void) dealloc
{
	
}

-(void) menuCallbackBack: (id) sender
{
	CCScene *scene = [CCScene node];
	[scene addChild:[MainMenu node]];
	[[CCDirector sharedDirector] replaceScene:scene];
}

-(void) menuCallbackOpacity: (id) sender
{
	CCMenu *menu = (CCMenu*) [sender parent];
	GLubyte opacity = [menu opacity];
	if( opacity == 128 )
		[menu setOpacity: 255];
	else
		[menu setOpacity: 128];
}

-(void) menuCallbackAlign: (id) sender
{
	alignedH = ! alignedH;
    
	if( alignedH )
		[self alignMenusH];
	else
		[self alignMenusV];
}


@end



#pragma mark - LayerPriorityTest

@implementation LayerPriorityTest

+(id) scene
{
	CCScene *scene = [CCScene node];
	LayerPriorityTest *layer = [LayerPriorityTest node];
	[scene addChild: layer];
	return scene;
}

-(void)buttonTapped:(id)sender
{
	NSLog(@"buttonTapped");
}

// create and initialize a UIView item with the wrapper
-(void)addUIViewItem
{
/*
 // create item programatically
	button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
	[button setTitle:@"Touch Me Touch Me Touch Me Touch Me Touch Me Touch Me Touch Me " forState:UIControlStateNormal];
	button.frame = CGRectMake(0.0, 0.0, 120.0, 40.0);
    
	// put a wrappar around it
	wrapper = [CCUIViewWrapper wrapperForUIView:button];
	[self addChild:wrapper];
*/
    
    /*
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10,60, 300,360)];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = @"I wanted to share a class I've written I'm calling CCUIWrapper, which acts as a way of manipulating UIViews via Cocos2D methods. It's not the most momumental class ever written and most of what it does is simple but a few of the pieces took a bit of tinkering and head scratching to put together. I'm sharing this because I think many people might find it very useful, and I'm inclined to believe that it should even be included as part of Cocos2D. UIViews can do many things that Cocos cannot, and the differences between the two systems make them very confusing to merge together. Hopefully this class simplifies the process for people. ";
    [textView setEditable:NO]; 
    
    //[[[CCDirector sharedDirector]view]addSubview:textView];
    wrapper = [CCUIViewWrapper wrapperForUIView:textView];
    wrapper.position = ccp(0,400);
    //[wrapper runAction:[CCRotateTo actionWithDuration:4.5 angle:180]];
    
    
    [self addChild:wrapper z:0];
    
    */
    
   /* 
    NSString *textc=@" wanted to share a class I've written I'm calling CCUIWrapper, which acts as a way of manipulating UIViews via Cocos2D methods. It's not the most momumental class ever written and most of what it does is simple but a few of the pieces took a bit of tinkering and head scratching to put together. I'm sharing this because I think many people might find it very useful, and I'm inclined to believe that it should even be included as part of Cocos2D. UIViews can do many things that Cocos cannot, and the differences between the two systems make them very confusing to merge together. Hopefully this class simplifies the process for people.";
    UILabel* length_label = [[UILabel alloc] init];
    length_label.text = @"Length: ";
    length_label.font = [UIFont systemFontOfSize:62.0f];
    
    UITextField *length_field	= [[UITextField alloc] init];
    length_field.text = [NSString stringWithFormat: @"%f",textc.length];
    length_field.font = [UIFont systemFontOfSize:62.0f];
    [length_field setBorderStyle:UITextBorderStyleRoundedRect];
    length_field.keyboardType = UIKeyboardTypeNumberPad;
 */
    
    NSString *text=@" wanted to share a class I've written I'm calling CCUIWrapper, which acts as a way of manipulating UIViews via Cocos2D methods. It's not the most momumental class ever written and most of what it does is simple but a few of the pieces took a bit of tinkering and head scratching to put together. I'm sharing this because I think many people might find it very useful, and I'm inclined to believe that it should even be included as part of Cocos2D. UIViews can do many things that Cocos cannot, and the differences between the two systems make them very confusing to merge together. Hopefully this class simplifies the process for people.";
    
    // self.contentSize.width is limiting the width of the label to this CCNode,
    // in my case it's a new layer of a specific width and height and i don't
    // want the text to go outside these demensions.
    CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"LCD" size:18.0f]
                       constrainedToSize:CGSizeMake(self.contentSize.width, CGFLOAT_MAX)
                           lineBreakMode:UILineBreakModeWordWrap];
    
    
    CCLabelTTF *textLabel;
    textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentLeft fontName:@"LCD" fontSize:18.0f];
    [self addChild: textLabel];
}

-(id) init
{
	if( (self = [super init] ) ) {
		
        [self addUIViewItem];
        
        
        // BACKGROUND
        background4 = [CCSprite spriteWithFile:@"seigmenn.jpg"];
        background4.position = ccp(160,240);
        [self addChild:background4 z:0];
       
        
        // Testing empty menu
		CCMenu *menu1 = [CCMenu node];
        menu1.position=ccp(150,100);
        
		
		// Menu 1
		[CCMenuItemFont setFontName:@"LCD"];
		[CCMenuItemFont setFontSize:18];
		CCMenuItemFont *item1 = [CCMenuItemFont itemWithString:@"Return to Main Menu" block:^(id sender) {
			[[CCDirector sharedDirector] popScene];
		}];
        
		CCMenuItemFont *item2 = [CCMenuItemFont itemWithString:@"Disable menu for 5 seconds" block:^(id sender) {
			[menu1 setEnabled:NO];
			CCDelayTime *wait = [CCDelayTime actionWithDuration:5];
			CCCallBlockO *enable = [CCCallBlockO actionWithBlock:^(id object) {
				[object setEnabled:YES];
			}object:menu1];
			CCSequence *seq = [CCSequence actions:wait, enable, nil];
			[menu1 runAction:seq];
		}];
        
        
        NSString *text=@"I wanted to share a class I've written I'm calling CCUIWrapper, which acts as a way of manipulating UIViews via Cocos2D methods. It's not the most momumental class ever written and most of what it does is simple but a few of the pieces took a bit of tinkering and head scratching to put together. I'm sharing this because I think many people might find it very useful, and I'm inclined to believe that it should even be included as part of Cocos2D. UIViews can do many things that Cocos cannot, and the differences between the two systems make them very confusing to merge together. Hopefully this class simplifies the process for people.";
        
        // self.contentSize.width is limiting the width of the label to this CCNode,
        // in my case it's a new layer of a specific width and height and i don't
        // want the text to go outside these demensions.
        CGSize textSize = [text sizeWithFont:[UIFont fontWithName:@"LCD" size:16.0f]
                           constrainedToSize:CGSizeMake(self.contentSize.width-20, CGFLOAT_MAX)
                               lineBreakMode:UILineBreakModeWordWrap];
        
        
        CCLabelTTF *textLabel;
        textLabel= [CCLabelTTF labelWithString:text dimensions:textSize hAlignment:UITextAlignmentCenter 
                                      fontName:@"LCD" fontSize:16.0f];
        CCLOG(@"textsize w%2.0f h%2.0f",textSize.width,textSize.height);
        textLabel.position=ccp((textSize.width/2)+10,textSize.height);
        //textLabel.position=ccpFromSize(textSize);
        textLabel.color=ccc3(0,0,0);
        [self addChild: textLabel];
        
		
        item1.color=ccc3(0,0,0);
        item2.color=ccc3(0,0,0);
        
		[menu1 addChild:item1];
        [menu1 addChild:item2];
        
        [menu1 alignItemsVerticallyWithPadding:2  ];
        [self addChild:menu1 z:100];

        
        
        
	}
	
	return self;
}



-(void)makestuff:(CGContextRef)context
{

    // Drawing lines with a white stroke color
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 2.0);
    
    // Draw a single line from left to right
    CGContextMoveToPoint(context, 10.0, 30.0);
    CGContextAddLineToPoint(context, 310.0, 30.0);
    CGContextStrokePath(context);
    
    // Draw a connected sequence of line segments
    CGPoint addLines[] =
    {
        CGPointMake(10.0, 90.0),
        CGPointMake(70.0, 60.0),
        CGPointMake(130.0, 90.0),
        CGPointMake(190.0, 60.0),
        CGPointMake(250.0, 90.0),
        CGPointMake(310.0, 60.0),
    };
    // Bulk call to add lines to the current path.
    // Equivalent to MoveToPoint(points[0]); for(i=1; i<count; ++i) AddLineToPoint(points[i]);
    CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextStrokePath(context);
    
    // Draw a series of line segments. Each pair of points is a segment
    CGPoint strokeSegments[] =
    {
        CGPointMake(10.0, 150.0),
        CGPointMake(70.0, 120.0),
        CGPointMake(130.0, 150.0),
        CGPointMake(190.0, 120.0),
        CGPointMake(250.0, 150.0),
        CGPointMake(310.0, 120.0),
    };
    // Bulk call to stroke a sequence of line segments.
    // Equivalent to for(i=0; i<count; i+=2) { MoveToPoint(point[i]); AddLineToPoint(point[i+1]); StrokePath(); }
    CGContextStrokeLineSegments(context, strokeSegments, sizeof(strokeSegments)/sizeof(strokeSegments[0]));
}


- (void) dealloc
{
	
}

@end



