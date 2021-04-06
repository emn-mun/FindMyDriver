import Foundation

prefix operator ..
infix operator .. : MultiplicationPrecedence

@discardableResult
public func .. <T>(object: T, configuration: (inout T) -> Void) -> T {
    var object = object
    configuration(&object)
    return object
}

public prefix func .. <T>(factory: () -> T) -> T {
    return factory()
}
