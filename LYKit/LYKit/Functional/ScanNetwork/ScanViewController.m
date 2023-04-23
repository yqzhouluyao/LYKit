#import "ScanViewController.h"
#import "Device.h"

@interface ScanViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic, strong) UITableView *devicesTableView;
@property (nonatomic, strong) NSMutableArray<Device *> *devices;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.devices = [NSMutableArray array];

    [self setupUI];
    [self setupUDPSocket];
    [self sendBroadcast];
}

- (void)setupUI {
    // Set up devices table view
    self.devicesTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.devicesTableView.dataSource = self;
    self.devicesTableView.delegate = self;
    [self.view addSubview:self.devicesTableView];
}

- (void)setupUDPSocket {
    NSLog(@"Initializing UDP socket");
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

    NSError *error = nil;

    if (![self.udpSocket bindToPort:12345 error:&error]) {
        NSLog(@"Error binding: %@", error);
        return;
    }

    if (![self.udpSocket beginReceiving:&error]) {
        NSLog(@"Error receiving: %@", error);
        return;
    }

    NSLog(@"UDP socket ready");
}

- (void)sendBroadcast {
    NSString *message = @"Device discovery";
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:@"192.168.101.69" port:12345 withTimeout:-1 tag:0];
    NSLog(@"Broadcast message sent");
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DeviceCell"];
    }

    Device *device = self.devices[indexPath.row];
    cell.textLabel.text = device.name;
    cell.detailTextLabel.text = device.ip;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Handle device selection and perform actions like disconnecting the device
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext {
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received response: %@", response);

    NSError *error;
    NSDictionary *deviceInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Error parsing JSON: %@", error);
        return;
    }

    Device *device = [[Device alloc] initWithName:deviceInfo[@"name"] ip:deviceInfo[@"ip"]];
    
    // Avoid adding duplicate devices
    for (Device *existingDevice in self.devices) {
        if ([existingDevice.ip isEqualToString:device.ip]) {
            return;
        }
    }

    // Update the devices array and refresh the table view
    [self.devices addObject:device];
    [self.devicesTableView reloadData];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"Did not receive data due to error: %@", error);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"Data sent with tag: %ld", tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"Did not send data with tag: %ld due to error: %@", tag, error);
}

- (void)dealloc {
    [self.udpSocket close];
}

@end

