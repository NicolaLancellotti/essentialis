extension Sequence where Element: AdditiveArithmetic {

  public func sum() -> Element {
    reduce(Element.zero, +)
  }

}

extension Sequence where Element: Numeric {

  public func multiply() -> Element {
    reduce(1, *)
  }

}

extension Sequence {

  public func firstTwoElements() -> (Element, Element)? {
    var it = makeIterator()
    guard let first = it.next(), let second = it.next() else {
      return nil
    }
    return (first, second)
  }

}
