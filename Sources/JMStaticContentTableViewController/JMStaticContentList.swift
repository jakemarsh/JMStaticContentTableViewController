//
//  JMStaticContentList.swift
//  JMStaticContentTableViewController
//
//  Created by Jake Marsh on 12/31/24.
//  Copyright 2024-2025 Jake Marsh. All rights reserved.
//

import SwiftUI

/// A SwiftUI view for displaying static content in a list format.
///
/// `JMStaticContentList` provides similar functionality to `JMStaticContentTableViewController`
/// but uses SwiftUI's declarative syntax.
///
/// ## Basic Usage
///
/// ```swift
/// JMStaticContentList {
///     JMStaticContentListSection(header: "Account") {
///         JMStaticContentListRow("Profile") {
///             // Navigate to profile
///         }
///
///         JMStaticContentListToggle("Notifications", isOn: $notifications)
///     }
///
///     JMStaticContentListSection(header: "About") {
///         JMStaticContentListRow("Version", value: "1.0.0")
///     }
/// }
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct JMStaticContentList<Content: View>: View {

    private let content: Content
    private let headerText: String?
    private let footerText: String?

    /// Creates a static content list.
    /// - Parameters:
    ///   - headerText: Optional text to display at the top.
    ///   - footerText: Optional text to display at the bottom.
    ///   - content: The sections and rows to display.
    public init(
        headerText: String? = nil,
        footerText: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.headerText = headerText
        self.footerText = footerText
        self.content = content()
    }

    public var body: some View {
        List {
            if let headerText {
                Section {
                    Text(headerText)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                }
            }

            content

            if let footerText {
                Section {
                    Text(footerText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                }
            }
        }
    }
}

// MARK: - Section

/// A section in a static content list.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct JMStaticContentListSection<Content: View>: View {

    private let header: String?
    private let footer: String?
    private let content: Content

    /// Creates a section with optional header and footer.
    /// - Parameters:
    ///   - header: Optional header text.
    ///   - footer: Optional footer text.
    ///   - content: The rows in this section.
    public init(
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header
        self.footer = footer
        self.content = content()
    }

    public var body: some View {
        Section {
            content
        } header: {
            if let header {
                Text(header)
            }
        } footer: {
            if let footer {
                Text(footer)
            }
        }
    }
}

// MARK: - Row Types

/// A navigation row in a static content list.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct JMStaticContentListRow<Destination: View>: View {

    private let title: String
    private let subtitle: String?
    private let value: String?
    private let systemImage: String?
    private let destination: Destination?
    private let action: (() -> Void)?

    /// Creates a navigation row with a destination view.
    /// - Parameters:
    ///   - title: The row title.
    ///   - subtitle: Optional subtitle.
    ///   - systemImage: Optional SF Symbol name.
    ///   - destination: The destination view.
    public init(
        _ title: String,
        subtitle: String? = nil,
        systemImage: String? = nil,
        @ViewBuilder destination: () -> Destination
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = nil
        self.systemImage = systemImage
        self.destination = destination()
        self.action = nil
    }

    public var body: some View {
        if let destination {
            NavigationLink(destination: destination) {
                rowContent
            }
        } else if let action {
            Button(action: action) {
                rowContent
            }
        } else {
            rowContent
        }
    }

    @ViewBuilder
    private var rowContent: some View {
        HStack {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.accentColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                if let subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            if let value {
                Spacer()
                Text(value)
                    .foregroundColor(.secondary)
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public extension JMStaticContentListRow where Destination == EmptyView {

    /// Creates a row that performs an action when tapped.
    /// - Parameters:
    ///   - title: The row title.
    ///   - subtitle: Optional subtitle.
    ///   - systemImage: Optional SF Symbol name.
    ///   - action: The action to perform.
    init(
        _ title: String,
        subtitle: String? = nil,
        systemImage: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.value = nil
        self.systemImage = systemImage
        self.destination = nil
        self.action = action
    }

    /// Creates a value display row (non-interactive).
    /// - Parameters:
    ///   - title: The row title.
    ///   - value: The value to display.
    ///   - systemImage: Optional SF Symbol name.
    init(
        _ title: String,
        value: String,
        systemImage: String? = nil
    ) {
        self.title = title
        self.subtitle = nil
        self.value = value
        self.systemImage = systemImage
        self.destination = nil
        self.action = nil
    }
}

// MARK: - Toggle Row

/// A toggle row in a static content list.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct JMStaticContentListToggle: View {

    private let title: String
    private let systemImage: String?
    @Binding private var isOn: Bool

    /// Creates a toggle row.
    /// - Parameters:
    ///   - title: The toggle label.
    ///   - systemImage: Optional SF Symbol name.
    ///   - isOn: Binding to the toggle state.
    public init(
        _ title: String,
        systemImage: String? = nil,
        isOn: Binding<Bool>
    ) {
        self.title = title
        self.systemImage = systemImage
        self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            HStack {
                if let systemImage {
                    Image(systemName: systemImage)
                        .foregroundColor(.accentColor)
                }
                Text(title)
            }
        }
    }
}

// MARK: - Button Row

/// A button row in a static content list.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
public struct JMStaticContentListButton: View {

    private let title: String
    private let role: ButtonRole?
    private let action: () -> Void

    /// Creates a button row.
    /// - Parameters:
    ///   - title: The button title.
    ///   - role: Optional button role (e.g., .destructive).
    ///   - action: The action to perform.
    public init(
        _ title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }

    public var body: some View {
        Button(role: role, action: action) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 15.0, macOS 12.0, tvOS 15.0, *)
struct JMStaticContentList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            JMStaticContentList {
                JMStaticContentListSection(header: "Account") {
                    JMStaticContentListRow("Profile", systemImage: "person.circle") {
                        Text("Profile View")
                    }
                    JMStaticContentListRow("Version", value: "1.0.0")
                }

                JMStaticContentListSection(header: "Settings") {
                    JMStaticContentListToggle("Notifications", isOn: .constant(true))
                    JMStaticContentListToggle("Dark Mode", isOn: .constant(false))
                }

                JMStaticContentListSection {
                    JMStaticContentListButton("Log Out", role: .destructive) {
                        print("Logged out")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
#endif
