open class MockBase {
  
  public init() {}
  
  public var calledMethods: [String] = []
  
  public final func track(method: String) {
    calledMethods.append(method)
  }
  
  public final func resetCalledMethods() {
    calledMethods = []
  }
}
