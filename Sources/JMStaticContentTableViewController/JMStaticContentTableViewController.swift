//
//  JMStaticContentTableViewController.swift
//  JMStaticContentTableViewController
//
//  Created by Jake Marsh on 10/8/11.
//  Rewritten in Swift on 12/31/24.
//  Copyright 2011-2025 Jake Marsh. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A table view controller for static content like settings screens.
///
/// `JMStaticContentTableViewController` provides a simple, declarative way to create
/// static table views with sections and cells, similar to iOS Settings.
///
/// ## Basic Usage
///
/// ```swift
/// class SettingsViewController: JMStaticContentTableViewController {
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         addSection { section, _ in
///             section.headerTitle = "Account"
///
///             section.addCell(.text("Profile", onSelect: { _ in
///                 // Navigate to profile
///             }))
///
///             section.addCell(.toggle("Notifications", isOn: true) { isOn in
///                 // Handle toggle
///             })
///         }
///     }
/// }
/// ```
open class JMStaticContentTableViewController: UITableViewController {

    // MARK: - Properties

    /// All sections in the table view.
    public private(set) var sections: [JMStaticContentSection] = []

    /// Text displayed in the table header.
    public var headerText: String? {
        didSet { updateHeaderView() }
    }

    /// Text displayed in the table footer.
    public var footerText: String? {
        didSet { updateFooterView() }
    }

    // MARK: - Lifecycle

    open override func viewDidLoad() {
        super.viewDidLoad()
        removeAllSections()
    }

    // MARK: - Section Management

    /// Adds a new section to the table view.
    /// - Parameter block: Configuration block for the section.
    public func addSection(_ block: (JMStaticContentSection, Int) -> Void) {
        let section = JMStaticContentSection()
        section.tableView = tableView
        section.sectionIndex = sections.count

        block(section, section.sectionIndex)

        sections.append(section)
        updateSectionIndexes()
    }

    /// Inserts a section at the specified index.
    /// - Parameters:
    ///   - block: Configuration block for the section.
    ///   - index: The index to insert at.
    ///   - animated: Whether to animate the insertion.
    public func insertSection(
        _ block: (JMStaticContentSection, Int) -> Void,
        at index: Int,
        animated: Bool = true
    ) {
        let section = JMStaticContentSection()
        section.tableView = tableView

        block(section, index)

        sections.insert(section, at: index)
        updateSectionIndexes()

        if animated {
            tableView.insertSections(IndexSet(integer: index), with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    /// Removes all sections from the table view.
    ///
    /// This method properly synchronizes the data source with the table view to prevent crashes.
    public func removeAllSections() {
        sections.removeAll()
        // FIX for issue #4: Always reload data after removing sections
        tableView.reloadData()
    }

    /// Removes the section at the specified index.
    /// - Parameters:
    ///   - index: The index of the section to remove.
    ///   - animated: Whether to animate the removal.
    public func removeSection(at index: Int, animated: Bool = true) {
        guard index < sections.count else { return }

        sections.remove(at: index)
        updateSectionIndexes()

        if animated {
            tableView.beginUpdates()
            tableView.deleteSections(IndexSet(integer: index), with: .automatic)
            tableView.endUpdates()
        } else {
            tableView.reloadData()
        }
    }

    /// Reloads the section at the specified index.
    /// - Parameters:
    ///   - index: The index of the section to reload.
    ///   - animated: Whether to animate the reload.
    public func reloadSection(at index: Int, animated: Bool = true) {
        guard index < sections.count else { return }

        let animation: UITableView.RowAnimation = animated ? .automatic : .none
        tableView.reloadSections(IndexSet(integer: index), with: animation)
    }

    /// Returns the section at the specified index.
    /// - Parameter index: The section index.
    /// - Returns: The section at the index, or nil if out of bounds.
    public func section(at index: Int) -> JMStaticContentSection? {
        guard index < sections.count else { return nil }
        return sections[index]
    }

    /// Inserts a cell at the specified index path.
    /// - Parameters:
    ///   - cell: The cell configuration to insert.
    ///   - indexPath: The index path for the new cell.
    ///   - animated: Whether to animate the insertion.
    public func insertCell(_ cell: JMStaticContentCell, at indexPath: IndexPath, animated: Bool = true) {
        guard indexPath.section < sections.count else { return }

        let section = sections[indexPath.section]
        section.insertCell(cell, at: indexPath.row, animated: animated)
    }

    // MARK: - Private Methods

    private func updateSectionIndexes() {
        for (index, section) in sections.enumerated() {
            section.sectionIndex = index
        }
    }

    private func updateHeaderView() {
        guard isViewLoaded else { return }

        guard let text = headerText, !text.isEmpty else {
            tableView.tableHeaderView = nil
            return
        }

        let container = UIView()
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])

        let size = container.systemLayoutSizeFitting(
            CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        container.frame = CGRect(origin: .zero, size: size)

        tableView.tableHeaderView = container
    }

    private func updateFooterView() {
        guard isViewLoaded else { return }

        guard let text = footerText, !text.isEmpty else {
            tableView.tableFooterView = nil
            return
        }

        let container = UIView()
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -30),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])

        let size = container.systemLayoutSizeFitting(
            CGSize(width: tableView.bounds.width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        container.frame = CGRect(origin: .zero, size: size)

        tableView.tableFooterView = container
    }

    // MARK: - UITableViewDataSource

    open override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    open override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cellConfig = section.cells[indexPath.row]

        var cell = tableView.dequeueReusableCell(withIdentifier: cellConfig.reuseIdentifier)

        if cell == nil {
            cell = cellConfig.tableViewCellSubclass.init(style: cellConfig.cellStyle, reuseIdentifier: cellConfig.reuseIdentifier)
        }

        guard let cell else {
            return UITableViewCell()
        }

        // Reset cell state
        cell.imageView?.image = nil
        cell.accessoryView = nil
        cell.accessoryType = .disclosureIndicator

        // Configure the cell
        cellConfig.configureBlock?(cellConfig, cell, indexPath)

        return cell
    }

    open override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    open override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    open override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }

    open override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }

    // MARK: - UITableViewDelegate

    open override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellConfig = sections[indexPath.section].cells[indexPath.row]

        if cellConfig.cellHeight == UITableView.automaticDimension {
            if tableView.rowHeight == UITableView.automaticDimension {
                return UITableView.automaticDimension
            }
            return tableView.rowHeight
        }

        return cellConfig.cellHeight
    }

    open override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let headerView = sections[section].headerView {
            return headerView.frame.height
        }
        return UITableView.automaticDimension
    }

    open override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let footerView = sections[section].footerView {
            return footerView.frame.height
        }
        return UITableView.automaticDimension
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellConfig = sections[indexPath.section].cells[indexPath.row]
        cellConfig.whenSelectedBlock?(indexPath)
    }

    open override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return sections[indexPath.section].cells[indexPath.row].editingStyle
    }

    open override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].cells[indexPath.row].isEditable
    }

    open override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return sections[indexPath.section].cells[indexPath.row].isMoveable
    }

    // MARK: - UIScrollViewDelegate

    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        view.endEditing(true)
    }
}
#endif
