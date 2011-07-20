#import "CustomCell.h"


@implementation CustomCell

@synthesize fromCurrentBtn;
@synthesize fromPreviousBtn;
@synthesize defaultView;
@synthesize defaultLabel;
@synthesize currentButtonPressed;
@synthesize previousButtonPressed;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
	if (self) 
	{
		if ([reuseIdentifier isEqualToString:@"short"])
		{
			self.defaultView = [[[UIView alloc] initWithFrame:CGRectMake(	self.contentView.frame.origin.x, 
											self.contentView.frame.origin.y, 
											self.contentView.frame.size.width, 
											self.contentView.frame.size.height)]
								autorelease];
		}
		else
		{
			[self.contentView setFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height * 2)];
			
			self.defaultView = [[[UIView alloc] initWithFrame:CGRectMake(	self.contentView.frame.origin.x, 
											self.contentView.frame.origin.y, 
											self.contentView.frame.size.width, 
											self.contentView.frame.size.height)]
								autorelease];
			
			//Buttons
			self.fromCurrentBtn     = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];
			self.fromPreviousBtn    = [[UIButton buttonWithType:UIButtonTypeCustom] autorelease];
            
			UIImage* currentBtnImage = [UIImage imageNamed:@"fromCurrentBtn.png"];
			[self.fromCurrentBtn setBackgroundImage:currentBtnImage forState:UIControlStateNormal];
            
			UIImage* previousBtnImage = [UIImage imageNamed:@"fromPreviousBtn.png"];
			[self.fromPreviousBtn setBackgroundImage:previousBtnImage forState:UIControlStateNormal];
			
			self.fromCurrentBtn.titleLabel.text	= @"current";
			self.fromPreviousBtn.titleLabel.text	= @"previous";
			self.fromCurrentBtn.frame		= CGRectMake(7, 48, 151, 31);
			self.fromPreviousBtn.frame		= CGRectMake(163, 48, 151, 31);
			
			[self.fromCurrentBtn addTarget:self action:@selector(currentButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
			[self.fromPreviousBtn addTarget:self action:@selector(previousButtonFunction:) forControlEvents:UIControlEventTouchUpInside];
			
			UIImage*	bgImg		= [UIImage imageNamed:@"routeBackground.png"];
			UIImageView*	backgroundImage	= [[[UIImageView alloc] initWithImage:bgImg] autorelease];
            
			[backgroundImage setFrame:CGRectMake(0,44,320,44)];
            
			[self.defaultView addSubview:backgroundImage];
			[self.defaultView addSubview:fromCurrentBtn];
			[self.defaultView addSubview:fromPreviousBtn];
		}
		
		
		//Labels
		self.defaultLabel	= [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 310, 34)] autorelease];
		self.defaultLabel.font	= [UIFont fontWithName:@"Helvetica-Bold" size:16.0]; 
      
		[self.defaultView addSubview:defaultLabel];
		
		[self.contentView addSubview:defaultView];
		[self.contentView bringSubviewToFront:defaultView];
		[self.contentView setClipsToBounds:YES];
    }
	
    return self;
}



- (void)setText:(NSString*)text
{
	self.defaultLabel.text = text;
}


- (void)currentButtonFunction:(id)sender
{
	currentButtonPressed();
}

- (void)previousButtonFunction:(id)sender
{
	previousButtonPressed();
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (void)dealloc
{
	[defaultLabel release];
	[fromCurrentBtn release];
	[fromPreviousBtn release];
	[defaultView release];
	[currentButtonPressed release];
	[previousButtonPressed release];
	
	[super dealloc];
}

@end
