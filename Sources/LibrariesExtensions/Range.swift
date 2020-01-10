extension ClosedRange {

  func contains(_ range: ClosedRange) -> Bool {
    lowerBound <= range.lowerBound && upperBound >= range.upperBound
  }

}
