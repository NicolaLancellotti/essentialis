import Foundation

extension ComparisonResult {
  var orderedAscendingOrSame: Bool {
    self == .orderedAscending || self == .orderedSame
  }
}
