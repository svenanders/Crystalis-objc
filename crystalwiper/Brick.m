// Brick.m


#import "Brick.h"

@interface Brick (private)

- (void) initializeDefaultValues;
- (void) redrawPositionOnBoard;

@end

@implementation Brick

@synthesize brickType;
@synthesize boardX;
@synthesize boardY;
@synthesize disappearing;

+ (Brick *) newBrick:(int)difficultyLevel {
    
	NSString *filename = nil, *color = nil;
	Brick *temp = nil;
    int brickType;
   // CCLOG(@"*** DIFFICULTYLEVEL %i",difficultyLevel);
	brickType = random() % (3+difficultyLevel);
   // CCLOG(@"*** brickType %i",brickType);
	
    switch (difficultyLevel) {
        case 0:
        case 1:
            brickType = random() % (2+difficultyLevel);
            
            break;
        case 2:
            if(brickType<1) brickType++;
            break;
       
        case 3:
            if(brickType<2) brickType++;
            break;
        
        case 4:
            if(brickType<3) brickType++;
            break;
            
        default:
            break;
    }
    if(brickType>5) brickType=5;
    
    //if((random()%2)==1) brickType=6;
    //else brickType=7;
    
    
    switch (brickType) {
		default:
			color = [NSString stringWithFormat:@"krystall_%i",brickType];
			break;
	}

    
	if (color) {
		filename = 
			[[NSString alloc] 
			 initWithFormat:@"%@.png", color];
		temp = [self spriteWithFile:filename];
		
		[temp initializeDefaultValues];
		[temp  setBrickType: brickType];
	}
	return temp;
}

- (void) initializeDefaultValues {
	[self setAnchorPoint: ccp(0,0)];
	[self setPosition: ccp(0,0)];
//	[self setOpacity: 255]; //skal være 255
	[self setDisappearing: NO];
	[self setBoardX: 0];
	[self setBoardY: 0];
}

- (void) redrawPositionOnBoard {
	[self setPosition: COMPUTE_X_Y(boardX, boardY)];
}



- (void) moveDown {
	boardY += 1;
	[self redrawPositionOnBoard];
}


@end