//
//  videoPlayerViewController.m
//  MoviesProject
//
//  Created by JETS on 4/9/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import "videoPlayerViewController.h"

@interface videoPlayerViewController (){
    NSMutableData *vedioData;
    NSArray *vedioArray;
}
@property (strong, nonatomic) IBOutlet UILabel *myLabel;
@property (strong, nonatomic) IBOutlet UIWebView *myWeb;

@end

@implementation videoPlayerViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

   
    
    NSString *reviews =[NSString stringWithFormat:@"https://api.themoviedb.org/3/movie/%@/videos?api_key=658680e409a5e9e11988f3e49361edae&language=en-US",_getMovieId];
    NSURL *videoUrl = [NSURL URLWithString:reviews];
    NSLog(@"review Url is : %@",videoUrl);
    NSURLRequest *vedioRequest = [[NSURLRequest alloc]initWithURL:videoUrl];
    NSURLConnection *Videoconnection = [[NSURLConnection alloc]initWithRequest:vedioRequest delegate:self];
    [Videoconnection start];
//https://api.themoviedb.org/3/movie/166428/videos?api_key=658680e409a5e9e11988f3e49361edae&language=en-US
                        
                        
//    
//    NSURL *url = [NSURL URLWithString:@"http://www.youtube.com/watch?v=fDXWW5vX-64"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
  //  _myLabel.text = _getMovieId;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    vedioData = [NSMutableData new];
}



-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [vedioData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:vedioData options:NSJSONReadingAllowFragments error:nil];
     vedioArray= [dict objectForKey:@"results"];
    
    
    
    for (NSDictionary *dict3 in vedioArray){
        NSString *key = [NSString new];
        key = [dict3 objectForKey:@"key"];
        NSLog(@"%@",key);
        _myLabel.text = key;
    }
    
    
    
//    
//    NSString *embedCode =[NSString stringWithFormat:@"<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/%@\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>",_myLabel.text];
    
//    NSString *embedCode = @"<iframe width=\"560\" height=\"315\" src=\"https://www.youtube.com/embed/papuvlVeZg8\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>";
//    
//    [[self myWeb]loadHTMLString:embedCode baseURL:nil];
    
    
    NSString *vedioTrailer =[NSString stringWithFormat:@"http://www.youtube.com/watch?v=%@",_myLabel.text];
    
        NSURL *url = [NSURL URLWithString:vedioTrailer];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.myWeb loadRequest:request];
    
 
}



@end
