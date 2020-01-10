public class DisjointSets {

  public class Element: Equatable {
    fileprivate var parent: Element? = nil
    fileprivate var rank: Int = 0
    fileprivate init() {}

    public static func == (lhs: Element, rhs: Element) -> Bool {
      ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
  }

  public init() {}

  public func makeSet() -> Element {
    Element()
  }

  public func union(_ element1: Element, _ element2: Element) {
    let representative1 = findSet(element1)
    let representative2 = findSet(element2)
    precondition(representative1 !== representative2)

    // Union by rank heuristics
    switch representative1.rank > representative2.rank {
    case true:
      representative2.parent = representative1
    case false:
      representative1.parent = representative2
      if representative1.rank == representative2.rank {
        representative2.rank += 1
      }
    }
  }

  public func findSet(_ element: Element) -> Element {
    guard let parent = element.parent else {
      return element
    }

    let newParent = findSet(parent)
    element.parent = newParent  // Path compression heuristics
    return newParent
  }

}
