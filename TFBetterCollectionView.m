//
//  TFBetterCollectionView.m
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import "TFBetterCollectionView.h"


@implementation TFBetterCollectionView
@synthesize itemProvider;

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
	return [[itemProvider collectionView:self itemForRepresentedObject:object] retain]; // new* method; assert ownership
}

@end
