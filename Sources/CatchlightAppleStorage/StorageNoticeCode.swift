//
//  StorageNoticeCode.swift
//  CatchlightAppleStorage
//
//  Reference codes for the diagnostics lines this package writes. They belong to the
//  shared notice numbering, where a number means the same line on every platform: these
//  are the iPhone app's 920 and 921 (its `NoticeCode`), written here for the apps that
//  store Takes through this package. Through `DiagnosticsLog.record(_:code:_:)` they read
//  `[CCMOS-920] …` once the app has set its platform code.
//
//  Never shown on the main screen, so they are developer-only (`.lifecycle`), English,
//  export only. A number is never reused or renumbered once released.
//

enum StorageNoticeCode: Int, CaseIterable {
    case watermarkPrepareFailed = 920       // Sync watermark write failed (prepare).
    case watermarkStepFailed = 921          // Sync watermark write failed (step).
}
