//
//  TFService.h
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TFService : NSObject <NSNetServiceDelegate> {
	BOOL published;
	
	NSString *name;
	NSString *type;
	uint16_t port;
	NSDictionary *TXTRecords;
	
	NSNetService *netService;
	NSMutableSet *observationTokens;
}

@property(getter=isPublished) BOOL published;
@property(copy) NSString *name;
@property(copy) NSString *type;
@property uint16_t port;
@property(copy) NSDictionary *TXTRecords;

@end
