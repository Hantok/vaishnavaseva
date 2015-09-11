import Foundation

// Standard Equatable protocol with its == operator is not enough for us as we need to:
// - Compare objects saved by the base class or protocol while operators are not polymorphic
// - Compare objects of possibly different types which is not supported by standard == operator

protocol EquatablePolymorphic: class//use if you cannot use EquatableBase as your base class in some reason but don't forget to copy the isEqualTo() implementation from EquatableBase class below
  {
  func isEqualTo(other: Self) -> Bool
  }

class EquatableBase: EquatablePolymorphic
  {
  func isEqualTo(other: EquatableBase) -> Bool
    {
    if self.dynamicType != other.dynamicType
      {
      return false
      }
    return true//in subclasses: {return super.isEqualTo(other) && self.state==other.state}
    }
  }
