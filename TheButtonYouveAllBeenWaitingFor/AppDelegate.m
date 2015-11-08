#import "AppDelegate.h"
@interface AppDelegate ()
@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@end
@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.image = [NSImage imageNamed:@"switchIcon.png"];
    [_statusItem.image setTemplate:YES];
    _statusItem.highlightMode = NO;
    _statusItem.toolTip = @"control-click to quit";
    [_statusItem setAction:@selector(itemClicked:)];
}
- (void)itemClicked:(id)sender {
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
        [[NSApplication sharedApplication] terminate:self];
        return;
    }
    NSTask *taskOff = [[NSTask alloc] init];
    taskOff.launchPath = @"/usr/sbin/networksetup";
    taskOff.arguments = @[@"-setairportpower", @"en0", @"off"];
    [taskOff launch];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSTask *taskOn = [[NSTask alloc] init];
        taskOn.launchPath = @"/usr/sbin/networksetup";
        taskOn.arguments = @[@"-setairportpower", @"en0", @"on"];
        [taskOn launch];
    });
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
}@end