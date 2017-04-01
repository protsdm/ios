//
//  ViewController.h
//  Helloworld
//
//  Created by user on 04.03.17.
//  Copyright © 2017 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)changeGreching:(id)sender;
@property (weak, nonatomic) IBOutlet UIStackView *eventStackView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (copy, nonatomic) NSString *userName;
@end

