# JMStaticContentTableViewController

A simple way to build Settings-style screens for iOS apps.

`JMStaticContentTableViewController` allows you to easily and simply display "static content" like iOS Settings, About screens, Login forms, or any screen that displays or collects information in a table format.

Originally built with blocks in Objective-C, now fully rewritten in Swift with both UIKit and SwiftUI support.

## Features

- **Declarative API** - Build table views with simple, readable code
- **UIKit Support** - `JMStaticContentTableViewController` subclass
- **SwiftUI Support** - `JMStaticContentList` view component
- **Built-in Cell Types** - Text, toggle, value display cells
- **Section Management** - Add, insert, remove sections with animations
- **Custom Cells** - Use any `UITableViewCell` subclass
- **Backward Compatible** - Original Objective-C API still works
- **Thread-safe** - All operations properly synchronize with the table view

## Requirements

- iOS 15.0+ / macOS 12.0+ / tvOS 15.0+
- Swift 5.9+
- Xcode 15.0+

For older iOS versions (5.0-14.x), use the legacy Objective-C implementation included in this repo.

## Installation

### Swift Package Manager (Recommended)

Add JMStaticContentTableViewController to your project via SPM:

```swift
dependencies: [
    .package(url: "https://github.com/jakemarsh/JMStaticContentTableViewController.git", from: "2.0.0")
]
```

Or in Xcode: File → Add Package Dependencies → Enter the repository URL.

### CocoaPods (Legacy)

```ruby
pod 'JMStaticContentTableViewController'
```

## Quick Start

### Swift (UIKit)

```swift
import JMStaticContentTableViewController

class SettingsViewController: JMStaticContentTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add an Account section
        addSection { section, _ in
            section.headerTitle = "Account"

            // Navigation cell
            section.addCell(.text("Profile", onSelect: { [weak self] _ in
                self?.navigationController?.pushViewController(ProfileViewController(), animated: true)
            }))

            // Toggle cell
            section.addCell(.toggle("Notifications", isOn: true) { isOn in
                UserDefaults.standard.set(isOn, forKey: "notifications")
            })

            // Value display cell
            section.addCell(.value("Version", value: "2.0.0"))
        }

        // Add an About section
        addSection { section, _ in
            section.headerTitle = "About"
            section.footerTitle = "Thanks for using our app!"

            section.addCell(.text("Terms of Service", onSelect: { _ in
                // Open terms
            }))
        }
    }
}
```

### SwiftUI

```swift
import JMStaticContentTableViewController

struct SettingsView: View {
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationView {
            JMStaticContentList {
                JMStaticContentListSection(header: "Account") {
                    JMStaticContentListRow("Profile", systemImage: "person.circle") {
                        ProfileView()
                    }

                    JMStaticContentListToggle("Notifications", isOn: $notificationsEnabled)

                    JMStaticContentListRow("Version", value: "2.0.0")
                }

                JMStaticContentListSection(header: "About", footer: "Thanks for using our app!") {
                    JMStaticContentListRow("Terms of Service") {
                        // Handle tap
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
```

### Objective-C (Legacy)

```objc
#import "JMStaticContentTableViewController.h"

- (void)viewDidLoad {
    [super viewDidLoad];

    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
        section.headerTitle = @"Account";

        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
            staticContentCell.cellStyle = UITableViewCellStyleValue1;
            cell.textLabel.text = @"Wi-Fi";
            cell.detailTextLabel.text = @"Connected";
        } whenSelected:^(NSIndexPath *indexPath) {
            [self.navigationController pushViewController:[[WifiViewController alloc] init] animated:YES];
        }];
    }];
}
```

## Cell Types

### Text Cell

```swift
// Simple text
section.addCell(.text("Label"))

// With subtitle
section.addCell(.text("Label", detailText: "Subtitle"))

// With image
section.addCell(.text("Label", image: UIImage(systemName: "star")))

// With selection handler
section.addCell(.text("Label", onSelect: { indexPath in
    // Handle selection
}))
```

### Toggle Cell

```swift
section.addCell(.toggle("Enable Feature", isOn: currentValue) { newValue in
    // Handle toggle change
})
```

### Value Cell

```swift
section.addCell(.value("Version", value: "2.0.0"))
```

### Custom Cell

```swift
let cell = JMStaticContentCell(
    reuseIdentifier: "CustomCell",
    cellClass: MyCustomCell.self,
    height: 80
)

cell.configureBlock = { cellConfig, tableViewCell, indexPath in
    guard let customCell = tableViewCell as? MyCustomCell else { return }
    customCell.configure(with: myData)
}

cell.whenSelectedBlock = { indexPath in
    // Handle selection
}

section.addCell(cell)
```

## Section Management

```swift
// Add a section
addSection { section, index in
    section.headerTitle = "New Section"
    // Add cells...
}

// Insert a section at a specific index
insertSection({ section, index in
    // Configure section...
}, at: 1, animated: true)

// Remove a section
removeSection(at: 0, animated: true)

// Remove all sections
removeAllSections()

// Reload a section
reloadSection(at: 0, animated: true)
```

## Migration from v1.x (Objective-C)

The Swift rewrite maintains API compatibility. Most Objective-C code will continue to work. For Swift projects:

| Old API (Obj-C) | New API (Swift) |
|-----------------|-----------------|
| `[self addSection:^...]` | `addSection { section, index in ... }` |
| `section.headerTitle = @"Title"` | `section.headerTitle = "Title"` |
| `[section addCell:^... whenSelected:^...]` | `section.addCell(.text("Label", onSelect: { ... }))` |
| `[self removeAllSections]` | `removeAllSections()` |

## How It Works

Images can be in three states when you add them:

1. **Configure Block** - Called each time the cell is displayed, configure the UITableViewCell here
2. **When Selected Block** - Called when the user taps the cell, handle navigation or actions here
3. **Automatic Cell Reuse** - Cells are automatically dequeued and reused based on the reuse identifier

## Demo App

The repository includes a Settings example app demonstrating typical usage patterns like:

- Wi-Fi network selection with animated row insertion
- Toggle controls for settings
- Navigation between screens
- Section headers and footers

## License

JMStaticContentTableViewController is available under the MIT license. See the LICENSE file for details.

## Author

Jake Marsh ([@jakemarsh](https://twitter.com/jakemarsh))

Originally created in 2011, rewritten in Swift in 2024.
