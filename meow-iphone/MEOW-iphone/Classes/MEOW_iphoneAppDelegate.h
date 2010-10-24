//
//  MEOW_iphoneAppDelegate.h
//  MEOW-iphone
//
//  Created by andycat on 3/08/10.
//  Copyright Infinite Recursion Pty Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "XMPPRoom.h"
#import "XMPPRoster.h"

#define SERVICE_URL @"http://meow.infiniterecursion.com.au/json/"

#define kKeyboardAnimationDuration 0.3

@class HomeViewController;
//XMPP classes

@class XMPPStream;
@class XMPPRoster;
@class XMPPRosterCoreDataStorage;


@interface MEOW_iphoneAppDelegate : NSObject <UIApplicationDelegate, XMPPRoomDelegate, XMPPRosterDelegate, UIAlertViewDelegate> {
    UIWindow *window;
    
	IBOutlet UINavigationController*  myNavigationController;

	//XMPP
	XMPPStream *xmppStream;
	XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	//XMPP stream state isOpen
	BOOL xmppStateIsOpen;
	//States for XMPP for next step in streamDidConnect
	BOOL xmppStateIsLoginNext, xmppStateIsRegisterNext;
	
	//Last user to contact us
	XMPPJID *xmpp_jid_last_contact;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController*  myNavigationController;

@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, retain) XMPPJID *xmpp_jid_last_contact;


-(void) xmppInit;
-(void) registerXMPPWithUsername:(NSString *)init_username andPassword:(NSString *)init_password;
-(void) xmppLogout;

@end

