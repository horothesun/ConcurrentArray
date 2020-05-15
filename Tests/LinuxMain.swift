import XCTest

import ConcurrentArrayTests

var tests = [XCTestCaseEntry]()
tests += ConcurrentArrayTests.__allTests()

XCTMain(tests)
