//
//  ViewController.h
//  ExpandingCells
//
//  Created by work on 1/7/13.
//  Copyright (c) 2013 sbyrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
	NSArray*	dataSource;
	Cell*		selectedCell;
}

@property (nonatomic, retain) NSArray*	dataSource;
@property (nonatomic, retain) Cell*		selectedCell;

-(IBAction)buttonWasPressed:(id)sender;

@end
