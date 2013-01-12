//
//  ViewController.m
//  ExpandingCells
//
//  Created by work on 1/7/13.
//  Copyright (c) 2013 sbyrd. All rights reserved.
//

#import "ViewController.h"
#import "CellButton.h"


@implementation ViewController


@synthesize dataSource;
@synthesize selectedCell;


static Cell* blankCell = nil;


#pragma mark Data Source Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	Cell*		cell		= [tableView dequeueReusableCellWithIdentifier:@"CustomCell"];
	NSString*	cellName	= [[self dataSource] objectAtIndex:[indexPath row]];
	
	if (cell == nil)
	{
		cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self options:nil] objectAtIndex:0];
	}
	
	[cell setIndex:[indexPath row]];
	[[cell cellName] setText:cellName];
	
	[cell setB0Function:^(){
		UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:cellName message:@"Button 0" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil] autorelease];
		
		[alert show];
	}];
	
	[cell setB1Function:^(){
		UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:cellName message:@"Button 1" delegate:nil cancelButtonTitle:@"Cool" otherButtonTitles:nil] autorelease];
		
		[alert show];
	}];
	
	return cell;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[self dataSource] count];
}




#pragma mark Table View Delegate Methods

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
	return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
	return 1;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	if ([indexPath row] == [[self selectedCell] index])
	{
		return [[self selectedCell] getHeight];
	}
	
	return [blankCell getHeight];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSIndexPath*	oldPath = nil;
	Cell*				cell	=  (Cell*)[tableView cellForRowAtIndexPath:indexPath];
	
	if([[self selectedCell] index] >= 0)
	{
		[[self selectedCell] contract];
	}
	
	[self setSelectedCell:cell];
	
	[cell expand];
	
	if (oldPath && (oldPath.row != indexPath.row))
	{
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, oldPath, nil] withRowAnimation:UITableViewRowAnimationNone];
		
		[oldPath release];
		oldPath = nil;
	}
	else
	{
		[tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
	}
}



#pragma mark IBActions

-(IBAction)buttonWasPressed:(id)sender
{
	CellButton*			button	= (CellButton*)sender;
	Cell*				cell	= [button owner];
	ButtonPressBlock	f0		= [cell b0Function];
	ButtonPressBlock	f1		= [cell b1Function];
	
	if (button == [cell button0])
	{
		f0();
	}
	else
	{
		f1();
	}
}




#pragma mark Initializing

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self == [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		[self setDataSource:[NSArray arrayWithObjects:@"cell 0", @"cell 1", @"cell 2", nil]];
		
		//Setting the selected cell value to this blank instance of the custom cell great simplifies the heightForRowAtIndexPath
		//function and lets us avoid needing to hard code any values -- now the height is derived from a nib. This blank instance
		//will go away the first time a cell is selected for real.
		[self setSelectedCell:[[[NSBundle mainBundle] loadNibNamed:@"ExpandingCell" owner:self options:nil] objectAtIndex:0]];
		
		blankCell = [self selectedCell];
		
		[blankCell setIndex:-1];
		[blankCell retain];
	}
	
	return self;
}




- (void)viewDidLoad
{	
    [super viewDidLoad];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
