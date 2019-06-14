//
//  DbHelper.h
//  MoviesProject
//
//  Created by JETS on 3/29/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DbHelper : NSObject{

NSString *databasePath;
}
+(DbHelper*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) saveData:(NSString*)title :(NSString*) date:(NSString*) rate:(NSString*)description:(NSString*) image:(NSString*)movieID;
-(NSArray*) getMovies;
-(BOOL)deleteDataFromSqlite;


-(BOOL)createFavouriteDB;
-(BOOL) saveFavourites:(NSString*)title: (NSString*) image;
-(NSArray*) getFavourites;





@end
