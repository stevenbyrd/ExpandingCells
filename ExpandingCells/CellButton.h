//
//  CellButton.h
//  ExpandingCells
//
//  Created by work on 1/7/13.
//  Copyright (c) 2013 sbyrd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"

@interface CellButton : UIButton

@property (nonatomic, retain) IBOutlet Cell* owner;

@end
