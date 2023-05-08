import UIKit

public struct RideOptionSegmentState: Equatable {

  // MARK: - Properties
  public var id: String
  public var title: String
  public var isSelected: Bool
  public var images: ButtonRemoteImages

  // MARK: - Methods
  public init(id: String,
              title: String,
              isSelected: Bool,
              images: ButtonRemoteImages) {
    self.id = id
    self.title = title
    self.isSelected = isSelected
    self.images = images
  }

  public enum ButtonRemoteImages: Equatable {

    case notLoaded(normal: URL, selected: URL)
    case loaded(normalURL: URL, normalImage: UIImage, selectedURL: URL, selectedImage: UIImage)
  }
}

extension Collection where Element == RideOptionSegmentState, Index == Int {

  public func idsEqual(to rhs: Self) -> Bool {
    let lhs = self
    guard lhs.count == rhs.count else {
      return false
    }
    for (index, lhsElement) in lhs.enumerated() {
      let rhsElement = rhs[index]
      if lhsElement.id != rhsElement.id {
        return false
      }
    }
    return true
  }
}
