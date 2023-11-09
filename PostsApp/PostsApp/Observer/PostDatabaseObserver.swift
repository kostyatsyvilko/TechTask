import Foundation

final class PostDatabaseObserver: PostDatabaseObserverProtocol {
    private var databaseObserver: CoreDataFetchedResultsObserver<PostManagedObject>
    
    var onChange: ((ObserverChangeResult<[Post]>) -> Void)?
    
    init(databaseObserver: CoreDataFetchedResultsObserver<PostManagedObject>) {
        self.databaseObserver = databaseObserver
    }
    
    func startObserving() {
        databaseObserver.startObserving()
        databaseObserver.onChange = onDbObserverChange(result:)
    }
    
    private func onDbObserverChange(result: ObserverChangeResult<[PostManagedObject]>) {
        let posts = result.value.map { Post(from: $0) }
        let transformedResult = ObserverChangeResult(type: result.type,
                                                     value: posts)
        onChange?(transformedResult)
    }
}
