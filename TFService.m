//
//  TFService.m
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import "TFService.h"
#import "NSObject+BlockObservation.h"

@interface TFService ()
@property(retain) NSNetService *netService;
@end



@implementation TFService
@synthesize published, name, type, port, netService, TXTRecords;


- (id)init {
	self = [super init];
	
	self.name = @"";
	self.type = @"_foo._tcp";
	self.port = 9;
	self.TXTRecords = [NSDictionary dictionary];
	
	observationTokens = [[NSMutableSet alloc] init];
	
	NSSet *keys = [NSSet setWithObjects:@"name", @"type", @"port", nil];
	for(NSString *key in keys) {
		[observationTokens addObject:[self addObserverForKeyPath:key task:^(NSDictionary *change) {
			if(published) {
				self.published = NO;
				self.published = YES;
			}
		}]];
	}
	
	return self;
}


- (void)dealloc {
	[netService stop];
	[netService release];
	
	[name release];
	[type release];
	[TXTRecords release];
	for(id token in observationTokens)
		[self removeObserverWithBlockToken:token];
	[observationTokens release];
	
	[super dealloc];
}


- (void)setPublished:(BOOL)p {
	if(published && !p) {
		[netService stop];
		self.netService = nil;
	
	}else if(!published && p) {
		self.netService = [[[NSNetService alloc] initWithDomain:@"" type:type name:name port:port] autorelease];
		[netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:TXTRecords]];
		[netService setDelegate:self];
		[netService publish];
	}
	
	published = (netService != nil);
}


// The management of "published" is a little odd. Fix.


- (void)netServiceDidPublish:(NSNetService *)sender {
	[self willChangeValueForKey:@"published"];
	published = YES;
	[self didChangeValueForKey:@"published"];
}


- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
	NSLog(@"%@ failed to publish: %@", self, errorDict);
	[self willChangeValueForKey:@"published"];
	published = NO;
	[self didChangeValueForKey:@"published"];
}


- (void)setTXTRecords:(NSDictionary*)records {
	[TXTRecords autorelease];
	TXTRecords = [records copy];
	
	if(netService)
		[netService setTXTRecordData:[NSNetService dataFromTXTRecordDictionary:TXTRecords]];
}



@end
