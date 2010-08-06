//
//  UserSession.m
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010.. All rights reserved.
//

#import "CatalogEntry.h"
#import "UserSession.h"



#define BASE_URL @"http://meow.infiniterecursion.com.au/json/"

#pragma mark -

static NSInteger SortCatalogEntriesByTitle(CatalogEntry* a, CatalogEntry* b, void* context)
{
	return [a.title compare: b.title];
}

@implementation UserSession

#pragma mark -

@synthesize entries = entries_;
@synthesize loaded = loaded_;

#pragma mark -

static UserSession* sUserSession = nil;

+ (id) sharedUserSession
{
	@synchronized (self) {
		if (sUserSession == nil) {
			sUserSession = [UserSession new];
		}
	}
	return sUserSession;
}

#pragma mark -

- (id) init
{
	if ((self = [super init]) != nil) {
		entries_ = [NSMutableArray new];
		json_ = [NSMutableData new];
	}
	return self;
}

- (void) dealloc
{
	[connection_ release];
	[entries_ release];
	[json_ release];
	[super dealloc];
}

#pragma mark -

- (void) reload
{
	NSLog(@"About to start to login into MEOW middleware ...");
	if (connection_ == nil)
	{
		NSLog(@"Connection is nil - so really about to start connection ...");	
		
		
		
		
		
		NSURLRequest* request = [NSURLRequest requestWithURL: [NSURL URLWithString:BASE_URL ]
			cachePolicy: NSURLRequestReloadIgnoringLocalCacheData timeoutInterval: 30.0];
		
		connection_ = [[NSURLConnection connectionWithRequest: request delegate: self] retain];
	}
}

- (NSArray*) searchWithQuery: (NSString*) query
{
	return [NSArray array];
}

- (CatalogEntry*) entryWithTitle: (NSString*) title
{
	for (CatalogEntry* entry in entries_) {
		if ([entry.title isEqualToString: title] == YES) {
			return entry;
		}
	}
	return nil;
}

#pragma mark -

- (void) connection: (NSURLConnection*) connection didFailWithError: (NSError*) error
{
	[connection_ release];
	connection_ = nil;
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection
{
	// Parse the JSON and store it into the Catalog
	
	NSLog(@"Reloading Catalog data");
	
	NSString* json = [[[NSString alloc] initWithData: json_ encoding: NSUTF8StringEncoding] autorelease];
	NSArray* entries = [json JSONValue];

	[entries_ removeAllObjects];

	for (NSDictionary* dictionary in entries)
	{
		CatalogEntry* entry = [[CatalogEntry new] autorelease];
		if (entry != nil)
		{
			entry.title = [dictionary objectForKey: @"title"];
			entry.author = [dictionary objectForKey: @"author"];
			entry.url = [NSURL URLWithString: [dictionary objectForKey: @"url"]];
			
			[entries_ addObject: entry];
		}
	}
	
	// Sort the books by title
	
	[entries_ sortUsingFunction: SortCatalogEntriesByTitle context: nil];
	
	// Let others know that the catalog reloaded
	
	loaded_ = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName: @"CatalogReloaded" object: nil];
	
	// Release everything

	[connection_ release];
	connection_ = nil;
}

- (void) connection: (NSURLConnection*) connection didReceiveResponse: (NSURLResponse*) response
{
	[json_ setLength: 0];
}

- (void) connection: (NSURLConnection*) connection didReceiveData: (NSData*) data
{
    [json_ appendData: data];
}

@end