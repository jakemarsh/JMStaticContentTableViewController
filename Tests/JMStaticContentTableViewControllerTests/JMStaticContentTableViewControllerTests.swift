//
//  JMStaticContentTableViewControllerTests.swift
//  JMStaticContentTableViewController
//
//  Created by Jake Marsh on 12/31/24.
//  Copyright 2024-2025 Jake Marsh. All rights reserved.
//

import XCTest
@testable import JMStaticContentTableViewController

#if canImport(UIKit) && !os(watchOS)
import UIKit

final class JMStaticContentTableViewControllerTests: XCTestCase {

    var viewController: JMStaticContentTableViewController!

    override func setUp() {
        super.setUp()
        viewController = JMStaticContentTableViewController(style: .grouped)
        _ = viewController.view // Force view load
    }

    override func tearDown() {
        viewController = nil
        super.tearDown()
    }

    // MARK: - Section Tests

    func testAddSection() {
        viewController.addSection { section, index in
            section.headerTitle = "Test Section"
        }

        XCTAssertEqual(viewController.sections.count, 1)
        XCTAssertEqual(viewController.sections.first?.headerTitle, "Test Section")
    }

    func testAddMultipleSections() {
        viewController.addSection { section, _ in
            section.headerTitle = "Section 1"
        }

        viewController.addSection { section, _ in
            section.headerTitle = "Section 2"
        }

        viewController.addSection { section, _ in
            section.headerTitle = "Section 3"
        }

        XCTAssertEqual(viewController.sections.count, 3)
        XCTAssertEqual(viewController.sections[0].headerTitle, "Section 1")
        XCTAssertEqual(viewController.sections[1].headerTitle, "Section 2")
        XCTAssertEqual(viewController.sections[2].headerTitle, "Section 3")
    }

    func testRemoveAllSections() {
        // Add some sections
        viewController.addSection { _, _ in }
        viewController.addSection { _, _ in }
        viewController.addSection { _, _ in }

        XCTAssertEqual(viewController.sections.count, 3)

        // Remove all sections (FIX for issue #4)
        viewController.removeAllSections()

        XCTAssertEqual(viewController.sections.count, 0)
        // Verify tableView is in sync
        XCTAssertEqual(viewController.tableView.numberOfSections, 0)
    }

    func testRemoveSectionAtIndex() {
        viewController.addSection { section, _ in
            section.headerTitle = "Section 1"
        }
        viewController.addSection { section, _ in
            section.headerTitle = "Section 2"
        }
        viewController.addSection { section, _ in
            section.headerTitle = "Section 3"
        }

        viewController.removeSection(at: 1, animated: false)

        XCTAssertEqual(viewController.sections.count, 2)
        XCTAssertEqual(viewController.sections[0].headerTitle, "Section 1")
        XCTAssertEqual(viewController.sections[1].headerTitle, "Section 3")
    }

    func testInsertSectionAtIndex() {
        viewController.addSection { section, _ in
            section.headerTitle = "Section 1"
        }
        viewController.addSection { section, _ in
            section.headerTitle = "Section 3"
        }

        viewController.insertSection({ section, _ in
            section.headerTitle = "Section 2"
        }, at: 1, animated: false)

        XCTAssertEqual(viewController.sections.count, 3)
        XCTAssertEqual(viewController.sections[1].headerTitle, "Section 2")
    }

    func testSectionIndexesAreUpdated() {
        viewController.addSection { _, _ in }
        viewController.addSection { _, _ in }
        viewController.addSection { _, _ in }

        XCTAssertEqual(viewController.sections[0].sectionIndex, 0)
        XCTAssertEqual(viewController.sections[1].sectionIndex, 1)
        XCTAssertEqual(viewController.sections[2].sectionIndex, 2)

        viewController.removeSection(at: 0, animated: false)

        XCTAssertEqual(viewController.sections[0].sectionIndex, 0)
        XCTAssertEqual(viewController.sections[1].sectionIndex, 1)
    }

    // MARK: - Cell Tests

    func testAddCell() {
        viewController.addSection { section, _ in
            let cell = JMStaticContentCell.text("Test Cell")
            section.addCell(cell)
        }

        XCTAssertEqual(viewController.sections.first?.cells.count, 1)
    }

    func testAddMultipleCells() {
        viewController.addSection { section, _ in
            section.addCell(JMStaticContentCell.text("Cell 1"))
            section.addCell(JMStaticContentCell.text("Cell 2"))
            section.addCell(JMStaticContentCell.text("Cell 3"))
        }

        XCTAssertEqual(viewController.sections.first?.cells.count, 3)
    }

    func testCellIndexPaths() {
        viewController.addSection { section, sectionIndex in
            section.addCell(JMStaticContentCell.text("Cell 1"))
            section.addCell(JMStaticContentCell.text("Cell 2"))

            XCTAssertEqual(section.cells[0].indexPath, IndexPath(row: 0, section: sectionIndex))
            XCTAssertEqual(section.cells[1].indexPath, IndexPath(row: 1, section: sectionIndex))
        }
    }

    // MARK: - Cell Types Tests

    func testTextCell() {
        let cell = JMStaticContentCell.text("Title", detailText: "Subtitle")

        XCTAssertNotNil(cell.configureBlock)
        XCTAssertEqual(cell.cellStyle, .subtitle)
    }

    func testToggleCell() {
        var toggled = false
        let cell = JMStaticContentCell.toggle("Toggle", isOn: true) { isOn in
            toggled = isOn
        }

        XCTAssertNotNil(cell.configureBlock)
        XCTAssertNil(cell.whenSelectedBlock) // Toggle cells don't use selection
    }

    func testValueCell() {
        let cell = JMStaticContentCell.value("Label", value: "Value")

        XCTAssertNotNil(cell.configureBlock)
        XCTAssertEqual(cell.cellStyle, .value1)
    }

    // MARK: - TableView DataSource Tests

    func testNumberOfSections() {
        viewController.addSection { _, _ in }
        viewController.addSection { _, _ in }

        XCTAssertEqual(viewController.numberOfSections(in: viewController.tableView), 2)
    }

    func testNumberOfRowsInSection() {
        viewController.addSection { section, _ in
            section.addCell(JMStaticContentCell.text("Cell 1"))
            section.addCell(JMStaticContentCell.text("Cell 2"))
        }

        XCTAssertEqual(viewController.tableView(viewController.tableView, numberOfRowsInSection: 0), 2)
    }

    // MARK: - Header/Footer Tests

    func testHeaderText() {
        viewController.headerText = "Header"
        XCTAssertNotNil(viewController.tableView.tableHeaderView)

        viewController.headerText = nil
        XCTAssertNil(viewController.tableView.tableHeaderView)
    }

    func testFooterText() {
        viewController.footerText = "Footer"
        XCTAssertNotNil(viewController.tableView.tableFooterView)

        viewController.footerText = nil
        XCTAssertNil(viewController.tableView.tableFooterView)
    }

    func testSectionHeaderTitle() {
        viewController.addSection { section, _ in
            section.headerTitle = "Section Header"
        }

        let title = viewController.tableView(viewController.tableView, titleForHeaderInSection: 0)
        XCTAssertEqual(title, "Section Header")
    }

    func testSectionFooterTitle() {
        viewController.addSection { section, _ in
            section.footerTitle = "Section Footer"
        }

        let title = viewController.tableView(viewController.tableView, titleForFooterInSection: 0)
        XCTAssertEqual(title, "Section Footer")
    }
}

// MARK: - Section Tests

final class JMStaticContentSectionTests: XCTestCase {

    func testRemoveAllCells() {
        let section = JMStaticContentSection()
        section.cells.append(JMStaticContentCell())
        section.cells.append(JMStaticContentCell())

        XCTAssertEqual(section.cells.count, 2)

        // Create a mock table view for testing
        let tableView = UITableView()
        section.tableView = tableView
        section.sectionIndex = 0

        section.removeAllCells()

        XCTAssertEqual(section.cells.count, 0)
    }

    func testInsertCell() {
        let section = JMStaticContentSection()
        section.sectionIndex = 0

        section.addCell(JMStaticContentCell.text("Cell 1"))
        section.addCell(JMStaticContentCell.text("Cell 3"))
        section.insertCell(JMStaticContentCell.text("Cell 2"), at: 1, animated: false)

        XCTAssertEqual(section.cells.count, 3)
        XCTAssertEqual(section.cells[1].indexPath, IndexPath(row: 1, section: 0))
    }

    func testRemoveCellAtIndex() {
        let section = JMStaticContentSection()
        section.sectionIndex = 0

        section.addCell(JMStaticContentCell.text("Cell 1"))
        section.addCell(JMStaticContentCell.text("Cell 2"))
        section.addCell(JMStaticContentCell.text("Cell 3"))

        section.removeCell(at: 1, animated: false)

        XCTAssertEqual(section.cells.count, 2)
    }
}

// MARK: - Cell Tests

final class JMStaticContentCellTests: XCTestCase {

    func testDefaultProperties() {
        let cell = JMStaticContentCell()

        XCTAssertEqual(cell.reuseIdentifier, "JMStaticContentCell")
        XCTAssertEqual(cell.cellStyle, .default)
        XCTAssertEqual(cell.cellHeight, UITableView.automaticDimension)
        XCTAssertEqual(cell.editingStyle, .none)
        XCTAssertFalse(cell.isEditable)
        XCTAssertFalse(cell.isMoveable)
    }

    func testCustomReuseIdentifier() {
        let cell = JMStaticContentCell(reuseIdentifier: "CustomCell")
        XCTAssertEqual(cell.reuseIdentifier, "CustomCell")
    }

    func testCustomCellHeight() {
        let cell = JMStaticContentCell(height: 100)
        XCTAssertEqual(cell.cellHeight, 100)
    }

    func testWhenSelectedBlock() {
        var selectedIndexPath: IndexPath?
        let cell = JMStaticContentCell.text("Test") { indexPath in
            selectedIndexPath = indexPath
        }

        let testPath = IndexPath(row: 0, section: 0)
        cell.whenSelectedBlock?(testPath)

        XCTAssertEqual(selectedIndexPath, testPath)
    }
}
#endif
