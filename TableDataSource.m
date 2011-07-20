#import "CustomCell.h"
#import "TableDataSource.h"


@implementation TableDataSource


@synthesize	dataSource;
@synthesize	table;
@synthesize	editBtn;


NSInteger	selectedIndex;
NSIndexPath*	oldPath;
NSAlert*	googleRouteAlert;
NSAlert*	prevLocationAlert;

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{	
	if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
		[dataSource removeObjectAtIndex:indexPath.row];
		[table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}




- (IBAction)toggleEditTable
{			
	if (table.editing) 
	{
		[table setEditing:NO animated:YES];
		[editBtn setTitle:@"Edit"];
		[editBtn setStyle:UIBarButtonItemStylePlain];
	} 
	else 
	{
		[table setEditing:YES animated:YES];
		[editBtn setTitle:@"Done"];
		[editBtn setStyle:UIBarButtonItemStyleDone];
	}
}




- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}




- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
	id tableItem = [[dataSource objectAtIndex:fromIndexPath.row] retain];
	
	[dataSource removeObjectAtIndex:fromIndexPath.row];
	[dataSource insertObject:tableItem atIndex:toIndexPath.row];
	
	[tableItem release];
}




- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	//allow user to swipe to delete
	return YES;
}




#pragma mark -
#pragma mark UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	selectedIndex = indexPath.row;
	
	[table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
	
	if (oldPath && (oldPath.row != indexPath.row))
	{
		[table reloadRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, oldPath, nil] withRowAnimation:UITableViewRowAnimationNone];
		
		[oldPath release];
		
		oldPath = nil;
	}
	else
	{
		[table reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
	
	oldPath = [indexPath retain];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [dataSource count];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString*	shortCell	= @"short";
	static NSString*	tallCell	= @"tall";
	NSString*		cellID		= (indexPath.row == selectedIndex) ? tallCell : shortCell;
	CustomCell*		cell		= (CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    
	if (cell == nil)	
	{
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	}
	
    
    // Configure the cell...
	NSDictionary*	routeItem	= [dataSource objectAtIndex:indexPath.row];	
	NSString*	cellValue	= (NSString*)[routeItem objectForKey:@"name"];	
	
	[routeItem setValue:[NSString stringWithFormat:@"%d", (indexPath.row + 1)] forKey:@"routeStep"];
	
	[cell setText:cellValue];
	
	[cell setCurrentButtonPressed:^()
					{
						selectedLocation = indexPath.row;
						
						googleRouteAlert = [[[UIAlertView alloc]	initWithTitle:@"Navigate" 
												message:@"Open directions to this location in Google Maps?" 
												delegate:self 
												cancelButtonTitle:@"Cancel" 
												otherButtonTitles:nil]
									autorelease];
									 
						 //add a Yes button
						[googleRouteAlert addButtonWithTitle:@"Yes"];
									 
						[googleRouteAlert show];
					}];
	
	
	[cell setPreviousButtonPressed:^()
					{
						if (selectedIndex > 0)
						{
							selectedLocation	= indexPath.row;

							prevLocationAlert	= [[[UIAlertView alloc]	initWithTitle:@"Navigate" 
													message:@"Find directions from previous route location to this location in Google Maps?" 
													delegate:self 
													cancelButtonTitle:@"Cancel" 
													otherButtonTitles:nil] 
											autorelease];

							//add a Yes button
							[prevLocationAlert addButtonWithTitle:@"Yes"];

							[prevLocationAlert show];
						}
					}];
	
	
	[[cell fromPreviousBtn] setHidden:!(selectedIndex > 0)];
	
	
	return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return (indexPath.row == selectedIndex) ? 88 : 44;
}




#pragma mark -
#pragma mark NSAlertView delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{
	if (alertView == googleRouteAlert)
	{
		if(selectedLocation != -1)
		{
			if (buttonIndex == 1) 
			{
				UIApplication*		app		= [UIApplication sharedApplication];
				AppDelegate*		delegate	= (AppDelegate*)[app delegate];
				MapVC*			mVC		= [delegate mapVC];
				MKMapView*		map		= [mVC map];
				float			userLat		= map.userLocation.location.coordinate.latitude;
				float			userLng		= map.userLocation.location.coordinate.longitude;
				NSString*		saddr		= [NSString stringWithFormat:@"%f,%f", userLat, userLng];
				NSDictionary*		selectedLoc	= [dataSource objectAtIndex:selectedLocation];
				NSString*		lat		= [selectedLoc objectForKey:@"lat"];
				NSString*		lng		= [selectedLoc objectForKey:@"lng"];
				NSString*		street		= [selectedLoc objectForKey:@"street"];
				NSString*		city		= [selectedLoc objectForKey:@"city"];
				NSString*		state		= [selectedLoc objectForKey:@"state"];
				NSString*		zip		= [selectedLoc objectForKey:@"zip"];
				NSMutableString*	daddr		= [NSMutableString stringWithFormat:@"%@,%@",lat,lng];
				
				if (([street length] > 0) && ([city length] > 0))
				{
					[daddr setString:@""];
					
					if ([street length] > 0)
					{
						[daddr appendString:street];
					}
					
					if ([city length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", city]];
					}
					
					if ([state length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", state]];
					}
					
					if ([zip length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", zip]];
					}
					
					[daddr replaceOccurrencesOfString:@" " withString:@"," options:0 range:NSMakeRange(0, [daddr length])];
				}
				
				NSString* destination = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@", saddr, daddr];
				
				[app openURL:[NSURL URLWithString:destination]];
			}
		}
	}
	else if (alertView == prevLocationAlert)
	{
		if(selectedLocation > 0)
		{
			if (buttonIndex == 1) 
			{
				UIApplication*		app		= [UIApplication sharedApplication];
				NSDictionary*		prevLoc		= [dataSource objectAtIndex:selectedIndex - 1];
				NSString*		prevLat		= [prevLoc objectForKey:@"lat"];
				NSString*		prevLng		= [prevLoc objectForKey:@"lng"];
				NSString*		saddr		= [NSString stringWithFormat:@"%@,%@", prevLat, prevLng];
				NSDictionary*		selectedLoc	= [dataSource objectAtIndex:selectedLocation];
				NSString*		lat		= [selectedLoc objectForKey:@"lat"];
				NSString*		lng		= [selectedLoc objectForKey:@"lng"];
				NSString*		street		= [selectedLoc objectForKey:@"street"];
				NSString*		city		= [selectedLoc objectForKey:@"city"];
				NSString*		state		= [selectedLoc objectForKey:@"state"];
				NSString*		zip		= [selectedLoc objectForKey:@"zip"];
				NSMutableString*	daddr		= [NSMutableString stringWithFormat:@"%@,%@",lat,lng];
				
				if (([street length] > 0) && ([city length] > 0))
				{
					[daddr setString:@""];
					
					if ([street length] > 0)
					{
						[daddr appendString:street];
					}
					
					if ([city length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", city]];
					}
					
					if ([state length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", state]];
					}
					
					if ([zip length] > 0)
					{
						[daddr appendString:[NSString stringWithFormat:@",%@", zip]];
					}
					
					[daddr replaceOccurrencesOfString:@" " withString:@"," options:0 range:NSMakeRange(0, [daddr length])];
				}
				
				NSString* destination = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=%@&daddr=%@", saddr, daddr];
				
				[app openURL:[NSURL URLWithString:destination]];
			}
		}
	}
}





#pragma mark -
#pragma mark Application Lifecycle

-(void)viewDidAppear:(BOOL)animated
{
	selectedIndex = -1;
	
	[table reloadData];
}




-(void)viewDidLoad
{
	if (dataSource == nil)
	{
		self.dataSource = [[[NSMutableArray alloc] init] autorelease];
	}
}




- (void)didReceiveMemoryWarning 
{
	[super didReceiveMemoryWarning];
}




- (void)viewDidUnload 
{
	[super viewDidUnload];
}




- (void)dealloc 
{	
	[dataSource release];
	[table release];
	[editBtn release];
	
	if(oldPath)
	{
		[oldPath release];
	}
	
	if(googleRouteAlert)
	{
		[googleRouteAlert release];
	}
	
	if(prevLocationAlert)
	{
		[prevLocationAlert release];
	}
	
	[super dealloc];
}


@end
