//
//  MEOW_iphoneAppDelegate.m
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010.. All rights reserved.
//


#import "MEOW_iphoneAppDelegate.h"
#import "HomeViewController.h"
#import "MEOW_UserState.h"


#import "XMPP.h"
#import "XMPPRoom.h"
#import "XMPPRosterCoreDataStorage.h"

#import <CFNetwork/CFNetwork.h>


@implementation MEOW_iphoneAppDelegate

@synthesize window;
@synthesize myNavigationController;


@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;




#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

	
    // Add the view controller's view to the window and display.
    [window addSubview:myNavigationController.view];
	
    [window makeKeyAndVisible];

	
	//User starts logged off, obviously
	[[MEOW_UserState sharedMEOW_UserState] setLogged_in:FALSE];
	
	xmppStateIsOpen = FALSE;
	xmppStateIsLoginNext = FALSE;
	xmppStateIsRegisterNext = FALSE;
	
    return YES;
}

// This function is designed to register the user with the XMPP server
// as such, it would be run *before* xmppInit
// since we havent logged in yet. (we just registered with MEOW middleware)

-(void) registerXMPPWithUsername:(NSString *)init_username andPassword:(NSString *)init_password;{
		
	xmppStream = [[XMPPStream alloc] init];
	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
	xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
		
	[xmppStream addDelegate:self];
	[xmppRoster addDelegate:self];
	
	[xmppRoster setAutoRoster:YES];
		
	//on stream connect, try to register with the XMPP server
	xmppStateIsRegisterNext = TRUE;	
	
	
	//Our OpenFire XMPP server details, normally
	// We can leave blank to force SRV record lookup.
	[xmppStream setHostName:@""];
	[xmppStream setHostPort:5222];

	NSString *userJID = [NSString stringWithFormat:@"%@@meow.infiniterecursion.com.au/MEOWiOS" , init_username];
	[xmppStream setMyJID:[XMPPJID jidWithString:userJID]];	

	password = init_password;
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
	
	NSError *error = nil;
	if (![xmppStream connect:&error])
	{
		NSLog(@"Error connecting in registerXMPPWithUsername:andPassword:\nError is %@", error);
	}
	
	}


-(void) xmppInit {
	
	//possibly had register above called already
	// or somebody may have logged out as one user, and then logged back in again.
	if (xmppStream == nil) {
		
		xmppStream = [[XMPPStream alloc] init];
		xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
		xmppRoster = [[XMPPRoster alloc] initWithStream:xmppStream rosterStorage:xmppRosterStorage];
	
		[xmppStream addDelegate:self];
		[xmppRoster addDelegate:self];
		
		[xmppRoster setAutoRoster:YES];
		
	}
	//On stream connect, try to auth
	xmppStateIsLoginNext = TRUE;
	
	
	// The example below is setup for a typical google talk account.
	//[xmppStream setHostName:@"talk.google.com"];
	
	
	
	//Our OpenFire XMPP server details, normally
	// We can leave blank to force SRV record lookup.
	[xmppStream setHostName:@""];
	[xmppStream setHostPort:5222];
	
	// Use specialised JIDs for our OpenFire XMPP server 
	NSString *userJID = [NSString stringWithFormat:@"%@@meow.infiniterecursion.com.au/MEOWiOS" , [MEOW_UserState sharedMEOW_UserState].username];
	[xmppStream setMyJID:[XMPPJID jidWithString:userJID]];
	password = [MEOW_UserState sharedMEOW_UserState].password;
	
	NSLog(@" Logging into XMPP with userJID %@ , password %@" , userJID, password);
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
	
	// Check its not already connected before connecting.
	// If it isnt connected, we try to connect, and login after the stream connected event
	NSError *error = nil;
	if (!xmppStateIsOpen && ![xmppStream connect:&error]) {
		NSLog(@"Error connecting in xmppInit:\nError is %@", error);
	}
	// If its already connected, try to authenticate now.
	if (xmppStateIsOpen) {
		
		NSLog(@"---------- Authenticating with XMPP Server : ----------");
		if (![[self xmppStream] authenticateWithPassword:password error:&error])
		{
			NSLog(@"Error authenticating: %@", error);
		}

		
	}
	
}



-(void) xmppLogout {
	
	[self goOffline];
	
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppStream disconnect];
	[xmppStream release];
	[xmppRoster release];
	
	xmppStream = nil;
	
	xmppStateIsOpen = FALSE;
	
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
	[self goOffline];
	
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];
	
	[xmppStream disconnect];
	[xmppStream release];
	[xmppRoster release];
	
	[password release];
	
	
	
    [window release];
    [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////




// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
// 
// In addition to this, the NSXMLElementAdditions class provides some very handy methods for working with XMPP.
// 
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
// 
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence]; 
	
	NSLog(@" ONLINE! " );
	
	[self joinDefaultRoom];
	
	[self addDefaultBuddy];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] synchronouslySendElement:presence];
	 
	NSLog(@" OFFLINE! " );
}


-(void) joinDefaultRoom {
	
	
	XMPPRoom *defaultroom = [[XMPPRoom alloc] initWithStream:[self xmppStream] roomName:@"chatone@conference.meow.infiniterecursion.com.au" nickName:[MEOW_UserState sharedMEOW_UserState].username];
	
	[defaultroom setDelegate:self];
	
	[defaultroom joinRoom];
	
}


-(void) addDefaultBuddy {
	
	XMPPJID *godjid = [XMPPJID jidWithString:@"aleph2@meow.infiniterecursion.com.au"];
		
	[[self xmppRoster] addBuddy:godjid withNickname:@"GOD-aleph2"];
	
	XMPPJID *god2jid = [XMPPJID jidWithString:@"intothemist@gmail.com/HOME"];
	
	[[self xmppRoster] addBuddy:god2jid withNickname:@"intothemist"];
	
	XMPPJID *god3jid = [XMPPJID jidWithString:@"zanny.b@gmail.com/HOME"];
	
	[[self xmppRoster] addBuddy:god3jid withNickname:@"noddle"];
	
	
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	NSLog(@"---------- xmppStream:willSecureWithSettings: ----------");
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidSecure: ----------");
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidConnect: ----------");
	
	xmppStateIsOpen = YES;
	NSError *error = nil;
	
	if (xmppStateIsLoginNext) {
		NSLog(@"---------- Authenticating with XMPP Server : ----------");
		if (![[self xmppStream] authenticateWithPassword:password error:&error])
		{
			NSLog(@"Error authenticating: %@", error);
		}
		xmppStateIsLoginNext = FALSE;
	}

	if (xmppStateIsRegisterNext) {
		
		NSLog(@" Registering into XMPP with userJID %@ , password %@" , [[xmppStream myJID] full], password);
		NSError *error2 = nil;
		[xmppStream registerWithPassword:password error:&error2];
	
		xmppStateIsRegisterNext = FALSE;
	}
	
	
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidAuthenticate: ----------");
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	NSLog(@"---------- xmppStream:didNotAuthenticate: ----------");
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	NSLog(@"---------- xmppStream:didReceiveIQ: ----------");
	
	NSLog(@" Iq is %@", iq);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	NSLog(@"---------- xmppStream:didReceiveMessage: ---------- \n %@" , message);
	
	
	NSString *type = [[message attributeForName:@"type"] stringValue];
	
	//could be broadcast message, with no "to"
	if ([message isChatMessageWithBody] || [type length] == 0 ) {
		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *from = [message fromStr];
		
		NSString *msg = [NSString stringWithFormat:@"%@ from %@", body, from];
		
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];
		
	}

	if ([type isEqualToString:@"groupchat"]) {
		NSString *subj = [[message elementForName:@"subject"] stringValue];
		NSString *from = [message fromStr];
		
		NSString *msg = [NSString stringWithFormat:@"%@ from %@", subj, from];
		
		UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"Message" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:NULL];
		[alertview show];
		[alertview release];
		
	}
	
	
}




- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	NSLog(@"---------- xmppStream:didReceivePresence: ----------");
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	NSLog(@"---------- xmppStream:didReceiveError: ----------");
	NSLog(@" error is %@ ", error);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender
{
	NSLog(@"---------- xmppStreamDidDisconnect: ----------");
	
	if (!xmppStateIsOpen)
	{
		NSLog(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

//XMPPRoom delegate methods

- (void)xmppRoom:(XMPPRoom *)room didCreate:(BOOL)success {
	 
	 
 }

- (void)xmppRoom:(XMPPRoom *)room didEnter:(BOOL)enter {
	
	NSLog(@"Entered room %@  success ? %d ", [room roomName], enter);
	
}

- (void)xmppRoom:(XMPPRoom *)room didLeave:(BOOL)leave {
	
}


- (void)xmppRoom:(XMPPRoom *)room didReceiveMessage:(NSString *)message fromNick:(NSString *)nick {
	
	NSLog(@"RECV room  %@  message %@ from nick %@ ", [room roomName], message, nick);
}

- (void)xmppRoom:(XMPPRoom *)room didChangeOccupants:(NSDictionary *)occupants {
	
	
}



@end
