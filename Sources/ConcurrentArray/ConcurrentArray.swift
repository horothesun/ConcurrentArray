import Foundation

public final class ConcurrentArray<Element> {

    private let queue: DispatchQueue
    private var elements: [Element]

    public convenience init() {
        self.init(
            from: [],
            queue: .init(
                label: "thread-safe-array-dispatch-queue-\(UUID())",
                attributes: .concurrent
            )
        )
    }

    public convenience init(queue: DispatchQueue) {
        self.init(from: [], queue: queue)
    }

    public init(from elements: [Element], queue: DispatchQueue) {
        self.queue = queue
        self.elements = elements
    }

    public func all() -> [Element] {
        var result: [Element] = []
        queue.sync { [elements] in
            result = elements
        }
        return result
    }

    public func prepend(_ element: Element) {
        queue.async(flags: .barrier) { [weak self] in
            if let nonNilSelf = self {
                nonNilSelf.elements = [element] + nonNilSelf.elements
            }
        }
    }

    public func append(_ element: Element) {
        queue.async(flags: .barrier) { [weak self] in
            self?.elements.append(element)
        }
    }

    // TODO: Array.remove(atOffsets:) not found
    // public func remove(atOffsets offsets: IndexSet) {
    //     queue.async(flags: .barrier) { [weak self] in
    //         self?.elements.remove(atOffsets: offsets)
    //     }
    // }

    public func removeAll(where: @escaping (Element) -> Bool) {
        queue.async(flags: .barrier) { [weak self] in
            self?.elements.removeAll(where: `where`)
        }
    }

    public subscript(index: Int) -> Element? {
        get {
            var result: Element? = nil
            queue.sync { [weak self] in
                guard index >= 0, index < elements.count else {
                    return
                }

                result = self?.elements[index]
            }
            return result
        }

        set {
            queue.async(flags: .barrier) { [weak self] in
                guard let newValue = newValue else {
                    return
                }

                self?.elements[index] = newValue
            }
        }
    }
}
