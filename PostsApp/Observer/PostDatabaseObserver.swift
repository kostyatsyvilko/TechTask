import Foundation

protocol PostDatabaseObserver {
    var onChange: ((ObserverChangeResult<[Post]>) -> Void)? { get set }
    
    func startObserving() throws
}
