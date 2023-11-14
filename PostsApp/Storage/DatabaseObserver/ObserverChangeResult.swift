import Foundation

struct ObserverChangeResult<T: Hashable> {
    let type: ObserverChangeType
    let value: T
}
