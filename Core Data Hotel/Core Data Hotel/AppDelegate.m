//
//  AppDelegate.m
//  Core Data Hotel
//
//  Created by Robert Hatfield on 4/24/17.
//  Copyright © 2017 Robert Hatfield. All rights reserved.
//

#import "AppDelegate.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "ViewController.h"
#import "CoreDataStack.h"

#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface AppDelegate ()

@property(strong, nonatomic) UINavigationController *navController;
@property(strong, nonatomic) ViewController *viewController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Fabric with:@[[Crashlytics class]]];

    [self setupRootViewController];
    [self bootstrapApp];
    return YES;
}

-(void)bootstrapApp {
    // Seed CoreData with contents of JSON file if no CoreData store is available.
    
    
    NSManagedObjectContext *context = [[[CoreDataStack shared] persistentContainer] viewContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
    NSError *error;
    NSInteger count = [context countForFetchRequest:request error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    }
    
    if (count == 0) {
        NSDictionary *hotels = [[NSDictionary alloc] init];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hotels" ofType:@"json"];
        
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        
        NSError *jsonError;
        NSDictionary *jsonDictionary = [NSJSONSerialization
                                        JSONObjectWithData:jsonData
                                        options:NSJSONReadingMutableContainers
                                        error:&jsonError];
        
        if (jsonError) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        hotels = jsonDictionary[@"Hotels"];
        
        for (NSDictionary *hotel in hotels) {
            Hotel *newHotel = [NSEntityDescription
                               insertNewObjectForEntityForName:@"Hotel"
                               inManagedObjectContext:context];
            
            newHotel.name = hotel[@"name"];
            newHotel.location = hotel[@"location"];
            newHotel.stars = (NSInteger)hotel[@"stars"];
            
            for (NSDictionary *room in hotel[@"rooms"]) {
                Room *newRoom = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"Room"
                                 inManagedObjectContext:context];
                
                newRoom.number = [(NSNumber *)room[@"number"] intValue];
                newRoom.beds = [(NSNumber *)room[@"beds"] intValue];
                newRoom.cost = [(NSNumber *)room[@"cost"] floatValue];
                
                newRoom.hotel = newHotel;
            }
        }
        
        NSError *saveError;
        [context save:&saveError];
        
        if (saveError) {
            NSLog(@"There was an error when saving to Core Data.");
        } else {
            NSLog(@"Succesfully saved to Core Data.");
        }
    }
}

-(void)setupRootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [CoreDataStack.shared saveContext];
}

@end
