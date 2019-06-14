//
//  DetailsViewController.m
//  MoviesProject
//
//  Created by JETS on 3/27/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import "DetailsViewController.h"
#import "DbHelper.h"
#import "videoPlayerViewController.h"

@interface DetailsViewController (){
    NSMutableData *recievedReviews;
    NSArray *myArray;


}
@property (strong, nonatomic) IBOutlet UILabel *movieTitle;
@property (strong, nonatomic) IBOutlet UILabel *movieDate;
@property (strong, nonatomic) IBOutlet UILabel *movieTime;
@property (strong, nonatomic) IBOutlet UILabel *movieRate;
@property (strong, nonatomic) IBOutlet UIImageView *moviePoster;
@property (strong, nonatomic) IBOutlet UITextView *movieDescription;
@property (strong, nonatomic) IBOutlet UIScrollView *myScrollview;


@end

@implementation DetailsViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *reviews =[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/reviews?api_key=658680e409a5e9e11988f3e49361edae&language=en-US&page=1",_movie.idMovie];
        NSURL *reviewsUrl = [NSURL URLWithString:reviews];
    NSLog(@"review Url is : %@",reviewsUrl);
        NSURLRequest *reviewsRequest = [[NSURLRequest alloc]initWithURL:reviewsUrl];
        NSURLConnection *connection2 = [[NSURLConnection alloc]initWithRequest:reviewsRequest delegate:self];
        [connection2 start];
    

    self.title = @"Movie Details";
    NSString *baseImageURl = @"http://image.tmdb.org/t/p/w185/";
    NSString *sourceUrl = [_movie imageMovie];
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@",baseImageURl,sourceUrl];

    _movieTitle.text = [_movie titleMovie];
    _movieDate.text = [_movie dateMovie];
    _movieRate.text = [NSString stringWithFormat:@"%@",[_movie rateMovie]];
    _movieDescription.text = [_movie descriptionMovie];
//
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:totalUrl]]];
//
   UIImage * image =  [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:totalUrl]]];
    NSLog(@"movie path image = %@",totalUrl);
    [_moviePoster setImage:image];
}

- (IBAction)likeMovie:(id)sender {
    BOOL favourites = NO;
    favourites = [[DbHelper getSharedInstance]saveFavourites:_movie.titleMovie :_movie.imageMovie ];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    recievedReviews = [NSMutableData new];
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [recievedReviews appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{

    
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:recievedReviews options:NSJSONReadingAllowFragments error:nil];
    myArray = [dict objectForKey:@"results"];
    
    
    
    for (NSDictionary *dict3 in myArray){
                    NSString *contentReview = [NSString new];
                    contentReview = [dict3 objectForKey:@"content"];
                    NSLog(@"%@",contentReview);
        _myReviews.text = contentReview;
               }
}

-(void)viewDidLayoutSubviews{
    [_myScrollview setScrollEnabled:YES];
    [_myScrollview setContentSize:CGSizeMake(350, 1500)];
}

- (IBAction)goToVideo:(id)sender {
    
      videoPlayerViewController *video = [self.storyboard instantiateViewControllerWithIdentifier:@"videoPlayer"];
    [video setGetMovieId:_movie.idMovie];
    [self.navigationController pushViewController:video animated:NO];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
}


@end
