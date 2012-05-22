<div style="width:852px; height: 489px; position: relative; margin: 30px auto;"> 
<img style="position: relative; width: 852px; height: 489px; margin: 0;" src="http://cl.ly/270g1q1e012L1l3n3H0u/GithubHeader.gif" alt="JMStaticTableViewController"/>
</div>

A `UITableViewController` subclass that allows you easily and simply display content similar to what is found in iOS's built-in Settings application. It also allows you to easily create `UITableViewControllers` that collection information.

Requirements: You'll need to build your project that is using `JMStaticContentTableViewController` with a compiler that supports Automatic Reference Counting. Your project does not have to use ARC to use this library.

### Example Usage

#### Adding a section and a cell

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

#### Inserting cells

``` objc

// Somewhere else you'd probably load some data somehow and then want to insert rows for the new items in that data

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

``` objc
// Normal table view functionality is completely retained, for example,
// here we're inserting a bunch of cells inside a beginUpdates/endUpdates block
// so all our new cells will animate in simultaneously and look awesome.

[self.tableView beginUpdates];

for(SomeModelObject *o in self.objects) {
	[self insertCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
		staticContentCell.reuseIdentifier = @"SomeCell";
	
		cell.textLabel.text
	} atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES];
}

[self.tableView endUpdates];
	
// The library uses the UITableViewRowAnimationAutomatic 
```

#### Animation

Anytime you ask `JMStaticContentTableViewController` to animate the inserting or deleting of cells or sections, it will use the `UITableViewRowAnimation` style of `UITableViewRowAnimationAutomatic` under the hood, so all of your animations will look great.

