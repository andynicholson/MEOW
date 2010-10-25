//
//  ContactsViewController.h
//  MEOW-iphone
//
//  Created by andycat on 24/10/10.
//  Copyright 2010 Infinite Recursion Pty Ltd. All rights reserved.
//
//  Taken from xmpp-framework example
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SafeFetchedResultsController.h"

@interface ContactsViewController : UITableViewController <NSFetchedResultsControllerDelegate, SafeFetchedResultsControllerDelegate>
{
	SafeFetchedResultsController *fetchedResultsController;
	UINavigationController *navController;
}

@property (nonatomic, retain) UINavigationController *navController;

- (void)controllerDidMakeUnsafeChanges:(NSFetchedResultsController *)controller;
//- (void) doContactMessagingToXMPPUser:(XMPPUserCoreDataStorage *)xmppuser

@end
