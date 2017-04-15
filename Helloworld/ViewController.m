//
//  ViewController.m
//  Helloworld
//
//  Created by user on 04.03.17.
//  Copyright © 2017 edu. All rights reserved.
//

#import "ViewController.h"

#define titleY 0
#define titleH 60
#define datesY titleH+5
#define datesH 20
#define priceY datesY+datesH+5
#define priceH datesH
#define placeTitleY priceY+priceH+5
#define placeTitleH datesH
#define addrY placeTitleY+placeTitleH+5
#define addrH datesH
#define descriptionY addrY+addrH+5
#define descriptionH 90
#define totalH descriptionY+descriptionH+5


@interface ViewController ()

@end

@implementation ViewController
@synthesize userName = _userName;
UIAlertView *theAlert;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeGreching:(id)sender {
    self.userName = self.textField.text;
    NSString *nameString = self.userName;
    if ([nameString length] == 0) {
        nameString = @"World";
    }
    NSString *greeting = [[NSString alloc] initWithFormat:@"Hello,%@!", nameString];
                          self.label.text = greeting;
}
                        
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.textField) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(NSString*) getURLString {
    NSMutableString* result = [[NSMutableString alloc] initWithString:@"https://kudago.com/public-api/v1.3/events/?text_format=text&location=ekb&categories=cinema,circus,concert,festival,exhibition&fields=title,dates,place,description,body_text,price,site_url&expand=place,dates"];
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:now];
    NSDate* nowDay = [calendar dateFromComponents:components];
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToSaturday = (14 - weekdayToday) % 7;
    NSInteger daysToMonday = (9 - weekdayToday) % 7;
    
    NSDate* nextSaturday = [nowDay dateByAddingTimeInterval:60*60*24*daysToSaturday];
    NSDate* nextMonday = [nowDay dateByAddingTimeInterval:60*60*24*daysToMonday];
    
    NSInteger st = [nextSaturday timeIntervalSince1970];
    NSInteger mn = [nextMonday timeIntervalSince1970];
    
    [result appendString:@"&actual_since="];
    [result appendString:[NSString stringWithFormat:@"%ld", (long)st]];
    
    [result appendString:@"&actual_until="];
    [result appendString:[NSString stringWithFormat:@"%ld", (long)mn]];
    
    return [NSString stringWithString:result];
    
}

-(NSDictionary*) parseEvent: (NSDictionary*) event {
    NSMutableDictionary* result = [NSMutableDictionary new];
    
    NSString* title=[event valueForKey:@"title"];
    [result setValue:[self capitalizeFirstLetterOnlyOfString:title] forKey:@"titleTxt"];
    
    NSArray* dates = [[event valueForKey:@"dates"] objectAtIndex:0];
    NSString* startDate = [dates valueForKey:@"start_date"];
    [result setValue:startDate forKey:@"startDate"];
    NSString* endDate = [dates valueForKey:@"end_date"];
    [result setValue:endDate forKey:@"endDate"];
    
    NSString* price=[event valueForKey:@"price"];
    [result setValue:price forKey:@"price"];
    
    NSDictionary* place = [event valueForKey:@"place"];
    NSString* placeTitle=[place valueForKey:@"title"];
    [result setValue:placeTitle forKey:@"placeTitle"];
    NSString* address=[place valueForKey:@"address"];
    [result setValue:address forKey:@"adress"];
    
    NSString* desc=[event valueForKey:@"description"];
    [result setValue:desc forKey:@"desc"];
    
    NSString* url=[event valueForKey:@"site_url"];
    [result setValue:url forKey:@"url"];
    
    
    return (NSDictionary *)result;
}



-(UIView*) genView: (NSDictionary*) input {
    NSString* placeTitle = [input valueForKey:@"placeTitle"];
    NSString* startDate = [input valueForKey:@"startDate"];
    NSString* titleTxt = [input valueForKey:@"titleTxt"];
    NSString* endDate = [input valueForKey:@"endDate"];
    NSString* adress = [input valueForKey:@"adress"];
    NSString* price = [input valueForKey:@"price"];
    NSString* desc = [input valueForKey:@"desc"];
    NSString* url = [input valueForKey:@"url"];
    
    UILabel* urlLbl = [UILabel new];
    UILabel* descLbl = [UILabel new];
    UILabel* priceLbl = [UILabel new];
    UILabel* adressLbl = [UILabel new];
    //UILabel* endDateLbl = [UILabel new];
    UILabel* titleTxtLbl = [UILabel new];
    UILabel* startDateLbl = [UILabel new];
    UILabel* placeTitleLbl = [UILabel new];
    
    
   // UIStackView* view=[[UIStackView alloc] init];
    UIView* view=[UIView new];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 5;
    view.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    view.backgroundColor = [UIColor whiteColor];
   // view.axis = UILayoutConstraintAxisVertical;
    //view.alignment = UIStackViewAlignmentLeading;
   // view.distribution = UIStackViewDistributionEqualSpacing;
    //view.spacing = 5;
    
    
    //[titleTxtLbl.widthAnchor constraintEqualToConstant:self.scroll.bounds.size.width-10].active=true;
    //view.translatesAutoresizingMaskIntoConstraints = false;

    UIFont* font = [UIFont fontWithName:@"PingFangTC-Semibold" size:15];
    
    titleTxtLbl.text = titleTxt;
    titleTxtLbl.numberOfLines = 2; //wrapping
    titleTxtLbl.font = font;
    titleTxtLbl.backgroundColor = [UIColor lightGrayColor];
    //[titleTxtLbl sizeToFit];
    //int titleHeight = titleTxtLbl.frame.size.height;
    int itemsWidth=self.scroll.bounds.size.width-10;

    [titleTxtLbl setFrame:CGRectMake(5, titleY, itemsWidth, titleH)];
    
    [view addSubview:titleTxtLbl];
    
    UILabel* datesLbl = [UILabel new];
    NSMutableString* dates = [NSMutableString new];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    
    NSDateFormatter* writeFormatter = [NSDateFormatter new];
    writeFormatter.dateFormat = @"dd MMM yyyy";
    writeFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"ru_RU"];
    NSMutableString* datesString=[NSMutableString new];

    if (![startDate isEqual:[NSNull null]]) {
        NSDate *sd = [dateFormatter dateFromString:startDate];
        
        [datesString appendString:[writeFormatter stringFromDate:sd]];
       // [dates appendString:[dateFormatter stringFromDate:yourDate]];
        
     //   startDateLbl.text = [dateFormatter stringFromDate:yourDate];
        
        //[startDateLbl sizeToFit];
     //   int w = startDateLbl.frame.size.width;
     //   int h = startDateLbl.frame.size.height;
        //[startDateLbl.widthAnchor constraintEqualToConstant:self.scroll.bounds.size.width-10].active=true;

        //NSLog(@"%@",[dateFormatter stringFromDate:yourDate]);
     //   [startDateLbl setFrame:CGRectMake(0, 50,itemsWidth/2-10, 20)];
        
     //   [view addArrangedSubview:startDateLbl];
        
    }
    if (![endDate isEqual:[NSNull null]]) {
        NSDate *ed = [dateFormatter dateFromString:endDate];
        [datesString appendString:@"/"];
        [datesString appendString:[writeFormatter stringFromDate:ed]];
    }
    startDateLbl.numberOfLines=1;
    startDateLbl.text=datesString;
    startDateLbl.numberOfLines=1;
    [startDateLbl setFrame:CGRectMake(5, datesY,itemsWidth, datesH)];
    [view addSubview:startDateLbl];
   
    
    if(![price isEqual:[NSNull null]]){
        priceLbl.numberOfLines=1;
        priceLbl.text=price;
        [priceLbl setFrame:CGRectMake(5,priceY,itemsWidth,priceH)];
        [view addSubview:priceLbl];
        
    }
    if(![placeTitle isEqual:[NSNull null]]){
        placeTitleLbl.numberOfLines=1;
        placeTitleLbl.text=placeTitle;
        [placeTitleLbl setFrame:CGRectMake(5,placeTitleY,itemsWidth,placeTitleH)];
        [view addSubview:placeTitleLbl];
    }
    if(![adress isEqual:[NSNull null]]){
        adressLbl.numberOfLines=1;
        adressLbl.text=adress;
        [adressLbl setFrame:CGRectMake(5,addrY,itemsWidth, addrH)];
        [view addSubview:adressLbl];
    }
    if(![desc isEqual:[NSNull null]]){
        descLbl.numberOfLines=3;
        descLbl.text=desc;
        [descLbl setFrame:CGRectMake(5,descriptionY,itemsWidth,descriptionH)];
        [view addSubview:descLbl];
    }
    [view layoutIfNeeded];
    //[view setFrame:CGRectMake(0,0,itemsWidth,100)];
    
    return view;
}

-(NSString* )capitalizeFirstLetterOnlyOfString:(NSString*)string{
    NSMutableString *result = string.mutableCopy;
    [result replaceCharactersInRange:NSMakeRange(0, 1) withString:[[result substringToIndex:1] capitalizedString]];
    
    return result;
}

-(void) setup{
    NSLog(@"setup");
    //self.eventStackView.axis = UILayoutConstraintAxisVertical;
    //self.eventStackView.distribution = UIStackViewDistributionEqualSpacing;
    //self.eventStackView.alignment = UIStackViewAlignmentCenter;
    //self.eventStackView.spacing = 30;
    
    //self.eventStackView.translatesAutoresizingMaskIntoConstraints = false;
    
    
    NSURLSession* us = [NSURLSession sharedSession];
    NSURLSessionDataTask* dataTask = [us dataTaskWithURL:[NSURL URLWithString:[self getURLString]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            
             NSMutableDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
            NSArray *events = [jsonArray objectForKey:@"results"];
            
           
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
           //     int summHeight = 0;
                int i=0;
                // code here
                for(NSDictionary *event in events){
                    
                    NSDictionary* dict = [self parseEvent:event];
                    /*for(NSDictionary *details in [status objectForKey:@"business_details"]){
                     NSString *name=[details valueForKey:@"name"];
                     [names addObject:name];
                     }*/
                    UIView* view = [self genView:dict];
                    
                    [view setFrame:CGRectMake(view.frame.origin.x, i++*(totalH+10), self.scroll.bounds.size.width, totalH)];
                    [self.scroll addSubview:view];

                    
                 /*   UIView* wrapper = [UIView new];
                    wrapper.layer.borderWidth = 1;
                    wrapper.layer.cornerRadius = 5;
                    //wrapper.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
                    
                    [wrapper setFrame:view.frame];
                    [wrapper addSubview:view];
                    
                    
                    [view layoutIfNeeded];
                    
                    
                    
                    [view setFrame:CGRectMake(view.frame.origin.x, i*(view.bounds.size.height + 10), self.scroll.bounds.size.width, view.bounds.size.height)];
                    i++;
                    summHeight += view.bounds.size.height + 10;*/
                    //NSLog(@"%@", [dict valueForKey:@"price"]);
                }
                [self.scroll layoutIfNeeded];
                self.scroll.contentSize = CGSizeMake(self.scroll.bounds.size.width, /*summHeight*/(totalH+10)*events.count);
            });
            
            
            
            //NSLog(@"%@", jsonArray);
        }
        else {
            theAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"Network issues"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:@"Refresh",nil];
            [theAlert show];
        }
    }];
    [dataTask resume];
    
  
    
    
    //Layout for Stack View
    //[self.eventStackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    //[self.eventStackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchhor].active = true;
    //for(int i = 0 ; i < 13 ; i++){
   //     NSLog(@"setup_cyl");
        /*
        if(i%2==0){
            view.backgroundColor=[UIColor blueColor];
        }else{
            view.backgroundColor=[UIColor redColor];
        }
        [view setFrame:CGRectMake(view.frame.origin.x, i*120, self.scroll.bounds.size.width, 100)];
       // [view.widthAnchor constraintEqualToConstant:200].active=true;
       // [view.heightAnchor constraintEqualToConstant:100].active=true;
        [self.scroll addSubview:view];
        
        */
        
        
    //}
    //[self.scroll layoutIfNeeded];
    //[self.eventStackView layoutIfNeeded];
    
}
#pragma Alert View

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //NSString* login = [[alertView textFieldAtIndex:0] text];
    //NSString* psw = [[alertView textFieldAtIndex:1] text];
    //NSLog(@"Button with index %d clicked, Login:%@, Password:%@",buttonIndex,login,psw);
    if (buttonIndex == 1) {
        [self setup];
    }
}

- (IBAction)onButtonClick:(id)sender {
    [[self.scroll subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setup];
}

@end
