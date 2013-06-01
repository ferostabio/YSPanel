YSPanel
===

By using YSPanel it's posible to have a deeper control and knowledge of a UIScrollView in a simple way. All the magic is done thanks to KVO, since YSPanelViewController observes the contentOffset property of a UIScrollView (or one of it's subclasses).
  
**Usage**

Subclass YSPanelViewController and implement one of the following methods on viewDidLoad:

    - (void) observeBarLocation:(UIScrollView *)sv withBlock:(DefaultBlock)block;
    - (void) observeBarLocationForTextView:(UITextView *)sv withBlock:(TextViewBlock)block;
    - (void) observeBarLocationForTableView:(UITableView *)sv withBlock:(TableViewBlock)block;


**Example**

The default methods for any UIScrollView subclass and returns a block with the location and the percent of the bar's content.

    [self observeBarLocation:_webView.scrollView withBlock:^(CGPoint location, CGFloat percent) {
        NSLog(@"%f%%", percent);
    }];
   
There are also convenience methods to track a UITableView (which returns the indexPath instead of the percent) and a UITextView, which returns the line number.

    [self observeBarLocationForTextView:_textView withBlock:^(CGPoint location, NSInteger line) {
        NSLog(@"%d", line);
    }];

**Custom View**

By defeault YSPanelViewController has a view attached on the right, near the scroll bar. But it is possible to attach any view and position it both on the right and at the center of the screen by calling the following method

    - (void) attachView:(UIView *)v centered:(BOOL)flag;

**Installing**

Drag and drop YSPanelViewController .h and .m onto your project.
  
**Dependencies**

The only requirement to use YSPanel is to include in the project QuartzCore.
  
**License**

Copyright (c) 2013 Federico Erostarbe.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

