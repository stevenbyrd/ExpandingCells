#import <UIKit/UIKit.h>

typedef void (^ButtonPressBlock)();

@interface CustomCell : UITableViewCell 
{
    UIButton* fromCurrentBtn;
    UIButton* fromPreviousBtn;
    UIView*   defaultView;
    UILabel*  defaultLabel;
	
	ButtonPressBlock currentButtonPressed;
	ButtonPressBlock previousButtonPressed;
}
@property (nonatomic,retain) UIButton*  fromCurrentBtn;
@property (nonatomic,retain) UIButton*  fromPreviousBtn;
@property (nonatomic,retain) UIView*    defaultView;
@property (nonatomic,retain) UILabel*   defaultLabel;

@property (copy) ButtonPressBlock currentButtonPressed;
@property (copy) ButtonPressBlock previousButtonPressed;


- (void)setText:(NSString*)text;
- (void)currentButtonFunction:(id)sender;
- (void)previousButtonFunction:(id)sender;

@end
