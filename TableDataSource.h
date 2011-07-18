
#import <UIKit/UIKit.h>

@interface TableDataSource : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray*			dataSource;	//array of NSDictionaries, each of which represents a location on a route
	UITableView*			table;
	UIBarButtonItem*		editBtn;
}

@property (nonatomic, retain)			Route*					currentRoute;
@property (nonatomic, retain) IBOutlet	UITableView*			table;
@property (nonatomic, retain) IBOutlet	UIBarButtonItem*		editBtn;

- (IBAction)toggleEditTable;

- (void)clearOldPath;

@end
