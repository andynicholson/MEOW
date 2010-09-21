#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ContactsViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
	NSFetchedResultsController *fetchedResultsController;
}

@end
