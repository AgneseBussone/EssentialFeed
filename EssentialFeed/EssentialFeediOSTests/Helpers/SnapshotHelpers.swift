//

import XCTest

func assert(snapshot: UIImage, name: String, file: StaticString = #file, line: UInt = #line) {
    guard let snapshotData = snapshot.pngData() else {
        XCTFail("Failed to generate PNG from snapshot", file: file, line: line)
        return
    }
    
    let snapshotURL = makeSnapshotURL(named: name, file: file)
    
    guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
        XCTFail("Failed to load snapshot at URL \(snapshotURL). Use the 'record' method to store a snapshot before asserting", file: file, line: line)
        return
    }
    
    if snapshotData != storedSnapshotData {
        let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
            .appendingPathComponent(snapshotURL.lastPathComponent)
        
        try? snapshotData.write(to: temporarySnapshotURL)
        
        XCTFail("New snapshot doesn't match recorded one. New snapshot at \(temporarySnapshotURL), stored at \(snapshotURL)", file: file, line: line)
    }
}

func recordSnapshot(snapshot: UIImage, name: String, file: StaticString = #file, line: UInt = #line) {
    guard let snapshotData = snapshot.pngData() else {
        XCTFail("Failed to generate PNG from snapshot", file: file, line: line)
        return
    }
    
    let snapshotURL = makeSnapshotURL(named: name, file: file)
    
    do {
        try FileManager.default.createDirectory(at: snapshotURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try snapshotData.write(to: snapshotURL)
    } catch {
        XCTFail("Failed to record snapshot with error \(error)", file: file, line: line)
    }
}

private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
    return URL(fileURLWithPath: String(describing: file))
        .deletingLastPathComponent()
        .appendingPathComponent("snapshot")
        .appendingPathComponent("\(name).png")
}
