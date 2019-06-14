//
//  DbHelper.m
//  MoviesProject
//
//  Created by JETS on 3/29/19.
//  Copyright (c) 2019 JETS. All rights reserved.
//

#import "DbHelper.h"
#import "MoviesPojo.h"

@implementation DbHelper
static DbHelper *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
bool isDatabaseUsed = true;



+(DbHelper*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}




-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"E.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists AFLAM (id integer primary key AUTOINCREMENT, title text, date text, rate text , description text, image text , idmovie text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                printf("%s",sqlite3_errmsg(database));
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }else {
                printf("AFLAM table Created");
            }
            
            const char *sql_favourite_stmt =
            "create table if not exists FAV (id integer primary key AUTOINCREMENT,title text,image text)";
            if (sqlite3_exec(database, sql_favourite_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                printf("%s",sqlite3_errmsg(database));
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }else {
                printf("Favourite Table Created");
            }
            
            sqlite3_close(database);
            printf("%s",sqlite3_errmsg(database));
            return isSuccess;
        }
        else {
            isSuccess = NO;
            printf("%s",sqlite3_errmsg(database));
            NSLog(@"Failed to open/create database");
        }
    }
    printf("%s",sqlite3_errmsg(database));
    return isSuccess;
}


-(BOOL)deleteDataFromSqlite{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM AFLAM"];
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(database, delete_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("deleted ");
            return YES;
        }  else {
            printf("%s",sqlite3_errmsg(database));
            return NO;
        }
      
        sqlite3_finalize(statement);
        sqlite3_close(database);
    
    }
    return  YES;
}

-(BOOL) saveData:(NSString*) title :(NSString*) date:(NSString*) rate:(NSString*)description:(NSString*) image:(NSString*)movieID;

{
    
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        if (isDatabaseUsed) {
            
            NSString *insertSQL = [NSString stringWithFormat:@"insert into AFLAM (title,date,rate, description, image,idmovie ) values (\"%@\",\"%@\",\"%@\", \"%@\",\"%@\", \"%@\")",title,date, rate, description,image,movieID];
            const char *insert_stmt = [insertSQL UTF8String];
            sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                printf("saved ");
                return YES;
            }
            
            else {
                printf("%s",sqlite3_errmsg(database));
                return NO;
            }
            isDatabaseUsed = false;
            sqlite3_finalize(statement);
            sqlite3_close(database);
            //sqlite3_reset(statement);
           }
        }
    
 
        return NO;
}




-(NSArray*) getMovies;
{

    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from AFLAM" ];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (isDatabaseUsed) {
            
            if (sqlite3_prepare_v2(database,
                                   query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *movieTitle = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 1)];
                    MoviesPojo *moviePojo = [MoviesPojo new];
                    // [resultArray addObject:name];
                    moviePojo.titleMovie = movieTitle;
                    
                    NSString *movieDate = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 2)];
                    // [resultArray addObject:department];
                    moviePojo.dateMovie = movieDate;
                    
                    
                    NSString *movieRate = [[NSString alloc] initWithUTF8String:
                                           (const char *) sqlite3_column_text(statement, 3)];
                    // [resultArray addObject:department];
                    moviePojo.rateMovie = movieRate;
                    
                    
                    NSString *movieDescription = [[NSString alloc] initWithUTF8String:
                                                  (const char *) sqlite3_column_text(statement, 4)];
                    // [resultArray addObject:department];
                    moviePojo.descriptionMovie = movieDescription;
                    
                    
                    NSString *movieImage = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 5)];
                    // [resultArray addObject:department];
                    moviePojo.imageMovie = movieImage;
                    
                    
                    
                    NSString *movieId = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 6)];
                    // [resultArray addObject:department];
                    moviePojo.idMovie = movieId;
                    
                    
                    [resultArray addObject:moviePojo];
                    //return resultArray;
                }
                 return resultArray;
                sqlite3_finalize(statement);
               
                //            sqlite3_reset(statement);
            }else{
                printf("here");
                printf("%s",sqlite3_errmsg(database));
            }
           // isDatabaseUsed = true;
        }
      
        sqlite3_close(database);
    }
    return nil;
}





-(BOOL)createFavouriteDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[1];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"mine.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists FAV (id integer primary key AUTOINCREMENT, title text,image text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                printf("%s",sqlite3_errmsg(database));
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            printf("%s",sqlite3_errmsg(database));
            return isSuccess;
        }
        else {
            isSuccess = NO;
            printf("%s",sqlite3_errmsg(database));
            NSLog(@"Failed to open/create database");
        }
    }
    printf("%s",sqlite3_errmsg(database));
    return isSuccess;
    
    
}



-(BOOL) saveFavourites:(NSString*)title: (NSString*) image{
    
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        
        
        NSString *insertSQL = [NSString stringWithFormat:@"insert into FAV (title,image ) values (\"%@\",\"%@\")",title,image];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            printf("saved ");
            return YES;
        }
        
        else {
            printf("%s",sqlite3_errmsg(database));
            return NO;
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
        //sqlite3_reset(statement);
    }
    
    
    return NO;
}



-(NSArray*) getFavourites{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from FAV" ];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *favouritesArray = [[NSMutableArray alloc]init];
        
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *movieTitle = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                MoviesPojo *moviePojo = [MoviesPojo new];
                // [resultArray addObject:name];
                moviePojo.titleMovie = movieTitle;
                
                NSString *movieImage = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 2)];
                // [resultArray addObject:department];
                moviePojo.imageMovie = movieImage;
                
                [favouritesArray addObject:moviePojo];
                //return resultArray;
            }
            return favouritesArray;
            sqlite3_finalize(statement);
            
            //            sqlite3_reset(statement);
        }else{
            printf("here");
            printf("%s",sqlite3_errmsg(database));
        }
        
        
        sqlite3_close(database);
    }
    return nil;
    
}



@end
