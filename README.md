<div style="width:852px; height: 489px; position: relative; margin: 30px auto;"> 
<img style="position: relative; width: 852px; height: 489px; margin: 0;" src="http://cl.ly/270g1q1e012L1l3n3H0u/GithubHeader.gif" alt="JMStaticTableViewController"/>
</div>

A `UITableViewController` subclass that allows you easily and simply display content similar to what is found in iOS's built-in Settings application. It also allows you to easily create `UITableViewControllers` that collection information.

## Requirements

You'll need to build your project that is using `JMStaticContentTableViewController` with a compiler that supports Automatic Reference Counting. Your project does not have to use ARC to use this library.

## Example Usage

### Adding a section and a cell

``` objc
- (void) viewDidLoad {
	[super viewDidLoad];

	[self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			staticContentCell.cellStyle = UITableViewCellStyleValue1;
			staticContentCell.reuseIdentifier = @"DetailTextCell";

			cell.textLabel.text = NSLocalizedString(@"Wi-Fi", @"Wi-Fi");
			cell.detailTextLabel.text = NSLocalizedString(@"T.A.R.D.I.S.", @"T.A.R.D.I.S.");
		} whenSelected:^(NSIndexPath *indexPath) {
			[self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
		}];
	}];
}
```

### Inserting A Cell

``` objc

- (void) _someTaskFinished {
	[self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
		staticContentCell.reuseIdentifier = @"WifiNetworkCell";
		staticContentCell.tableViewCellSubclass = [WifiNetworkTableViewCell class];

		cell.textLabel.text = network.networkName;
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		cell.indentationLevel = 2;
		cell.indentationWidth = 10.0;
	} whenSelected:^(NSIndexPath *indexPath) {
		// TODO
	} atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

```

### Inserting Multiple Cells

``` objc

// Somewhere else you'd probably load some data somehow,
// then want to insert rows for the new items in that data.

// Normal table view functionality is completely retained, for example,
// here we're inserting a bunch of cells inside a beginUpdates/endUpdates block
// so all our new cells will animate in simultaneously and look awesome.

[self.tableView beginUpdates];

for(SomeModelObject *o in self.awesomeModelObjects) {
	[self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
		staticContentCell.reuseIdentifier = @"SomeCell";
	
		cell.textLabel.text
	} atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

[self.tableView endUpdates];
	
```

### Animation

Anytime you ask `JMStaticContentTableViewController` to animate the inserting or deleting of cells or sections, it will use the `UITableViewRowAnimation` style of `UITableViewRowAnimationAutomatic` under the hood, so all of your animations will look great.


## Adding To Your Project

### CocoaPods (The New Easy Way)

If you are using [CocoaPods](http://cocoapods.org) then just add this line to your `Podfile`:

``` ruby
dependency 'JMStaticContentTableViewController'
```

Now run `pod install` to install the dependency.

### Manually (The Old Hard Way)

[Download](https://github.com/jakemarsh/JMStaticContentTableViewController/zipball/master) the source files or add it as a [git submodule](http://schacon.github.com/git/user-manual.html#submodules). Here's how to add it as a submodule:

    $ cd YourProject
    $ git submodule add https://github.com/jakemarsh/JMStaticContentTableViewController.git Vendor/JMStaticContentTableViewController

Add all of the files inside the folder named "JMStaticContentTableViewController" to your project.

### ARC

`JMStaticContentTableViewController` uses [Automatic Reference Counting (ARC)](http://clang.llvm.org/docs/AutomaticReferenceCounting.html). You should be using ARC too, it's the future. If your project doesn't use ARC, you will need to set the `-fobjc-arc compiler` flag on all of the SSPullToRefresh source files. To do this in Xcode, go to your active target and select the "Build Phases" tab. In the "Compiler Flags" column, set `-fobjc-arc` for each of the `JMStaticContentTableViewController` source files.

### "This Library is Bad, and You Should Feel Bad"

This is a very opinionated library. It makes assumptions and defines conventions that might not fit perfectly with everyone's codebase or app. If you are one of those people, please feel free to submit a pull request.

