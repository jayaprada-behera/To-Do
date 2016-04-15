//
//  ViewController.m
//  EmptyProject
//
//  Created by jayaprada on 11/04/16.
//  Copyright © 2016 jayaprada. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray *reminders;
@property (weak, nonatomic) IBOutlet UILabel *lbl;

@property (weak, nonatomic) IBOutlet UITextField *textFldRemindItem;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *reminederListTableView;
- (IBAction)datePickerValueChanged:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLocalNotification];
    [self.datePicker setMinimumDate:[NSDate date]];
    self.textFldRemindItem.returnKeyType = UIReturnKeyDone;
    
    self.reminders = [[NSMutableArray alloc] init];
    self.reminders = [[[UIApplication sharedApplication] scheduledLocalNotifications] mutableCopy];
    [self.reminederListTableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)setupLocalNotification{
    [self.textFldRemindItem resignFirstResponder];
    
    // Get the current date
    NSDate *pickerDate = [self.datePicker date];
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = self.textFldRemindItem.text;
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
 
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)datePickerValueChanged:(id)sender {
    
}
#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return
    self.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
    }
    
    UILocalNotification *localNotification = [self.reminders objectAtIndex:indexPath.row];
    
    // Display notification info
    [cell.textLabel setText:localNotification.alertBody];
    [cell.detailTextLabel setText:[localNotification.fireDate description]];
    return cell;
}
@end
