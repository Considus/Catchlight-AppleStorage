import XCTest
import CatchlightCore
@testable import CatchlightAppleStorage

/// `FileCloudFolder` against a real folder in the temporary directory: the bookmark round
/// trip both apps rely on across launches, and the `CloudFolder` behaviour the sync engine
/// depends on (a missing file reads as nil, deleting one is a no-op, writes replace).
final class FileCloudFolderTests: XCTestCase {

    private var dir: URL!

    override func setUpWithError() throws {
        dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("catchlight.cloudfolder.tests.\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    }

    override func tearDownWithError() throws {
        try? FileManager.default.removeItem(at: dir)
    }

    func testBookmark_roundTrip_resolvesToTheSameFolder() throws {
        let bookmark = try FileCloudFolder.makeBookmark(for: dir)
        let folder = try FileCloudFolder(bookmark: bookmark)
        XCTAssertEqual(folder.folderURL.standardizedFileURL.resolvingSymlinksInPath().path,
                       dir.standardizedFileURL.resolvingSymlinksInPath().path)
        XCTAssertFalse(folder.bookmarkWasStale)
    }

    func testBookmark_resolvedFolderCanWriteAndRead() throws {
        let folder = try FileCloudFolder(bookmark: FileCloudFolder.makeBookmark(for: dir))
        try folder.write(Data("hello".utf8), to: "a.clk")
        XCTAssertEqual(try folder.read("a.clk"), Data("hello".utf8))
    }

    #if os(macOS)
    /// A sandboxed Mac app cannot reach the folder on the next launch from a bookmark made
    /// without `.withSecurityScope`. An unsandboxed test process resolves either kind, so the
    /// round trip above cannot catch the option going missing; this does.
    func testMacBookmarks_areSecurityScoped() {
        XCTAssertTrue(FileCloudFolder.makeOptions.contains(.withSecurityScope))
        XCTAssertTrue(FileCloudFolder.resolveOptions.contains(.withSecurityScope))
    }
    #endif

    func testCorruptBookmark_throws() {
        XCTAssertThrowsError(try FileCloudFolder(bookmark: Data([0x00, 0x01, 0x02])))
    }

    func testReadMissingFile_isNil() throws {
        XCTAssertNil(try FileCloudFolder(folderURL: dir).read("nothing.clk"))
    }

    func testWrite_replacesAndLists() throws {
        let folder = FileCloudFolder(folderURL: dir)
        try folder.write(Data("one".utf8), to: "x.clk")
        try folder.writeAtomically(Data("two".utf8), to: "x.clk")
        try folder.write(Data("{}".utf8), to: "catchlight-manifest.json")
        XCTAssertEqual(try folder.read("x.clk"), Data("two".utf8))
        XCTAssertEqual(Set(try folder.listFiles()), ["x.clk", "catchlight-manifest.json"])
        XCTAssertEqual(try folder.clkFiles(), ["x.clk"])
    }

    func testDeleteMissingFile_isANoOp() throws {
        XCTAssertNoThrow(try FileCloudFolder(folderURL: dir).delete("nothing.clk"))
    }

    func testSecureDelete_removesTheFile() throws {
        let folder = FileCloudFolder(folderURL: dir)
        try folder.write(Data(repeating: 7, count: 64), to: "gone.clk")
        try folder.secureDelete("gone.clk")
        XCTAssertNil(try folder.read("gone.clk"))
        XCTAssertFalse(try folder.listFiles().contains("gone.clk"))
    }

    func testEnsureSubfolder_createsItOnce() throws {
        let folder = FileCloudFolder(folderURL: dir)
        folder.ensureSubfolder("Import")
        folder.ensureSubfolder("Import")
        var isDir: ObjCBool = false
        XCTAssertTrue(FileManager.default.fileExists(atPath: dir.appendingPathComponent("Import").path, isDirectory: &isDir))
        XCTAssertTrue(isDir.boolValue)
    }
}
