public struct Tensor<Element> {

  internal var array: [Element]
  public let shape: [Int]

  public init(dimensions: [Int], values: some Sequence<Element>) {
    self.shape = dimensions
    self.array = Array(values)
    precondition(self.count == self.array.count)
  }

  public init(dimensions: [Int], repeating repeatedValue: Element) {
    self.init(
      dimensions: dimensions,
      values: repeatElement(repeatedValue, count: dimensions.multiply()))
  }

  public subscript(_ indexes: Int...) -> Element {
    get {
      array[index(from: indexes)]
    }
    set {
      array[index(from: indexes)] = newValue
    }
  }

  public func dim(_ index: Int) -> Int {
    shape[index]
  }

  public var count: Int {
    shape.isEmpty ? 0 : shape.multiply()
  }

}

extension Tensor {

  fileprivate func index(from indexes: [Int]) -> Int {
    assert(indexes.count == shape.count)
    assert(zip(indexes, shape).map(<).allSatisfy { $0 })
    return zip(indexes, shape.dropFirst()).map(*).sum() + indexes.last!
  }
}

extension Tensor: Equatable where Element: Equatable {}
