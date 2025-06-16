//
//  ViewController.m
//  168ACG
//
//  Created by MacXK on 2025/6/16.
//

#import "ViewController.h"
#import <CommonCrypto/CommonHMAC.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *resultCardView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *currentActivationCode;
@property (nonatomic, strong) UIStackView *resultStackView;
@property (nonatomic, strong) UIView *notesCardView;
@property (nonatomic, strong) UILabel *notesTitleLabel;
@property (nonatomic, strong) UILabel *notesContentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGradientBackground];
    
    [self setupCardView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"168激活码生成器";
    self.titleLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.3 alpha:1.0];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.text = @"轻松生成您的专属激活码";
    self.subtitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.subtitleLabel.textColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.5 alpha:1.0];
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:self.subtitleLabel];
    
    self.deviceCodeLabel = [[UILabel alloc] init];
    self.deviceCodeLabel.text = @"设备码";
    self.deviceCodeLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.deviceCodeLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.4 alpha:1.0];
    [self.cardView addSubview:self.deviceCodeLabel];
    
    self.getDeviceIDButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.getDeviceIDButton setTitle:@"获取UUID" forState:UIControlStateNormal];
    self.getDeviceIDButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.getDeviceIDButton addTarget:self action:@selector(getDeviceID) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.getDeviceIDButton];
    
    self.deviceCodeTextField = [[UITextField alloc] init];
    self.deviceCodeTextField.placeholder = @"请输入或自动获取设备码";
    self.deviceCodeTextField.font = [UIFont systemFontOfSize:16];
    self.deviceCodeTextField.borderStyle = UITextBorderStyleNone;
    self.deviceCodeTextField.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
    self.deviceCodeTextField.layer.cornerRadius = 10.0;
    self.deviceCodeTextField.layer.masksToBounds = YES;
    self.deviceCodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.deviceCodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.deviceCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *leftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    self.deviceCodeTextField.leftView = leftPaddingView;
    self.deviceCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.cardView addSubview:self.deviceCodeTextField];
    
    self.generateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.generateButton setTitle:@"生成激活码" forState:UIControlStateNormal];
    [self.generateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.generateButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    self.generateButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1.0];
    self.generateButton.layer.cornerRadius = 22.0;
    self.generateButton.layer.shadowColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:0.5].CGColor;
    self.generateButton.layer.shadowOffset = CGSizeMake(0, 4);
    self.generateButton.layer.shadowRadius = 8.0;
    self.generateButton.layer.shadowOpacity = 0.5;
    [self.generateButton addTarget:self action:@selector(generateActivationCode) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:self.generateButton];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.activityIndicator.color = [UIColor whiteColor];
    self.activityIndicator.hidesWhenStopped = YES;
    [self.generateButton addSubview:self.activityIndicator];
    
    [self setupResultCardView];
    
    self.resultStackView = [[UIStackView alloc] init];
    self.resultStackView.axis = UILayoutConstraintAxisVertical;
    self.resultStackView.spacing = 15;
    self.resultStackView.alignment = UIStackViewAlignmentCenter;
    [self.resultCardView addSubview:self.resultStackView];

    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.text = @"激活码将显示在这里";
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.resultLabel.font = [UIFont systemFontOfSize:16];
    self.resultLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.4 alpha:1.0];
    [self.resultStackView addArrangedSubview:self.resultLabel];
    
    self.activationCopyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.activationCopyButton setTitle:@"复制" forState:UIControlStateNormal];
    [self.activationCopyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.activationCopyButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    self.activationCopyButton.backgroundColor = [UIColor colorWithRed:0.25 green:0.6 blue:0.95 alpha:1.0];
    self.activationCopyButton.layer.cornerRadius = 18.0;
    [self.activationCopyButton addTarget:self action:@selector(copyCode) forControlEvents:UIControlEventTouchUpInside];
    self.activationCopyButton.hidden = YES;
    [self.resultStackView addArrangedSubview:self.activationCopyButton];

    self.footerLabel = [[UILabel alloc] init];
    self.footerLabel.text = @"交流学习，请勿违法";
    self.footerLabel.font = [UIFont systemFontOfSize:12];
    self.footerLabel.textColor = [UIColor lightGrayColor];
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.footerLabel];
    
    [self setupNotesCardView];
    
    [self setupConstraints];
    
    [self registerForKeyboardNotifications];
}

- (void)setupGradientBackground {
    self.view.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.colors = @[
        (__bridge id)[UIColor colorWithRed:0.9 green:0.95 blue:1.0 alpha:1.0].CGColor,
        (__bridge id)[UIColor colorWithRed:0.95 green:0.98 blue:1.0 alpha:1.0].CGColor
    ];
    gradientLayer.startPoint = CGPointMake(0.0, 0.0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    
    [self.view.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)setupCardView {
    self.cardView = [[UIView alloc] init];
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.cornerRadius = 20.0;
    self.cardView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
    self.cardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.cardView.layer.shadowRadius = 12.0;
    self.cardView.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.cardView];
}

- (void)setupResultCardView {
    self.resultCardView = [[UIView alloc] init];
    self.resultCardView.backgroundColor = [UIColor whiteColor];
    self.resultCardView.layer.cornerRadius = 20.0;
    self.resultCardView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
    self.resultCardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.resultCardView.layer.shadowRadius = 12.0;
    self.resultCardView.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.resultCardView];
}

- (void)setupNotesCardView {
    self.notesCardView = [[UIView alloc] init];
    self.notesCardView.backgroundColor = [UIColor whiteColor];
    self.notesCardView.layer.cornerRadius = 20.0;
    self.notesCardView.layer.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
    self.notesCardView.layer.shadowOffset = CGSizeMake(0, 4);
    self.notesCardView.layer.shadowRadius = 12.0;
    self.notesCardView.layer.shadowOpacity = 1.0;
    [self.view addSubview:self.notesCardView];
    
    self.notesTitleLabel = [[UILabel alloc] init];
    self.notesTitleLabel.text = @"使用须知";
    self.notesTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.notesTitleLabel.textColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.4 alpha:1.0];
    [self.notesCardView addSubview:self.notesTitleLabel];
    
    self.notesContentLabel = [[UILabel alloc] init];
    self.notesContentLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    
    NSString *notesText = @"• UUID 是通过设备的 identifierForVendor 生成的，在同一开发者的应用间保持唯一。\n"
                          @"• 如果您卸载并重新安装本应用，UUID 将会改变。\n"
                          @"• 生成的激活码仅用于学习和测试目的。";
                          
    NSDictionary *attributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:14],
        NSForegroundColorAttributeName: [UIColor colorWithRed:0.4 green:0.4 blue:0.5 alpha:1.0],
        NSParagraphStyleAttributeName: paragraphStyle
    };
    
    self.notesContentLabel.attributedText = [[NSAttributedString alloc] initWithString:notesText attributes:attributes];
    [self.notesCardView addSubview:self.notesContentLabel];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = -keyboardSize.height / 3;
        self.view.frame = frame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }];
}

- (void)setupConstraints {
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.deviceCodeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.getDeviceIDButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.deviceCodeTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.generateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.footerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.notesCardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.notesTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.notesContentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:30],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:25],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:20],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-20],
        
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:8],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:20],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-20],
        
        [self.deviceCodeLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:30],
        [self.deviceCodeLabel.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:25],
        
        [self.getDeviceIDButton.centerYAnchor constraintEqualToAnchor:self.deviceCodeLabel.centerYAnchor],
        [self.getDeviceIDButton.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-25],
        [self.deviceCodeLabel.trailingAnchor constraintLessThanOrEqualToAnchor:self.getDeviceIDButton.leadingAnchor constant:-10],

        [self.deviceCodeTextField.topAnchor constraintEqualToAnchor:self.deviceCodeLabel.bottomAnchor constant:10],
        [self.deviceCodeTextField.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:20],
        [self.deviceCodeTextField.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-20],
        [self.deviceCodeTextField.heightAnchor constraintEqualToConstant:50],
        
        [self.generateButton.topAnchor constraintEqualToAnchor:self.deviceCodeTextField.bottomAnchor constant:30],
        [self.generateButton.centerXAnchor constraintEqualToAnchor:self.cardView.centerXAnchor],
        [self.generateButton.widthAnchor constraintEqualToConstant:180],
        [self.generateButton.heightAnchor constraintEqualToConstant:44],
        [self.generateButton.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-25],
        
        [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.generateButton.centerXAnchor],
        [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.generateButton.centerYAnchor],
        
        [self.resultCardView.topAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:20],
        [self.resultCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.resultCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.resultStackView.topAnchor constraintEqualToAnchor:self.resultCardView.topAnchor constant:20],
        [self.resultStackView.leadingAnchor constraintEqualToAnchor:self.resultCardView.leadingAnchor constant:20],
        [self.resultStackView.trailingAnchor constraintEqualToAnchor:self.resultCardView.trailingAnchor constant:-20],
        [self.resultStackView.bottomAnchor constraintEqualToAnchor:self.resultCardView.bottomAnchor constant:-20],
        
        [self.resultLabel.widthAnchor constraintEqualToAnchor:self.resultStackView.widthAnchor],
        
        [self.activationCopyButton.widthAnchor constraintEqualToConstant:120],
        [self.activationCopyButton.heightAnchor constraintEqualToConstant:36],
        
        [self.notesCardView.topAnchor constraintEqualToAnchor:self.resultCardView.bottomAnchor constant:20],
        [self.notesCardView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [self.notesCardView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        
        [self.notesTitleLabel.topAnchor constraintEqualToAnchor:self.notesCardView.topAnchor constant:15],
        [self.notesTitleLabel.leadingAnchor constraintEqualToAnchor:self.notesCardView.leadingAnchor constant:20],
        [self.notesTitleLabel.trailingAnchor constraintEqualToAnchor:self.notesCardView.trailingAnchor constant:-20],
        
        [self.notesContentLabel.topAnchor constraintEqualToAnchor:self.notesTitleLabel.bottomAnchor constant:10],
        [self.notesContentLabel.leadingAnchor constraintEqualToAnchor:self.notesCardView.leadingAnchor constant:20],
        [self.notesContentLabel.trailingAnchor constraintEqualToAnchor:self.notesCardView.trailingAnchor constant:-20],
        [self.notesContentLabel.bottomAnchor constraintEqualToAnchor:self.notesCardView.bottomAnchor constant:-15],
        
        [self.footerLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-15],
        [self.footerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)getDeviceID {
    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    deviceID = [deviceID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if (deviceID.length > 20) {
        deviceID = [deviceID substringToIndex:20];
    }
    
    self.deviceCodeTextField.text = [deviceID uppercaseString];
    
    self.deviceCodeTextField.transform = CGAffineTransformMakeScale(1.05, 1.05);
    [UIView animateWithDuration:0.3 animations:^{
        self.deviceCodeTextField.transform = CGAffineTransformIdentity;
    }];
}

- (void)copyCode {
    if (self.currentActivationCode) {
        [UIPasteboard generalPasteboard].string = self.currentActivationCode;
        
        [self.activationCopyButton setTitle:@"已复制!" forState:UIControlStateNormal];
        self.activationCopyButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.7 blue:0.4 alpha:1.0];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.activationCopyButton setTitle:@"复制" forState:UIControlStateNormal];
            self.activationCopyButton.backgroundColor = [UIColor colorWithRed:0.25 green:0.6 blue:0.95 alpha:1.0];
        });
    }
}

- (void)generateActivationCode {
    [self.view endEditing:YES];
    NSString *deviceCode = self.deviceCodeTextField.text;
    
    if (!deviceCode || deviceCode.length < 20) {
        self.resultLabel.text = @"错误: 设备码必须至少包含20个字符";
        self.activationCopyButton.hidden = YES;
        [self shakeTextField:self.deviceCodeTextField];
        return;
    }
    
    [self.activityIndicator startAnimating];
    [self.generateButton setTitle:@"" forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *activationCode = [self generateActivationCodeFromDeviceCode:deviceCode];
        self.currentActivationCode = activationCode;
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"设备码: "
                                                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]}];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:deviceCode
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n激活码: "
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium]}]];
        [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:activationCode
                                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightBold],
                                                                                             NSForegroundColorAttributeName: [UIColor colorWithRed:0.2 green:0.5 blue:0.9 alpha:1.0]}]];
        
        self.resultLabel.attributedText = attributedString;
        
        self.activationCopyButton.hidden = NO;
        [self.activationCopyButton setTitle:@"复制" forState:UIControlStateNormal];
        self.activationCopyButton.backgroundColor = [UIColor colorWithRed:0.25 green:0.6 blue:0.95 alpha:1.0];

        [self.activityIndicator stopAnimating];
        [self.generateButton setTitle:@"生成激活码" forState:UIControlStateNormal];
        
        [self animateSuccess];
    });
}

- (void)shakeTextField:(UITextField *)textField {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[@(-10), @(10), @(-8), @(8), @(-5), @(5), @(0)];
    [textField.layer addAnimation:animation forKey:@"shake"];
    
    textField.layer.borderColor = [UIColor colorWithRed:0.9 green:0.3 blue:0.3 alpha:1.0].CGColor;
    textField.layer.borderWidth = 1.0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        textField.layer.borderWidth = 0.0;
    });
}

- (void)animateSuccess {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    [self.resultCardView.layer addAnimation:transition forKey:nil];
    
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.duration = 0.2;
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.05];
    pulseAnimation.autoreverses = YES;
    [self.resultCardView.layer addAnimation:pulseAnimation forKey:nil];
}

- (NSString *)generateActivationCodeFromDeviceCode:(NSString *)deviceCode {
    NSString *secretKey = @"KeyboardTheme2023ActivationSecret";
    
    const char *cKey = [secretKey cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [deviceCode cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSMutableString *hexString = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [hexString appendFormat:@"%02x", cHMAC[i]];
    }
    
    NSMutableString *activationCode = [NSMutableString string];
    for (int i = 0; i < 24; i++) {
        if (i > 0 && i % 4 == 0) {
            [activationCode appendString:@"-"];
        }
        
        NSUInteger index = (7 * i + 3) % [hexString length];
        unichar character = [hexString characterAtIndex:index];
        [activationCode appendFormat:@"%c", character];
    }
    
    return [activationCode uppercaseString];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
