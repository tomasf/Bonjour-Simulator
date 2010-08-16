//
//  NSObject+BlockObservation.h
//  Version 1.0
//
//  Andy Matuschak
//  andy@andymatuschak.org
//  Public domain because I love you. Let me know how you use it.
//

typedef NSString AMBlockToken;

@interface NSObject (AMBlockObservation)

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath
                                   task:(void(^)(NSDictionary *change))task;

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath
                                options:(NSKeyValueObservingOptions)options
                                   task:(void(^)(NSDictionary *change))task;

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath
                                onQueue:(NSOperationQueue *)queue
                                   task:(void(^)(NSDictionary *change))task;

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath
                                options:(NSKeyValueObservingOptions)options
                                onQueue:(NSOperationQueue *)queue
                                   task:(void(^)(NSDictionary *change))task;

- (void)removeObserverWithBlockToken:(AMBlockToken *)token;
@end
