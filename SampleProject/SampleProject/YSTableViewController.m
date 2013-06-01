//
//  YSTableViewController.m
//  SampleProject
//
//  Created by Federico Erostarbe on 5/12/13.
//  Copyright (c) 2013 Federico Erostarbe. All rights reserved.
//

#import "YSTableViewController.h"
#import "YSTableViewCell.h"

@implementation NSArray (JSON)

+ (NSArray *) arrayWithJSONString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (array != nil && error == nil) {
        return array;
    } else {
        return nil;
    }
}

@end

@interface YSTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UILabel *panelLabel;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation YSTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    NSString* path = [[NSBundle mainBundle] pathForResource:@"works"
                                                     ofType:@"json"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    _dataSource = [NSArray arrayWithJSONString:content];

    [self observeBarLocationForTableView:_tableView withBlock:^(CGPoint location, NSIndexPath *indexPath) {
        NSDictionary *storyDictionary = _dataSource[indexPath.row];
        self.panelText.text = [NSString stringWithFormat:@"written in %@", storyDictionary[@"written"]];
    }];

    self.panelText.numberOfLines = 2;
    self.panelText.font = [UIFont boldSystemFontOfSize:11.0];
}

#pragma mark UITableView protocol

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSTableViewCell *cell = (YSTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"YSCell"];
    if (cell == nil) {
        cell = [[YSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YSCell"];
    }

    NSDictionary *storyDictionary = _dataSource[indexPath.row];
    cell.storyLabel.text = storyDictionary[@"name"];
    cell.coauthorLabel.text = storyDictionary[@"coauthor"];
    return cell;
}

@end
