//
//  myMoviesViewController.m
//  MoviesProject
//
//  Created by JETS on 4/3/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import "myMoviesViewController.h"
#import "DbHelper.h"
#import "DetailsViewController.h"

@interface myMoviesViewController (){
    NSMutableData *recievedData;
    NSArray *array;
    NSArray *dataFromSqlite;
    NSString *titleOfMovie;
}

@end

@implementation myMoviesViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    dataFromSqlite = [NSArray new];
    self.title = @"Recent Movies";
    
    NSString *myString = [NSString stringWithFormat:@"https://api.themoviedb.org/3/discover/movie?api_key=658680e409a5e9e11988f3e49361edae&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1"];
    
    NSURL *url = [NSURL URLWithString:myString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    recievedData = [NSMutableData new];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [recievedData appendData:data];
    
    //response is recieved during whole process of network ..
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
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
        NSString *idOfMovie = [NSString new];
        titleOfMovie = [dict2 objectForKey:@"title"];
        dateOfMovie =[dict2 objectForKey:@"release_date"];
        rateOfMovie =[dict2 objectForKey:@"vote_average"];
        descOfMovie = [dict2 objectForKey:@"overview"];
        imageOfMovie = [dict2 objectForKey:@"poster_path"];
        idOfMovie = [dict2 objectForKey:@"id"];
        success = [[DbHelper getSharedInstance] saveData:titleOfMovie :dateOfMovie :rateOfMovie:descOfMovie :imageOfMovie:idOfMovie];
        
    }
    
    dataFromSqlite = [[DbHelper getSharedInstance]getMovies];
    
    [self.collectionView reloadData];
    
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return dataFromSqlite.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    //  cell.textLabel.text = array[indexPath.row][@"title"];
    // cell.textLabel.text = [moviesArrayObject[indexPath.row] titleMovie];
   // cell.textLabel.text = [[dataFromSqlite objectAtIndex:indexPath.row]titleMovie] ;
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text=[[dataFromSqlite objectAtIndex:indexPath.row]titleMovie];
    
    
    NSString *baseImageURl = @"http://image.tmdb.org/t/p/w185/";
    // NSString *sourceUrl = array[indexPath.row][@"poster_path"];
    NSString *sourceUrl = [dataFromSqlite [indexPath.row]imageMovie];
    NSString *totalUrl = [NSString stringWithFormat:@"%@%@",baseImageURl,sourceUrl];
    // NSLog(@"total url : %@",totalUrl);
//    
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];
    image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:totalUrl]]];
    
    // cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:totalUrl]]];
    
    
    return cell;
}








- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
//    if([segue.identifier isEqualToString:@"showDetails"]){
//        NSIndexPath *index = [ self.collectionView indexPathForCell:self.collectionView];
//        DetailsViewController *details = segue.destinationViewController;
//        //[details setMyFriends:[friendsList objectAtIndex:index.row]];
//        [details setMovie:[dataFromSqlite objectAtIndex:index.row]];
//    }
    
}


@end
