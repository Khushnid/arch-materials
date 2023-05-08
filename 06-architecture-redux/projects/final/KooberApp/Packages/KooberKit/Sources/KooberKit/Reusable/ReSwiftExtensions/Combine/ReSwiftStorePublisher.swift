

import Foundation
import ReSwift
import Combine

public typealias TransformClosure<StateT: Any, SelectedStateT: Equatable> = (ReSwift.Subscription<StateT>) -> ReSwift.Subscription<SelectedStateT>
public typealias ScopedTransformClosure<StateT: Any, SelectedStateT: Equatable> = (ReSwift.Subscription<StateT>) -> ReSwift.Subscription<ScopedState<SelectedStateT>>

extension Store where State: Equatable {

  public func publisher() -> AnyPublisher<State, Never> {
    return StatePublisher(store: self).eraseToAnyPublisher()
  }

  public func publisher<SelectedStateT>(transform: @escaping TransformClosure<State, SelectedStateT>) -> AnyPublisher<SelectedStateT, Never> {
    return FilteredStatePublisher(store: self,
                                  transform: transform).eraseToAnyPublisher()
  }

  public func publisher<SelectedStateT>(transform: @escaping ScopedTransformClosure<State, SelectedStateT>) -> AnyPublisher<SelectedStateT, Never> {
    return FilteredStatePublisher(store: self,
                                  scopedTransfofm: transform).eraseToAnyPublisher()
  }

  struct StatePublisher: Combine.Publisher {
    typealias Output = State
    typealias Failure = Never

    let store: Store<State>

    func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input  {
      let subscription = StateSubscription(subscriber: subscriber, store: store)
      subscriber.receive(subscription: subscription)
    }
  }

  struct FilteredStatePublisher<SelectedStateT: Equatable>: Combine.Publisher {
    typealias Output = SelectedStateT
    typealias Failure = Never

    let store: Store<State>
    let transform: TransformClosure<State, SelectedStateT>?
    let scopedTransform: ScopedTransformClosure<State, SelectedStateT>?

    init(store: Store<State>,
         transform: @escaping TransformClosure<State, SelectedStateT>) {
      self.store = store
      self.transform = transform
      self.scopedTransform = nil
    }

    init(store: Store<State>,
         scopedTransfofm: @escaping ScopedTransformClosure<State, SelectedStateT>) {
      self.store = store
      self.transform = nil
      self.scopedTransform = scopedTransfofm
    }

    func receive<S: Subscriber>(subscriber: S) where Failure == S.Failure, Output == S.Input {
      if let transform = self.transform  {
        let subscription = FilteredStateSubscription(subscriber: subscriber,
                                                     store: store,
                                                     transform: transform)
        subscriber.receive(subscription: subscription)
      } else if let scopedTransform = self.scopedTransform {
        let subscription = ScopedFilteredStateSubscription(subscriber: subscriber,
                                                           store: store,
                                                           scopedTransform: scopedTransform)
        subscriber.receive(subscription: subscription)
      }
    }
  }
}

private final class StateSubscription<S: Subscriber, StateT: Any>: Combine.Subscription, StoreSubscriber where S.Input == StateT {
  var requested: Subscribers.Demand = .none
  var subscriber: S?

  let store: Store<StateT>
  var subscribed = false

  init(subscriber: S, store: Store<StateT>) {
    self.subscriber = subscriber
    self.store = store
  }

  func cancel() {
    store.unsubscribe(self)
    subscriber = nil
  }

  func request(_ demand: Subscribers.Demand) {
    requested += demand

    if !subscribed, requested > .none {
      // Subscribe to ReSwift store
      store.subscribe(self)
      subscribed = true
    }
  }

  // ReSwift calls this method on state changes
  func newState(state: StateT) {
    guard requested > .none else {
      return
    }
    requested -= .max(1)

    // Forward ReSwift update to subscriber
    _ = subscriber?.receive(state)
  }
}

private final class FilteredStateSubscription
  <S: Subscriber, StateT: Any, SelectedStateT: Equatable>:
  Combine.Subscription, StoreSubscriber where S.Input == SelectedStateT {

  var requested: Subscribers.Demand = .none
  var subscriber: S?

  let store: Store<StateT>
  var subscribed = false
  let transform: TransformClosure<StateT, SelectedStateT>

  init(subscriber: S,
       store: Store<StateT>,
       transform: @escaping TransformClosure<StateT, SelectedStateT>) {
    self.subscriber = subscriber
    self.store = store
    self.transform = transform
  }

  func cancel() {
    store.unsubscribe(self)
    subscriber = nil
  }

  func request(_ demand: Subscribers.Demand) {
    requested += demand

    if !subscribed, requested > .none {
      // Subscribe to ReSwift store
      store.subscribe(self, transform: self.transform)
      subscribed = true
    }
  }

  // ReSwift calls this method on state changes
  func newState(state: SelectedStateT) {
    guard requested > .none else {
      return
    }
    requested -= .max(1)

    _ = subscriber?.receive(state)
  }
}

private final class ScopedFilteredStateSubscription<S: Subscriber, StateT: Any, SelectedStateT: Equatable>: Combine.Subscription, StoreSubscriber where S.Input == SelectedStateT {
  var requested: Subscribers.Demand = .none
  var subscriber: S?

  let store: Store<StateT>
  var subscribed = false
  let scopedTransform: ScopedTransformClosure<StateT, SelectedStateT>

  init(subscriber: S,
       store: Store<StateT>,
       scopedTransform: @escaping ScopedTransformClosure<StateT, SelectedStateT>) {
    self.subscriber = subscriber
    self.store = store
    self.scopedTransform = scopedTransform
  }

  func cancel() {
    store.unsubscribe(self)
    subscriber = nil
  }

  func request(_ demand: Subscribers.Demand) {
    requested += demand

    if !subscribed, requested > .none {
      // Subscribe to ReSwift store
      store.subscribe(self, transform: scopedTransform)
      subscribed = true
    }
  }

  // ReSwift calls this method on state changes
  func newState(state: ScopedState<SelectedStateT>) {
    guard requested > .none else {
      return
    }
    requested -= .max(1)

    switch state {
    case let .inScope(inScopeState):
      _ = subscriber?.receive(inScopeState)
    case .outOfScope:
      _ = subscriber?.receive(completion: .finished)
    }
  }
}
