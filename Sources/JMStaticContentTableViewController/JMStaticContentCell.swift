//
//  JMStaticContentCell.swift
//  JMStaticContentTableViewController
//
//  Created by Jake Marsh on 10/8/11.
//  Rewritten in Swift on 12/31/24.
//  Copyright 2011-2025 Jake Marsh. All rights reserved.
//

#if canImport(UIKit) && !os(watchOS)
import UIKit

/// Configuration for a single cell in a static table view.
///
/// `JMStaticContentCell` describes how a cell should be configured and what happens when it's selected.
/// The actual UITableViewCell is created and reused by the table view.
public final class JMStaticContentCell {

    // MARK: - Properties

    /// The reuse identifier for this cell type.
    public var reuseIdentifier: String

    /// The index path of this cell within the table view.
    public internal(set) var indexPath: IndexPath?

    /// The height of the cell. Use `UITableView.automaticDimension` for automatic sizing.
    public var cellHeight: CGFloat

    /// The style of the cell.
    public var cellStyle: UITableViewCell.CellStyle

    /// The class to use for the cell. Defaults to UITableViewCell.
    public var tableViewCellSubclass: UITableViewCell.Type

    /// The editing style for the cell.
    public var editingStyle: UITableViewCell.EditingStyle

    /// Whether the cell can be edited.
    public var isEditable: Bool

    /// Whether the cell can be moved.
    public var isMoveable: Bool

    /// Block called to configure the cell each time it's displayed.
    public var configureBlock: ((JMStaticContentCell, UITableViewCell, IndexPath) -> Void)?

    /// Block called when the cell is selected.
    public var whenSelectedBlock: ((IndexPath) -> Void)?

    // MARK: - Initialization

    /// Creates a new cell configuration.
    /// - Parameters:
    ///   - reuseIdentifier: The reuse identifier for this cell type. Defaults to "JMStaticContentCell".
    ///   - cellStyle: The cell style. Defaults to `.default`.
    ///   - cellClass: The UITableViewCell subclass to use. Defaults to UITableViewCell.
    ///   - height: The cell height. Defaults to automatic dimension.
    public init(
        reuseIdentifier: String = "JMStaticContentCell",
        cellStyle: UITableViewCell.CellStyle = .default,
        cellClass: UITableViewCell.Type = UITableViewCell.self,
        height: CGFloat = UITableView.automaticDimension
    ) {
        self.reuseIdentifier = reuseIdentifier
        self.cellStyle = cellStyle
        self.tableViewCellSubclass = cellClass
        self.cellHeight = height
        self.editingStyle = .none
        self.isEditable = false
        self.isMoveable = false
    }
}

// MARK: - Convenience Builders

public extension JMStaticContentCell {

    /// Creates a simple text cell.
    /// - Parameters:
    ///   - text: The primary text to display.
    ///   - detailText: Optional secondary text.
    ///   - image: Optional image for the cell.
    ///   - accessoryType: The accessory type. Defaults to disclosure indicator.
    ///   - onSelect: Optional handler when the cell is selected.
    /// - Returns: A configured cell.
    static func text(
        _ text: String,
        detailText: String? = nil,
        image: UIImage? = nil,
        accessoryType: UITableViewCell.AccessoryType = .disclosureIndicator,
        onSelect: ((IndexPath) -> Void)? = nil
    ) -> JMStaticContentCell {
        let style: UITableViewCell.CellStyle = detailText != nil ? .subtitle : .default
        let cell = JMStaticContentCell(cellStyle: style)

        cell.configureBlock = { _, tableViewCell, _ in
            tableViewCell.textLabel?.text = text
            tableViewCell.detailTextLabel?.text = detailText
            tableViewCell.imageView?.image = image
            tableViewCell.accessoryType = accessoryType
        }

        cell.whenSelectedBlock = onSelect

        return cell
    }

    /// Creates a cell with a toggle switch.
    /// - Parameters:
    ///   - text: The label text.
    ///   - isOn: The initial toggle state.
    ///   - onToggle: Handler called when the toggle changes.
    /// - Returns: A configured cell.
    static func toggle(
        _ text: String,
        isOn: Bool,
        onToggle: @escaping (Bool) -> Void
    ) -> JMStaticContentCell {
        let cell = JMStaticContentCell()

        cell.configureBlock = { _, tableViewCell, _ in
            tableViewCell.textLabel?.text = text
            tableViewCell.selectionStyle = .none
            tableViewCell.accessoryType = .none

            let toggle = UISwitch()
            toggle.isOn = isOn
            toggle.addAction(UIAction { action in
                if let sender = action.sender as? UISwitch {
                    onToggle(sender.isOn)
                }
            }, for: .valueChanged)

            tableViewCell.accessoryView = toggle
        }

        return cell
    }

    /// Creates a cell with a value display on the right.
    /// - Parameters:
    ///   - text: The label text.
    ///   - value: The value to display on the right.
    ///   - onSelect: Optional handler when the cell is selected.
    /// - Returns: A configured cell.
    static func value(
        _ text: String,
        value: String,
        onSelect: ((IndexPath) -> Void)? = nil
    ) -> JMStaticContentCell {
        let cell = JMStaticContentCell(cellStyle: .value1)

        cell.configureBlock = { _, tableViewCell, _ in
            tableViewCell.textLabel?.text = text
            tableViewCell.detailTextLabel?.text = value
            tableViewCell.accessoryType = onSelect != nil ? .disclosureIndicator : .none
        }

        cell.whenSelectedBlock = onSelect

        return cell
    }
}
#endif
