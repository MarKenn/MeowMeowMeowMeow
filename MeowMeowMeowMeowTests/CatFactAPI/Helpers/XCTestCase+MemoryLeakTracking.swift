//
//  XCTestCase+MemoryLeakTracking.swift
//  MeowMeowMeowMeow
//
//  Created by Mark Kenneth Bayona on 8/21/25.
//

import XCTest

extension XCTestCase {
     func trackFOrMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line,
    ) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(
                instance,
                "Instance should be deallocated. Potential memory leak.",
                file: file,
                line: line
            )
        }
    }
}
