//
//  Cell.h
//  ExpandingCells
//
//  Created by work on 1/7/13.
//  Copyright (c) 2013 sbyrd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonPressBlock)();

@class CellButton;

@interface Cell : UITableViewCell
{
	ButtonPressBlock	b0Function;
	ButtonPressBlock	b1Function;
	int					index;
}

@property (nonatomic, retain)	IBOutlet	CellButton*			button0;
@property (nonatomic, retain)	IBOutlet	CellButton*			button1;
@property (copy)							ButtonPressBlock	b0Function;
@property (copy)							ButtonPressBlock	b1Function;
@property (nonatomic)						int					index;
@property (nonatomic, retain)	IBOutlet	UILabel*			cellName;


-(IBAction)buttonWasPressed:(id)sender;
-(int)getHeight;
-(void)expand;
-(void)contract;

@end
