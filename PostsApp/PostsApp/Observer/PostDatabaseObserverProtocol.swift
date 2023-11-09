import Foundation

protocol PostDatabaseObserverProtocol {
    var onChange: ((ObserverChangeResult<[Post]>) -> Void)? { get set }
    
    func startObserving()
}
