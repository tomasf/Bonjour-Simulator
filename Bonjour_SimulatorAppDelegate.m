//
//  Bonjour_SimulatorAppDelegate.m
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import "Bonjour_SimulatorAppDelegate.h"
#import "TFService.h"


@implementation Bonjour_SimulatorAppDelegate
@synthesize window;

- (id)init {
	self = [super init];
	services = [[NSMutableArray alloc] init];
	return self;
}


- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	[collectionView setMinItemSize:NSMakeSize(500, 194)];
	[collectionView setMaxItemSize:NSMakeSize(FLT_MAX, 194)];
}


- (IBAction)addService:(id)sender {
	TFService *service = [[[TFService alloc] init] autorelease];
	[[self mutableArrayValueForKey:@"services"] addObject:service];
}


- (NSCollectionViewItem*)collectionView:(NSCollectionView *)collectionView itemForRepresentedObject:(id)object {
	NSCollectionViewItem *item = [[[NSCollectionViewItem alloc] initWithNibName:@"TFServiceView" bundle:nil] autorelease];
	[item setRepresentedObject:object];
	return item;
}


- (void)deleteService:(id)sender {
	for(int i=0; i<[services count]; i++) {
		NSCollectionViewItem *item = [collectionView itemAtIndex:i];
		if([sender isDescendantOf:[item view]])
			[[self mutableArrayValueForKey:@"services"] removeObject:[item representedObject]];
	}
}


@end
