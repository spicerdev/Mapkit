//
//  DataSource.h
//  ContactList
//
//  Created by X Code User on 7/16/14.
//  Copyright (c) 2014 Joshua Spicer, Fabio Germann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
@property (nonatomic) NSArray* companylist;
@property (nonatomic) NSArray* companyfields;

- (void) parseConactListFromFile;
@end
