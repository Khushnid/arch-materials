import UIKit
import KooberUIKit
import KooberKit
import MapKit

class PickMeUpMapRootView: MKMapView {

  // MARK: - Properties
  let defaultMapSpan = MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006)
  let mapDropoffLocationSpan = MKCoordinateSpan(latitudeDelta: 0.017, longitudeDelta: 0.017)

  var pickupLocation: Location? {
    didSet {
      if let pickupLocation = pickupLocation {
        pickupLocationAnnotation = MapAnnotationType.makePickupLocationAnnotation(for: pickupLocation)
      } else {
        pickupLocationAnnotation = nil
      }
    }
  }

  var dropoffLocation: Location? {
    didSet {
      dropoffLocationAnnotation = MapAnnotationType.makeDropoffLocationAnnotation(for: dropoffLocation)
      guard let coordinate = dropoffLocationAnnotation?.coordinate else { return }
      zoomOutToShowDropoffLocation(pickupCoordinate: coordinate)
    }
  }

  var imageCache: ImageCache

  var mapState = MapViewState() {
    didSet {
      let currentAnnotations = (annotations as! [MapAnnotation]) // In real world, cast instead of force unwrap.
      let updatedAnnotations = mapState.availableRideLocationAnnotations
        + mapState.pickupLocationAnnotations
        + mapState.dropoffLocationAnnotations

      let diff = MapAnnotionDiff.diff(currentAnnotations: currentAnnotations, updatedAnnotations: updatedAnnotations)
      if !diff.annotationsToRemove.isEmpty {
        removeAnnotations(diff.annotationsToRemove)
      }
      if !diff.annotationsToAdd.isEmpty {
        addAnnotations(diff.annotationsToAdd)
      }

      if !mapState.dropoffLocationAnnotations.isEmpty {
        zoomOutToShowDropoffLocation(pickupCoordinate: mapState.pickupLocationAnnotations[0].coordinate)
      } else {
        zoomIn(pickupCoordinate: mapState.pickupLocationAnnotations[0].coordinate)
      }
    }
  }

  var pickupLocationAnnotation: MapAnnotation? {
    didSet {
      guard oldValue != pickupLocationAnnotation else { return }
      removeAnnotation(oldValue)
      addAnnotation(pickupLocationAnnotation)
      guard let annotation = pickupLocationAnnotation else { return }
      zoomIn(pickupCoordinate: annotation.coordinate)
    }
  }

  var dropoffLocationAnnotation: MapAnnotation? {
    didSet {
      guard oldValue != dropoffLocationAnnotation else { return }
      removeAnnotation(oldValue)
      addAnnotation(dropoffLocationAnnotation)
    }
  }

  // MARK: - Methods
  init(frame: CGRect = .zero, imageCache: ImageCache) {
    self.imageCache = imageCache
    super.init(frame: frame)
    delegate = self
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported by PickMeUpMapRootView.")
  }

  func removeAnnotation(_ annotation: MapAnnotation?) {
    guard let annotation = annotation else { return }
    removeAnnotation(annotation)
  }

  func addAnnotation(_ annotation: MapAnnotation?) {
    guard let annotation = annotation else { return }
    addAnnotation(annotation)
  }

  func zoomIn(pickupCoordinate: CLLocationCoordinate2D) {
    let center = pickupCoordinate
    let span = defaultMapSpan
    let region = MKCoordinateRegion(center: center, span: span)
    setRegion(region, animated: false)
  }

  func zoomOutToShowDropoffLocation(pickupCoordinate: CLLocationCoordinate2D) {
    let center = pickupCoordinate
    let span = mapDropoffLocationSpan
    let region = MKCoordinateRegion(center: center, span: span)
    setRegion(region, animated: true)
  }
}

extension PickMeUpMapRootView: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? MapAnnotation else {
      return nil
    }
    let reuseID = reuseIdentifier(forAnnotation: annotation)
    guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) else {
      return MapAnnotationView(annotation: annotation, reuseIdentifier: reuseID, imageCache: imageCache)
    }
    annotationView.annotation = annotation
    return annotationView
  }

  func reuseIdentifier(forAnnotation annotation: MapAnnotation) -> String {
    return annotation.imageIdentifier
  }
}
