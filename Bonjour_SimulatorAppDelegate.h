//
//  Bonjour_SimulatorAppDelegate.h
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TFBetterCollectionView.h"

@interface Bonjour_SimulatorAppDelegate : NSObject <NSApplicationDelegate, TFBetterCollectionViewItemProvider> {
    NSWindow *window;
	NSMutableArray *services;
	IBOutlet NSCollectionView *collectionView;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)deleteService:(id)service;
- (IBAction)addService:(id)sender;
@end
