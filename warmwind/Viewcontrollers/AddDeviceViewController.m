//
//  AddDeviceViewController.m
//  warmwind
//
//  Created by guiping on 17/2/21.
//  Copyright © 2017年 galaxyWind. All rights reserved.
//

#import "AddDeviceViewController.h"

@interface AddDeviceViewController ()<UITextFieldDelegate>
{
    UITextField *tfDeviceId;
    UITextField *tfPassword;
    UIButton *btnAdd;
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = [ChangeLanguage getContentWithKey:@"add0"];
    [self createViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldLength:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //NSLog(@"%s", object_getClassName(self));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --------------- UITextFieldDelegate ----------------
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField becomeFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == tfDeviceId) {
        previousSelection = textField.selectedTextRange;
        previousTextFieldContent = textField.text;
    }
    else if (textField == tfPassword) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        else if (tfPassword.text.length >= 32) {
            tfPassword.text = [textField.text substringToIndex:32];
            return NO;
        }
    }
    return YES;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([tfDeviceId becomeFirstResponder] || [tfPassword becomeFirstResponder]) {
        [tfDeviceId resignFirstResponder];
        [tfPassword resignFirstResponder];
    }
}

#pragma mark --------------- UIButton点击事件 ----------------
- (void) btnAddClicked:(UIButton *) sender{
    if (tfDeviceId.text.length == 14) {
//        if (tfPassword.text.length == 0) {
//            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search8"]];
//            return;
//        }
        BOOL insertState = [[DataBaseManager sharedManager] addDeviceWithDeviceId:(long long)[[tfDeviceId.text stringByReplacingOccurrencesOfString:@" "withString:@""] integerValue] deviceName:@"HC暖风机200" password:tfPassword.text];
        if (insertState) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }
        else{
            [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"search9"]];
        }
    }
    else{
        [GPUtil hintView:self.view message:[ChangeLanguage getContentWithKey:@"add4"]];
    }
}

- (void) textFieldLength:(NSNotification *) sender{
    if (tfDeviceId.text.length > 0 && tfPassword.text.length > 0) {
        btnAdd.enabled = YES;
        btnAdd.backgroundColor = THEME_COLOR;
    }
    else{
        btnAdd.enabled = NO;
        btnAdd.backgroundColor = BTN_ENABLED_BGCOLOR;
    }
}

- (void) createViews{
    UILabel *lbTemp = nil;
    CGRect maxRect = CGRectZero;
    // 创建序列号标签
    UILabel *lbDeviceId = [[UILabel alloc] init];
    lbDeviceId.text = [ChangeLanguage getContentWithKey:@"add1"];
    lbDeviceId.font = [UIFont systemFontOfSize:15];
    CGRect lbDeviceIdR = LABEL_RECT(lbDeviceId.text, 0, 0, 1, 15);
    maxRect = lbDeviceIdR;
    lbTemp = lbDeviceId;
    [self.view addSubview:lbDeviceId];
    // 创建密码标签
    UILabel *lbPassword = [[UILabel alloc] init];
    lbPassword.text = [ChangeLanguage getContentWithKey:@"search2"];
    lbPassword.font = [UIFont systemFontOfSize:15];
    CGRect lbPasswordR = LABEL_RECT(lbPassword.text, 0, 0, 1, 15);
    if (lbPasswordR.size.width > maxRect.size.width) {
        maxRect = lbPasswordR;
        lbTemp = lbPassword;
    }
    [self.view addSubview:lbPassword];
    lbDeviceId.frame = CGRectMake(POINT_X(81), POINT_Y(129) + 64, maxRect.size.width + 1, maxRect.size.height);
    lbPassword.frame = CGRectMake(POINT_X(81), POINT_Y(315) + 64, maxRect.size.width + 1, maxRect.size.height);
    CGPoint lbSSIDCenter = lbDeviceId.center;
    CGPoint lbPasswordCenter = lbPassword.center;
    [lbDeviceId setAlignmentLeftAndRight];
    [lbPassword setAlignmentLeftAndRight];
    
    
    // 创建序列号输入框
    tfDeviceId = [GPUtil createTextField];
    tfDeviceId.frame = CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(120) - CGRectGetMaxX(lbTemp.frame), GPHEIGHT(150));
    tfDeviceId.center = CGPointMake((CGRectGetMaxX(lbDeviceId.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfDeviceId.frame)) / 2, lbSSIDCenter.y);
    tfDeviceId.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:tfDeviceId];
    tfDeviceId.delegate = self;
    tfDeviceId.placeholder = [ChangeLanguage getContentWithKey:@"add2"];
    [tfDeviceId becomeFirstResponder];
    [tfDeviceId addTarget:self action:@selector(reformatAsPhoneNumber:) forControlEvents:UIControlEventEditingChanged];
    
    // 密码输入框
    tfPassword = [GPUtil createTextField];
    tfPassword.frame = CGRectMake(0, 0, KSCREEN_WIDTH - GPWIDTH(120) - CGRectGetMaxX(lbTemp.frame), GPHEIGHT(150));
    tfPassword.center = CGPointMake((CGRectGetMaxX(lbPassword.frame) + GPWIDTH(39)) + (CGRectGetWidth(tfPassword.frame)) / 2, lbPasswordCenter.y);
    tfPassword.keyboardType = UIKeyboardTypeASCIICapable;
    tfPassword.secureTextEntry = YES;
    [self.view addSubview:tfPassword];
    tfPassword.delegate = self;
    tfPassword.placeholder = [ChangeLanguage getContentWithKey:@"add6"];
    
    // 创建添加按钮
    btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btnAdd];
    btnAdd.frame = CGRectMake((KSCREEN_WIDTH - GPWIDTH(1077)) / 2, CGRectGetMaxY(tfPassword.frame) + POINT_Y(114), GPWIDTH(1077), GPHEIGHT(165));
    [btnAdd setTitle:[ChangeLanguage getContentWithKey:@"add3"] forState:UIControlStateNormal];
    btnAdd.titleLabel.font = [UIFont systemFontOfSize:20];
    btnAdd.backgroundColor = BTN_ENABLED_BGCOLOR;
    btnAdd.enabled = NO;
    [btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)reformatAsPhoneNumber:(UITextField *)textField {
    // 光标位置
    NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    NSString *deviceIdWithoutSpaces = [self removeNonDigits:textField.text andPreserveCursorPosition:&targetCursorPostion];
    
    if([deviceIdWithoutSpaces length] > 12) {
        textField.text = previousTextFieldContent;
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    NSString *deviceIdWithSpaces = [self insertSpacesEveryFourDigitsIntoString:deviceIdWithoutSpaces andPreserveCursorPosition:&targetCursorPostion];
    textField.text = deviceIdWithSpaces;
    UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
}


- (NSString *)removeNonDigits:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition {
    NSUInteger originalCursorPosition = *cursorPosition;
    NSMutableString *digitsOnlyString = [NSMutableString string];
    
    for (NSUInteger i=0; i<string.length; i++) {
        unichar characterToAdd = [string characterAtIndex:i];
        
        if(isdigit(characterToAdd)) {
            NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
            [digitsOnlyString appendString:stringToAdd];
        }
        else {
            if(i < originalCursorPosition) {
                (*cursorPosition)--;
            }
        }
    }
    return digitsOnlyString;
}


- (NSString *)insertSpacesEveryFourDigitsIntoString:(NSString *)string andPreserveCursorPosition:(NSUInteger *)cursorPosition{
    NSMutableString *stringWithAddedSpaces = [NSMutableString new];
    NSUInteger cursorPositionInSpacelessString = *cursorPosition;
    for (NSUInteger i=0; i<string.length; i++) {
        if(i > 0) {
            if(i==4 || i==8) {
                [stringWithAddedSpaces appendString:@" "];
                if(i < cursorPositionInSpacelessString) {
                    (*cursorPosition)++;
                }
            }
        }
        unichar characterToAdd = [string characterAtIndex:i];
        NSString *stringToAdd = [NSString stringWithCharacters:&characterToAdd length:1];
        [stringWithAddedSpaces appendString:stringToAdd];
    }
    return stringWithAddedSpaces;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
