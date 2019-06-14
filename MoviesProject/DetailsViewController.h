//
//  DetailsViewController.h
//  MoviesProject
//
//  Created by JETS on 3/27/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviesPojo.h"

@interface DetailsViewController : UIViewController <NSURLConnectionDelegate,
NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate>
@property MoviesPojo *movie;
@property (strong, nonatomic) IBOutlet UITextView *myReviews;

@property (strong, nonatomic) IBOutlet UIButton *watchTrailer;

@end
