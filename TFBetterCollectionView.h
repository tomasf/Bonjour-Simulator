//
//  TFBetterCollectionView.h
//  Bonjour Simulator
//
//  Created by Tomas Franzén on 2010-08-17.
//  Copyright 2010 Lighthead Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol TFBetterCollectionViewItemProvider
- (NSCollectionViewItem*)collectionView:(NSCollectionView*)collectionView itemForRepresentedObject:(id)object;
@end



@interface TFBetterCollectionView : NSCollectionView {
	id<TFBetterCollectionViewItemProvider> itemProvider;
}

@property(assign) IBOutlet id<TFBetterCollectionViewItemProvider> itemProvider;

@end
