//
//  DataSource.m
//  ContactList
//
//  Created by X Code User on 7/16/14.
//  Copyright (c) 2014 Joshua Spicer, Fabio Germann. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

- (void) parseConactListFromFile
{
    
    // Retrieve local JSON file called example.json
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"json"];
    
    // Load the file into an NSData object called JSONData
    
    NSError *error = nil;
    
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];
    
    NSMutableDictionary *import = [NSJSONSerialization
                                       JSONObjectWithData:JSONData
                                       options:NSJSONReadingMutableContainers
                                       error:&error];
    
    self.companylist = import[@"data"];
    self.companyfields = import[@"cols"];
}

@end
