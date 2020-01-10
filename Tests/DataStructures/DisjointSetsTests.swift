import Essentialis
import XCTest

final class DisjointSetsTests: XCTestCase {

  func test_disjointSets() {
    let disjointSets = DisjointSets()

    let sets = [
      disjointSets.makeSet(),
      disjointSets.makeSet(),
      disjointSets.makeSet(),
      disjointSets.makeSet(),
    ]

    for set in sets {
      XCTAssertEqual(disjointSets.findSet(set), set)
    }

    disjointSets.union(sets[0], sets[2])
    disjointSets.union(sets[1], sets[3])

    XCTAssertEqual(disjointSets.findSet(sets[0]), sets[2])
    XCTAssertEqual(disjointSets.findSet(sets[1]), sets[3])
  }

}
