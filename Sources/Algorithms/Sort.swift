import Foundation

public enum Sort {}

// MARK: - Selection Sort

extension Sort {

  /// - Complexity: Θ(n^2)
  public static func selectionSort<C>(
    _ collection: inout C,
    by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    func indexMinElement(from index: C.Index) throws -> C.Index {
      var index = index
      var current = collection.index(after: index)

      while current < collection.endIndex {
        if try areInIncreasingOrder(collection[current], collection[index]) {
          index = current
        }
        collection.formIndex(after: &current)
      }
      return index
    }

    for index in collection.indices {
      try collection.swapAt(index, indexMinElement(from: index))
    }
  }

  /// - Complexity: Θ(n^2)
  public static func selectionSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable
  {
    selectionSort(&collection, by: <)
  }

}

// MARK: - Insertion Sort

extension Sort {

  /// - Complexity: O(n^2), best case: Θ(n)
  public static func insertionSort<C>(
    _ collection: inout C,
    by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    var index = collection.index(after: collection.startIndex)
    while index < collection.endIndex {
      let elem = collection[index]

      var current = collection.index(before: index)
      while try current >= collection.startIndex && areInIncreasingOrder(elem, collection[current])
      {
        collection[collection.index(after: current)] = collection[current]
        collection.formIndex(before: &current)
      }

      collection[collection.index(after: current)] = elem
      collection.formIndex(after: &index)
    }
  }

  /// - Complexity: O(n^2), best case: Θ(n)
  public static func insertionSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable
  {
    insertionSort(&collection, by: <)
  }

}

// MARK: - Bubble Sort

extension Sort {

  /// - Complexity: Θ(n^2)
  public static func bubbleSort<C>(
    _ collection: inout C,
    by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    var index = collection.startIndex
    let last = collection.index(before: collection.endIndex)
    while index < last {
      var current = last
      while current > index {
        let previous = collection.index(before: current)
        if try areInIncreasingOrder(collection[current], collection[previous]) {
          collection.swapAt(current, previous)
        }
        collection.formIndex(before: &current)
      }
      collection.formIndex(after: &index)
    }
  }

  /// - Complexity: Θ(n^2)
  public static func bubbleSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable
  {
    bubbleSort(&collection, by: <)
  }

}

// MARK: - Heap Sort

extension Sort {

  /// - Complexity: O(nlog(n))
  public static func heapSort<C>(
    _ collection: inout C,
    by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection,
    C.Index: FixedWidthInteger
  {

    var heapCount = C.Index(collection.count)

    func heapify(index: C.Index) throws {
      var index = index
      while true {
        var maxIndex = index

        func updateMaxIndex(index: C.Index) throws {
          if try index < heapCount
            && areInIncreasingOrder(collection[maxIndex], collection[index])
          {
            maxIndex = index
          }
        }

        try updateMaxIndex(index: index << 1 + 1)  // index * 2 + 1 // left
        try updateMaxIndex(index: index << 1 + 2)  // index * 2 + 2 // right

        if maxIndex == index {
          return
        }
        collection.swapAt(index, maxIndex)
        index = maxIndex
      }
    }

    func buildMaxHeap() throws {
      // heapCount / 2 internal nodes
      for index in stride(from: heapCount / 2 - 1, through: 0, by: -1) {
        try heapify(index: C.Index(index))
      }
    }

    func sort() throws {
      for _ in stride(from: 0, to: collection.count - 1, by: 1) {
        heapCount -= 1
        collection.swapAt(.zero, heapCount)
        try heapify(index: 0)
      }
    }

    try buildMaxHeap()
    try sort()
  }

  /// - Complexity: O(nlog(n))
  public static func heapSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable,
    C.Index: FixedWidthInteger
  {
    heapSort(&collection, by: <)
  }

}

// MARK: - Merge Sort

extension Sort {

  /// - Complexity: Θ(nlog(n))
  public static func mergeSort<C>(
    _ collection: inout C,
    by areInIncreasingOrder: (C.Element, C.Element) throws -> Bool
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    func merge(start: C.Index, middle: C.Index, end: C.Index) throws {
      var (current1, current2) = (start, collection.index(after: middle))
      var tmp = [C.Element]()
      tmp.reserveCapacity(collection.distance(from: start, to: end) + 1)

      while current1 <= middle && current2 <= end {
        if try areInIncreasingOrder(collection[current1], collection[current2]) {
          tmp.append(collection[current1])
          collection.formIndex(after: &current1)
        } else {
          tmp.append(collection[current2])
          collection.formIndex(after: &current2)
        }
      }

      if current1 <= middle {
        tmp.append(contentsOf: collection[current1...middle])
      } else {
        tmp.append(contentsOf: collection[current2...end])
      }

      var index = start
      var i = tmp.startIndex
      while index <= end {
        collection[index] = tmp[i]
        tmp.formIndex(after: &i)
        collection.formIndex(after: &index)
      }
    }

    func sort(start: C.Index, end: C.Index) throws {
      guard start < end else { return }
      let middleOffset = collection.distance(from: start, to: end) / 2
      let middle = collection.index(start, offsetBy: middleOffset)
      try sort(start: start, end: middle)
      try sort(start: collection.index(after: middle), end: end)
      try merge(start: start, middle: middle, end: end)
    }

    try sort(
      start: collection.startIndex,
      end: collection.index(before: collection.endIndex))
  }

  /// - Complexity: Θ(nlog(n))
  public static func mergeSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable
  {
    mergeSort(&collection) { $0 < $1 }
  }

}

// MARK: - Quick Sort

extension Sort {

  /// - Complexity: O(n^2), average case: O(nlog(n))
  public static func quickSort<C>(
    _ collection: inout C,
    by order: (C.Element, C.Element) throws -> ComparisonResult
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    func partition(start: C.Index, end: C.Index) throws -> C.Index {
      let pivot = collection[start]
      var (left, right) = (start, end)

      while left < right {
        while try left < end && order(collection[left], pivot).orderedAscendingOrSame {
          collection.formIndex(after: &left)
        }

        while try order(collection[right], pivot) == .orderedDescending {
          collection.formIndex(before: &right)
        }

        if left < right {
          collection.swapAt(left, right)
        }
      }
      collection.swapAt(start, right)
      return right
    }

    func sort(start: C.Index, end: C.Index) throws {
      guard start < end else { return }
      let middle = try partition(start: start, end: end)
      try sort(start: start, end: collection.index(before: middle))
      try sort(start: collection.index(after: middle), end: end)
    }

    try sort(
      start: collection.startIndex,
      end: collection.index(before: collection.endIndex))
  }

  /// - Complexity: O(n^2), average case: O(n log(n))
  public static func quickSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: Comparable
  {
    quickSort(&collection) {
      if $0 == $1 {
        return .orderedSame
      } else {
        return $0 < $1 ? .orderedAscending : .orderedDescending
      }
    }
  }

}

// MARK: - Counting Sort

extension Sort {

  /// - Complexity: O(max(n, k))  where k = max value - min value + 1
  public static func countingSort<C>(
    _ collection: inout C,
    toInteger: (C.Element) throws -> Int
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    let minMax = try Sort.minMax(&collection, toInteger: toInteger)
    guard let (min, max) = minMax, max != min else { return }

    var counter = [Int](repeating: 0, count: max - min + 1)
    for elem in collection {
      counter[try toInteger(elem) - min] += 1
    }
    for i in stride(from: 1, to: counter.count, by: 1) {
      counter[i] += counter[i - 1]
    }

    let tmpCollection = try [C.Element](unsafeUninitializedCapacity: collection.count) {
      (buffer, count) in
      var index = collection.index(before: collection.endIndex)
      while index >= collection.startIndex {
        let value = collection[index]
        let i = try toInteger(value) - min
        counter[i] -= 1
        buffer[counter[i]] = value
        count += 1
        collection.formIndex(before: &index)
      }
    }

    for (index, elem) in zip(collection.indices, tmpCollection) {
      collection[index] = elem
    }
  }

  public static func countingSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: BinaryInteger
  {
    countingSort(&collection) { Int($0) }
  }

}

// MARK: - Integer Sort

extension Sort {

  /// - Complexity: O(max(n, k))  where k = max value - min value + 1
  public static func integerSort<C>(
    _ collection: inout C,
    toInteger: (C.Element) throws -> Int
  ) rethrows
  where
    C: RandomAccessCollection & MutableCollection
  {

    let minMax = try Sort.minMax(&collection, toInteger: toInteger)
    guard let (min, max) = minMax, max != min else { return }

    var counter = [[C.Element]](repeating: [C.Element](), count: max - min + 1)
    for elem in collection {
      counter[try toInteger(elem) - min].append(elem)
    }

    var index = collection.startIndex
    for list in counter {
      for elem in list {
        collection[index] = elem
        collection.formIndex(after: &index)
      }
    }
  }

  /// - Complexity: O(max(n, k))  where k = max value - min value + 1
  public static func integerSort<C>(_ collection: inout C)
  where
    C: RandomAccessCollection & MutableCollection,
    C.Element: BinaryInteger
  {

    guard let min = collection.min(), let max = collection.max(),
      max != min
    else {
      return
    }

    var counter = [C.Element](repeating: 0, count: Int(max - min + 1))
    for elem in collection {
      counter[Int(elem - min)] += 1
    }

    var index = collection.startIndex
    for (i, count) in counter.enumerated() {
      let elem = C.Element(i) + min
      for _ in stride(from: 0, to: count, by: 1) {
        collection[index] = elem
        collection.formIndex(after: &index)
      }
    }
  }

}

// MARK: - Utility

extension Sort {

  private static func minMax<C: Collection>(
    _ collection: inout C,
    toInteger: (C.Element) throws -> Int
  ) rethrows -> (min: Int, max: Int)? {

    func areInIncreasingOrder(lhs: C.Element, rhs: C.Element) throws -> Bool {
      try toInteger(lhs) < toInteger(rhs)
    }

    guard
      let max = try collection.max(by: areInIncreasingOrder),
      let min = try collection.min(by: areInIncreasingOrder)
    else {
      return nil
    }
    return (min: try toInteger(min), max: try toInteger(max))
  }

}
