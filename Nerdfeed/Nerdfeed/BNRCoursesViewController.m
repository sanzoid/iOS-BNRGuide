//
//  BNRCoursesViewController.m
//  Nerdfeed
//
//  Created by Sandy House on 2016-02-02.
//  Copyright © 2016 sanzapps. All rights reserved.
//

#import "BNRCoursesViewController.h"
#import "BNRWebViewController.h"

@interface BNRCoursesViewController () <NSURLSessionDataDelegate>

@property (nonatomic) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses; // Array of NSDictionary objects that describe each course

@end

@implementation BNRCoursesViewController

/////////////////////// INITIALIZERS //////////////////////////////////
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"BNR Courses";
        
        // Create a session with a default configuration
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:/*nil*/self
                                            delegateQueue:nil];
        [self fetchFeed];
    }
    return self;
}
//////////////////////// OVERIDDEN INHERITED METHODS /////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create UITableViewCells when no recycled cells to use with identitifer UITableViewCell
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // return 0;
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return nil;
    
    // Get a UITableViewCell, get the course's title for the cell label
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                            forIndexPath:indexPath];
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
    didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // When a row is selected, go to the course's web page
    
    NSDictionary *course = self.courses[indexPath.row]; // Get the course
    NSURL *URL = [NSURL URLWithString:course[@"url"]];  // Get URL
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;

    // only push webViewController if there is no splitViewController
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController
                                             animated:YES];
    } // else the UISplitViewController will handle it
    
}

//////////////////////// DELEGATE METHODS ///////////////////////////////

- (void)URLSession:(NSURLSession *)session
              task:(nonnull NSURLSessionTask *)task
didReceiveChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
 completionHandler:(nonnull void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    // Create and use a credential 
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch"
                                                       password:@"AchieveNerdvana"
                                                    persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

/////////////////////////////////////////////////////////////////////////

- (void)fetchFeed
{
    // Create NSURL and instantiate NSURLRequest with it
    // NSString *requestString = @"http://bookapi.bignerdranch.com/courses.json";
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    
    // Create a task with the session object.
    // Give it a request and a completion block (to call for when it finishes).
    NSURLSessionDataTask *dataTask =
        [self.session dataTaskWithRequest:req
                        completionHandler:
         ^(NSData *data, NSURLResponse *response, NSError *error) {
             /*NSString *json = [[NSString alloc] initWithData:data
              encoding:NSUTF8StringEncoding];
              NSLog(@"%@", json);
              */
             // Create object instances from the JSON data
             NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                        options:0
                                                                          error:nil];
             //NSLog(@"%@", jsonObject);
             self.courses = jsonObject[@"courses"];
             NSLog(@"%@", self.courses);
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData]; 
             });
         }];
    // Tasks are created in the suspended state so resume will start the request
    [dataTask resume];
}



@end




