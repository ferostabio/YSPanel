YSPanel
===

YSPanel uses KVO and the Objective-C runtime to attach a view to the `UIScrollView` indicator and at the same time to provide some useful information.

**Usage**

```
[_scrollView addDefaultPanelWithBlock:^(CGPoint location, CGFloat percent) {
	// Do your thing
}];
```

You can use it in a `UIWebView` by using `_webView.scrollView` instead. And if you have a `UITextView` or a `UITableView`, by calling the following convenience methods you can get the text line and the index path.

```
[_textView addTextViewPanelWithBlock:^(CGPoint location, NSInteger line) {
	// Etc  
}];

[_tableView addTableViewPanelWithBlock:^(CGPoint location, NSIndexPath *indexPath) {
	// Etc
}];

```

**Customization**

By defeault `YSPanel` has a view attached to the scroll view's bar on the right. 

```
@property (nonatomic, strong) YSPanelView *panelView;
```

It is possible to do some customizing to it and center it, but most important: you can add any view to it by setting the customView property. `YSPanelView` object has the following properties:

```
@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL centered;
```

**Installation**

Manual: just drag and drop `UIScrollView+YSPanel` .h and .m onto your project. You have to include `QuartzCore` and, in case you aren't using arc, ***you should***.

**License**

Copyright (c) 2013 Federico Erostarbe.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

