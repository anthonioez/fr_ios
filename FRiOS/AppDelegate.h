#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define APP_EMAIL           @"mariannapucci2@gmail.com"
#define APP_PHONE           @"1-800-555-1212"

#define APP_TIMEOUT         60.0
#define APP_URL_FEED        @"http://www.trattoriacesarino.it/feed"
#define APP_URL_MAP         @"http://www.trattoriacesarino.it/map.xml"
#define ADMOB_BANNER_ID     @"ca-app-pub-3940256099942544/6300978111"

#define APP_DEBUG           0

#define isIPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (UINavigationController *)rootController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end

