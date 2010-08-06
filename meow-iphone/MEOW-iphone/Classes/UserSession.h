//
// UserSession.h
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalogEntry.h"

@interface UserSession : NSObject {
  @private
	NSMutableArray* entries_;
	NSMutableData* json_;
	NSURLConnection* connection_;
	BOOL loaded_;
}

@property (nonatomic,readonly) NSArray* entries;
@property (nonatomic,readonly) BOOL loaded;

+ (id) sharedUserSession;

- (void) reload;
- (NSArray*) searchWithQuery: (NSString*) query;
- (CatalogEntry*) entryWithTitle: (NSString*) title;

@end