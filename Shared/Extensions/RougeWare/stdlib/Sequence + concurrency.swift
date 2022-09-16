//
//  Sequence + concurrency.swift
//  Swiftelbrot
//
//  Created by S🌟System on 2022-08-30.
//



extension Collection
    where Index: Hashable
{
    func mapAsync<T>(_ transform: @escaping @Sendable (Element) async -> T) async -> [T] {
        var values = [Index : T]()
        values.reserveCapacity(count)

        await indices.forEachAsync { index in
            values[index] = await transform(self[index])
        }

        return values
            .sorted(by: { $0.key < $1.key })
            .map(\.value)
    }
}



extension Sequence {
    func forEachAsync(_ operation: @escaping (Element) async throws -> Void) async throws {
        
        let error = ActorBox<any Error>()
        
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                guard group.addTaskUnlessCancelled(operation: {
                    do {
                        try await operation(element)
                    }
                    catch let subError {
                        await error.setValue(subError)
                    }
                })
                else {
                    group.cancelAll()
                    return
                }
                
                guard await nil != error.value else {
                    group.cancelAll()
                    return
                }
            }
        }
        
        if let error = await error.value {
            throw error
        }
    }
    
    
    
    func forEachAsync(_ operation: @escaping (Element) async -> Void) async {
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                
                do {
                    try Task.checkCancellation()
                }
                catch {
                    group.cancelAll()
                    return
                }
                
                guard group.addTaskUnlessCancelled(operation: {
                    await operation(element)
                })
                else {
                    group.cancelAll()
                    return
                }
            }
            
            await group.waitForAll()
        }
    }
}

private actor ActorBox<Value> {
    var value: Value? = nil
    
    func setValue(_ newValue: Value?) {
        self.value = newValue
    }
}
