import Foundation
import RegexBuilder

public struct CaptureDigits: RegexComponent {

  public init() {}

  public var regex: Regex<Regex<Capture<(Substring, Int)>.RegexOutput>.RegexOutput> {
    let regex = Regex {
      Capture {
        OneOrMore {
          CharacterClass.digit
        }
      } transform: {
        Int($0)!
      }
    }
    return regex
  }

}
