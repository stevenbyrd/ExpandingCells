//
//  CellButton.m
//  ExpandingCells
//
//  Created by work on 1/7/13.
//  Copyright (c) 2013 sbyrd. All rights reserved.
//

#import "CellButton.h"

@implementation CellButton

@synthesize owner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    return self;
}

-(void) dealloc
{
	[owner release];
	
	[super dealloc];
}

@end
