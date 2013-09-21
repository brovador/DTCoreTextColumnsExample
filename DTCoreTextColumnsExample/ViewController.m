//
//  ViewController.m
//  DTCoreTextColumnsExample
//
//  Created by Jesús on 21/09/13.
//  Copyright (c) 2013 Jesús. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self _loadColumnLayoutedText];
}

- (void)_loadColumnLayoutedText
{
    [self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    
    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TextSample" ofType:@"txt"]
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    
    CGRect workingRect = CGRectInset(self.view.bounds, 20, 20), column1, column2, column3;
    CGFloat columnSize = CGRectGetWidth(workingRect) / 3.f;
    CGRectDivide(workingRect, &column1, &workingRect, columnSize, CGRectMinXEdge);
    CGRectDivide(workingRect, &column2, &workingRect, columnSize, CGRectMinXEdge);
    CGRectDivide(workingRect, &column3, &workingRect, columnSize, CGRectMinXEdge);
    
    column1 = CGRectIntegral(CGRectInset(column1, 5, 0));
    column2 = CGRectIntegral(CGRectInset(column2, 5, 0));
    column3 = CGRectIntegral(CGRectInset(column3, 5, 0));
    
    NSInteger textRangeInit;
    DTHTMLAttributedStringBuilder *stringBuilder;
    DTCoreTextLayoutFrame *layoutFrame;
    DTAttributedTextView *textView;
    DTCoreTextLayouter *layouter;
    NSAttributedString *attrString;
    
    stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:[text dataUsingEncoding:NSUTF8StringEncoding] options:nil documentAttributes:NULL];
    attrString = [stringBuilder generatedAttributedString];
    layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:attrString];
    
    NSRange range1, range2, range3;
    
    textRangeInit = 0;
    layoutFrame = [layouter layoutFrameWithRect:(CGRect){.origin = CGPointZero, .size = column1.size} range:NSMakeRange(textRangeInit, 0)];
    range1 = [layoutFrame visibleStringRange];
    
    textRangeInit = range1.location + range1.length;
    layoutFrame = [layouter layoutFrameWithRect:(CGRect){.origin = CGPointZero, .size = column2.size} range:NSMakeRange(textRangeInit, 0)];
    range2 = [layoutFrame visibleStringRange];
    
    textRangeInit = range2.location + range2.length;
    layoutFrame = [layouter layoutFrameWithRect:(CGRect){.origin = CGPointZero, .size = column3.size} range:NSMakeRange(textRangeInit, 0)];
    range3 = [layoutFrame visibleStringRange];
    
    //Column1
    textView = [[DTAttributedTextView alloc] initWithFrame:column1];
    [textView setAttributedString:[attrString attributedSubstringFromRange:range1]];
    [self.view addSubview:textView];
    
    //Column2
    textView = [[DTAttributedTextView alloc] initWithFrame:column2];
    [textView setAttributedString:[attrString attributedSubstringFromRange:range2]];
    [self.view addSubview:textView];
    
    //Column3
    textView = [[DTAttributedTextView alloc] initWithFrame:column3];
    [textView setAttributedString:[attrString attributedSubstringFromRange:range3]];
    [self.view addSubview:textView];
}

@end
