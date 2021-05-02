//
//  Box.swift
//  Whisper
//
//  Created by Christyan Huber Duarte Ibanez on 01/05/21.
//

final class Box<T> {

  typealias Listener = (T) -> Void
  var listener: Listener?

  var value: T {
    didSet {
      listener?(value)
    }
  }
    
  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
