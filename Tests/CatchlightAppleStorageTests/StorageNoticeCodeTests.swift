//
//  StorageNoticeCodeTests.swift
//  CatchlightAppleStorageTests
//
//  The two diagnostics codes this package writes are the shared numbering's 920 and 921,
//  the same lines the iPhone app writes under those numbers. Numbers are permanent.
//

import XCTest
@testable import CatchlightAppleStorage

final class StorageNoticeCodeTests: XCTestCase {
    func testCodesNeverChange() {
        XCTAssertEqual(StorageNoticeCode.watermarkPrepareFailed.rawValue, 920)
        XCTAssertEqual(StorageNoticeCode.watermarkStepFailed.rawValue, 921)
        XCTAssertEqual(StorageNoticeCode.allCases.count, 2)
    }
}
