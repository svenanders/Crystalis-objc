//
//  AppDelegate.h
//  crystalwiper
//
//  Created by Sven Anders Robbestad on 08.05.12.
//  Copyright SOL 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "AdViewController.h"

@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;
	//UINavigationController	*viewController;
    AdViewController *adView;
    
	CCDirectorIOS	*director_;							// weak ref
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (readonly) CCDirectorIOS *director;



-(float)getAdHeight;
-(void)hideBanner;
-(void)showBanner;


@end
