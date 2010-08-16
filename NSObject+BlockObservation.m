//
//  NSObject+BlockObservation.h
//  Version 1.0
//
//  Andy Matuschak
//  andy@andymatuschak.org
//  Public domain because I love you. Let me know how you use it.
//

#import "NSObject+BlockObservation.h"
#import <dispatch/dispatch.h>
#import <objc/runtime.h>

@interface AMObserverTrampoline : NSObject
{
    __weak id observee;
    NSString *keyPath;
    void(^task)(NSDictionary *change);
    NSOperationQueue *queue;
}

- (AMObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options onQueue:(NSOperationQueue *)queue task:(void(^)(NSDictionary *change))task;
- (void)cancelObservation;
@end

@implementation AMObserverTrampoline

static NSString *AMObserverTrampolineContext = @"AMObserverTrampolineContext";

- (AMObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)newKeyPath options:(NSKeyValueObservingOptions)options onQueue:(NSOperationQueue *)newQueue task:(void(^)(NSDictionary *change))newTask
{
    if (!(self = [super init])) return nil;
    task = [newTask copy];
    keyPath = [newKeyPath copy];
    queue = [newQueue retain];
    observee = obj;
    [observee addObserver:self forKeyPath:keyPath options:options context:AMObserverTrampolineContext];   
    return self;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == AMObserverTrampolineContext)
    {
        if (queue)
            [queue addOperationWithBlock:^{ task(change); }];
        else
            task(change);
    }
    else
    {
        [super observeValueForKeyPath:aKeyPath ofObject:object change:change context:context];
    }
}

- (void)cancelObservation
{
    [observee removeObserver:self forKeyPath:keyPath];
    observee = nil;
}

- (void)dealloc
{
    if (observee)
        [self cancelObservation];
    [task release];
    [keyPath release];
    [queue release];
    [super dealloc];
}

@end

static NSString *AMObserverMapKey = @"org.andymatuschak.observerMap";

@implementation NSObject (AMBlockObservation)

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath task:(void(^)(NSDictionary *change))task
{
    return [self addObserverForKeyPath:keyPath options:0 onQueue:nil task:task];
}

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options task:(void(^)(NSDictionary *change))task
{
    return [self addObserverForKeyPath:keyPath options:options onQueue:nil task:task];
}

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(void(^)(NSDictionary *change))task
{
    return [self addObserverForKeyPath:keyPath options:0 onQueue:queue task:task];
}

- (AMBlockToken *)addObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options onQueue:(NSOperationQueue *)queue task:(void(^)(NSDictionary *change))task;
{
    AMBlockToken *token = [[NSProcessInfo processInfo] globallyUniqueString];
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (!objc_getAssociatedObject(self, AMObserverMapKey))
            objc_setAssociatedObject(self, AMObserverMapKey, [NSMutableDictionary dictionary], OBJC_ASSOCIATION_RETAIN);
        AMObserverTrampoline *trampoline = [[[AMObserverTrampoline alloc] initObservingObject:self keyPath:keyPath options:options onQueue:queue task:task] autorelease];
        [objc_getAssociatedObject(self, AMObserverMapKey) setObject:trampoline forKey:token];
    });
    return token;
}

- (void)removeObserverWithBlockToken:(AMBlockToken *)token
{
    NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, AMObserverMapKey);
    AMObserverTrampoline *trampoline = [observationDictionary objectForKey:token];
    if (!trampoline)
    {
        NSLog(@"Tried to remove non-existent observer on %@ for token %@", self, token);
        return;
    }
    [trampoline cancelObservation];
    [observationDictionary removeObjectForKey:token];
}

@end
