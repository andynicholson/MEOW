#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "SafeFetchedResultsController.h"

@interface ContactsViewController : UITableViewController <NSFetchedResultsControllerDelegate, SafeFetchedResultsControllerDelegate>
{
	SafeFetchedResultsController *fetchedResultsController;
}

- (void)controllerDidMakeUnsafeChanges:(NSFetchedResultsController *)controller;

@end
