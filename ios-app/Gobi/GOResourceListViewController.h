//
//  GOResourceListViewController.h
//  Gobi
//
//  Created by Wojtek Kordylewski on 30.01.14.
//  Copyright (c) 2014 Gobi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOWebservice.h"
#import "GOMainViewController.h"
#import "GOResourceObject.h"

#define kListCellIdentifier     @"ListCell"

#define kUnwindToRuleStateEditFromResourceList  @"unwindToRuleStateEditFromResourceList"

@class GOGroupObject;

@interface GOResourceListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, GOWebserviceDelegate, UISearchDisplayDelegate>

@property (nonatomic) GOMainViewController *mainViewController;

@property (nonatomic) NSArray *resources;
@property (nonatomic) NSArray *searchResources;
@property (nonatomic) NSMutableArray *selectedResources;

@property (nonatomic) GOResourceObject *pickedResource;
@property (nonatomic) BOOL actionMode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
