//
//  videoPlayerViewController.h
//  MoviesProject
//
//  Created by JETS on 4/9/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoPlayerViewController : UIViewController <NSURLConnectionDelegate,
NSURLConnectionDataDelegate>

@property NSString *getMovieId;


@end
