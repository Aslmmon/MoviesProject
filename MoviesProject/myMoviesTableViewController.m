//
//  myMoviesTableViewController.m
//  MoviesProject
//
//  Created by JETS on 3/27/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import "myMoviesTableViewController.h"
#import "DetailsViewController.h"
#import "DbHelper.h"

@interface myMoviesTableViewController (){
    NSMutableData *recievedData;
    NSMutableData *reviewsData;
    NSArray *array;
    NSArray *reviewsArray;
    NSMutableArray *moviesArrayObject;
    NSArray *dataFromSqlite;
    NSString *titleOfMovie;
    NSString *movieId;
    NSURLConnection *connection1;
    NSURLConnection *connection2;
}

@end

@implementation myMoviesTableViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    moviesArrayObject = [NSMutableArray new];
    dataFromSqlite = [NSMutableArray new];
    self.title = @"Recent Movies";
    movieId = [NSString new];
    
  

//    
   NSString *myString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=658680e409a5e9e11988f3e49361edae&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"];
    NSURL *url = [NSURL URLWithString:myString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    connection1 = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection1 start];
    
    
    
    
    // second connection :
    // in details View Controller ..
//    NSString *reviews =[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/166428/reviews?api_key=658680e409a5e9e11988f3e49361edae&language=en-US&page=1"];
//    NSURL *reviewsUrl = [NSURL URLWithString:reviews];
//    NSURLRequest *reviewsRequest = [[NSURLRequest alloc]initWithURL:reviewsUrl];
//    connection2 = [[NSURLConnection alloc]initWithRequest:reviewsRequest delegate:self];
//    [connection2 start];
    
    
    
  

}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    if (connection == connection1) {
        recievedData = [NSMutableData new];

    }
    
//     if(connection == connection2) {
//        reviewsData = [NSMutableData new];
//    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    if (connection == connection1) {
       [recievedData appendData:data];
        NSLog(@"%@",recievedData);
    }
    
//    if(connection == connection2) {
//        [reviewsData appendData:data];
//         NSLog(@"%@",reviewsData);
//    }


    //response is recieved during whole process of network ..
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if (connection == connection1) {
        BOOL success = NO;
        BOOL deleted = NO;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:recievedData options:NSJSONReadingAllowFragments error:nil];
        array = [dict objectForKey:@"results"];
        
        deleted = [[DbHelper getSharedInstance]deleteDataFromSqlite];
        
        for (NSDictionary *dict2 in array){
            titleOfMovie = [NSString new];
            NSString *dateOfMovie = [NSString new];
            NSString *rateOfMovie = [NSString new];
            NSString *descOfMovie = [NSString new];
            NSString *imageOfMovie = [NSString new];
            NSString *mId = [NSString new];
            
            
            
            
            titleOfMovie = [dict2 objectForKey:@"title"];
            dateOfMovie =[dict2 objectForKey:@"release_date"];
            rateOfMovie =[dict2 objectForKey:@"vote_average"];
            descOfMovie = [dict2 objectForKey:@"overview"];
            imageOfMovie = [dict2 objectForKey:@"poster_path"];
            mId = [dict2 objectForKey:@"id"];

            success = [[DbHelper getSharedInstance] saveData:titleOfMovie :dateOfMovie :rateOfMovie:descOfMovie :imageOfMovie:mId];
            
        }
    }
    
//    if(connection == connection2){
//                    NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:reviewsData options:NSJSONReadingAllowFragments error:nil];
//                    reviewsArray = [dict2 objectForKey:@"results"]; //content , author
//        
//                    NSLog(@"array : %@",reviewsArray);
//        
//        for (NSDictionary *dict3 in reviewsArray){
//            NSString *contentReview = [NSString new];
//            contentReview = [dict3 objectForKey:@"content"];
//            NSLog(@"%@",contentReview);
//        }
//    }
 
    
    
    dataFromSqlite = [[DbHelper getSharedInstance]getMovies];
    
    [self.tableView reloadData];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataFromSqlite.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[dataFromSqlite objectAtIndex:indexPath.row]titleMovie] ;
    NSString *baseImageURl = @"http://image.tmdb.org/t/p/w185/";
    NSString *sourceUrl = [dataFromSqlite [indexPath.row]imageMovie];
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@",baseImageURl,sourceUrl];
   // NSLog(@"total url : %@",totalUrl);
    
 // cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:totalUrl]]];
    
    
    return cell;
}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if([segue.identifier isEqualToString:@"showDetails"]){
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        DetailsViewController *details = segue.destinationViewController;
        //[details setMyFriends:[friendsList objectAtIndex:index.row]];
        [details setMovie:[dataFromSqlite objectAtIndex:index.row]];
    }

}




@end
