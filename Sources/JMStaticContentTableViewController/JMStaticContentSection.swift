//
//  JMStaticContentSection.swift
//  JMStaticContentTableViewController
//
//  Created by Jake Marsh on 10/8/11.
//  Rewritten in Swift on 12/31/24.
//  Copyright 2011-2025 Jake Marsh. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// A section in a static table view.
///
/// `JMStaticContentSection` contains multiple cells and optional header/footer views.
public final class JMStaticContentSection {

    // MARK: - Properties

    /// Reference to the parent table view.
    public weak var tableView: UITableView?

    /// The cells in this section.
    public internal(set) var cells: [JMStaticContentCell] = []

    /// The section index within the table view.
    public internal(set) var sectionIndex: Int = 0

    /// The header title for this section.
    public var headerTitle: String?

    /// The footer title for this section.
    public var footerTitle: String?

    /// Custom header view for this section.
    public var headerView: UIView?

    /// Custom footer view for this section.
    public var footerView: UIView?

    // MARK: - Initialization

    /// Creates a new empty section.
    public init() {}

    /// Creates a section with a header title.
    /// - Parameter headerTitle: The header title.
    public init(headerTitle: String?) {
        self.headerTitle = headerTitle
    }

    /// Creates a section with header and footer titles.
    /// - Parameters:
    ///   - headerTitle: The header title.
    ///   - footerTitle: The footer title.
    public init(headerTitle: String?, footerTitle: String?) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }

    // MARK: - Cell Management

    /// Adds a cell to the section.
    /// - Parameter cell: The cell configuration to add.
    public func addCell(_ cell: JMStaticContentCell) {
        addCell(cell, animated: false)
    }

    /// Adds a cell to the section with optional animation.
    /// - Parameters:
    ///   - cell: The cell configuration to add.
    ///   - animated: Whether to animate the insertion.
    public func addCell(_ cell: JMStaticContentCell, animated: Bool) {
        let newRowIndex = cells.count
        cell.indexPath = IndexPath(row: newRowIndex, section: sectionIndex)
        cells.append(cell)

        if animated, let tableView {
            tableView.insertRows(at: [IndexPath(row: newRowIndex, section: sectionIndex)], with: .automatic)
        }
    }

    /// Adds a cell using a configuration block.
    /// - Parameters:
    ///   - configureBlock: Block to configure the cell.
    ///   - whenSelectedBlock: Optional block called when the cell is selected.
    public func addCell(
        configure configureBlock: @escaping (JMStaticContentCell, UITableViewCell, IndexPath) -> Void,
        whenSelected whenSelectedBlock: ((IndexPath) -> Void)? = nil
    ) {
        let cell = JMStaticContentCell()
        cell.configureBlock = configureBlock
        cell.whenSelectedBlock = whenSelectedBlock
        addCell(cell)
    }

    /// Inserts a cell at the specified index.
    /// - Parameters:
    ///   - cell: The cell configuration to insert.
    ///   - index: The index to insert at.
    ///   - animated: Whether to animate the insertion.
    public func insertCell(_ cell: JMStaticContentCell, at index: Int, animated: Bool = true) {
        cell.indexPath = IndexPath(row: index, section: sectionIndex)
        cells.insert(cell, at: index)
        updateCellIndexPaths()

        if animated, let tableView {
            tableView.insertRows(at: [IndexPath(row: index, section: sectionIndex)], with: .automatic)
        }
    }

    /// Removes a cell at the specified index.
    /// - Parameters:
    ///   - index: The index of the cell to remove.
    ///   - animated: Whether to animate the removal.
    public func removeCell(at index: Int, animated: Bool = true) {
        guard index < cells.count else { return }

        cells.remove(at: index)
        updateCellIndexPaths()

        if animated, let tableView {
            tableView.deleteRows(at: [IndexPath(row: index, section: sectionIndex)], with: .automatic)
        }
    }

    /// Removes all cells from the section.
    public func removeAllCells() {
        cells.removeAll()
        tableView?.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
    }

    /// Reloads a cell at the specified index.
    /// - Parameters:
    ///   - index: The index of the cell to reload.
    ///   - animated: Whether to animate the reload.
    public func reloadCell(at index: Int, animated: Bool = true) {
        guard index < cells.count else { return }

        let animation: UITableView.RowAnimation = animated ? .automatic : .none
        tableView?.reloadRows(at: [IndexPath(row: index, section: sectionIndex)], with: animation)
    }

    // MARK: - Private Methods

    private func updateCellIndexPaths() {
        for (index, cell) in cells.enumerated() {
            cell.indexPath = IndexPath(row: index, section: sectionIndex)
        }
    }
}
#endif
