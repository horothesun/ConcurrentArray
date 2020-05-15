import XCTest
import ConcurrentArray

final class ConcurrentArrayTests: XCTestCase {

    func test_subscriptGet_onSequentialEnvironment_fromEmptyArray_mustReturnNil() {
        typealias Element = Int
        let index = 3
        let elements = [Element]()
        let sut = makeSUT(
            elementType: Element.self,
            from: elements,
            queue: .init(label: UUID().uuidString, attributes: .concurrent)
        )
        let sequentialQueue = DispatchQueue(label: UUID().uuidString)
        let expectation = XCTestExpectation(description: "sut[index] == nil")
        sequentialQueue.async {
            if sut[index] == nil {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_subscriptGet_onSequentialEnvironment_fromDictionaryContainingValueAtIndex_mustReturnValue() {
        typealias Element = String
        let index = 2
        let value: Element = "2️⃣"
        let elements: [Element] = ["0️⃣", "1️⃣", value, "3️⃣"]
        let sut = makeSUT(
            elementType: Element.self,
            from: elements,
            queue: .init(label: UUID().uuidString, attributes: .concurrent)
        )
        let sequentialQueue = DispatchQueue(label: UUID().uuidString)
        let expectation = XCTestExpectation(description: "sut[index] == value")
        sequentialQueue.async {
            if sut[index] == value {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    func test_subscriptSet_onSequentialEnvironment_mustInsertValueAtIndex() {
        typealias Element = String
        let index = 2
        let elements: [Element] = ["0️⃣", "1️⃣", "2️⃣", "3️⃣"]
        let newValue: Element = "🥝"
        let sut = makeSUT(
            elementType: Element.self,
            from: elements,
            queue: .init(label: UUID().uuidString, attributes: .concurrent)
        )
        let sequentialQueue = DispatchQueue(label: UUID().uuidString)
        let group = DispatchGroup()
        group.enter()
        sequentialQueue.async {
            sut[index] = newValue
            group.leave()
        }
        _ = group.wait(timeout: .now() + .seconds(1))
        Thread.sleep(forTimeInterval: 0.2)
        XCTAssert(sut.all() == ["0️⃣", "1️⃣", newValue, "3️⃣"])
    }

    func test_subscriptSetMultipleTimes_onConcurrentEnvironment_mustInsertAllKeyValuePairs() {
        typealias Element = String
        let elementsCount = 800
        let elements = [Element].init(repeating: "", count: elementsCount)
        let sut = makeSUT(
            elementType: Element.self,
            from: elements,
            queue: .init(label: UUID().uuidString, attributes: .concurrent)
        )
        let expectations = (0..<elementsCount)
            .map { "\"\($0)\" -> sut[\($0)] set" }
            .map { [unowned self] description in self.expectation(description: description) }
        let concurrentQueue = DispatchQueue(label: UUID().uuidString, attributes: .concurrent)
        elements.enumerated().forEach { (index, value) in
            concurrentQueue.async {
                sut[index] = value
                expectations[index].fulfill()
            }
        }
        wait(for: expectations, timeout: 3)
    }
}

extension ConcurrentArrayTests {
    func makeSUT<Element>(
        elementType: Element.Type,
        from elements: [Element],
        queue: DispatchQueue
    ) -> ConcurrentArray<Element> {
        return .init(from: elements, queue: queue)
    }
}
