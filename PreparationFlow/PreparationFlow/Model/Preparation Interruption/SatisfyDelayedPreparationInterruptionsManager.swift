import Foundation

actor SatisfyDelayedPreparationInterruptionsManager: PreparationInterruptionsManageable {
    private let decoratee: PreparationInterruptionsManageable
    private let satisfyDelayInNanoseconds: UInt64
    private var satisfyTask: Task<Void, Never>?
    
    init(
        decoratee: PreparationInterruptionsManageable,
        satisfyDelayInNanoseconds: UInt64
    ) {
        self.decoratee = decoratee
        self.satisfyDelayInNanoseconds = satisfyDelayInNanoseconds
    }
    
    func getCurrentInterruption() async -> PreparationInterruption? {
        return await decoratee.getCurrentInterruption()
    }
    
    func setCurrentInterruption(_ interruption: PreparationInterruption?) async {
        await decoratee.setCurrentInterruption(interruption)
    }
    
    func add(subscription: @escaping (PreparationInterruption?) -> Void) async {
        await decoratee.add(subscription: subscription)
    }
    
    func add(observableInterruption interruption: PreparationInterruption) async {
        await decoratee.add(observableInterruption: interruption)
    }
    
    func remove(observableInterruption interruption: PreparationInterruption) async {
        await decoratee.remove(observableInterruption: interruption)
    }
    
    func manage(triggeredInterruption interruption: PreparationInterruption) async {  
        if await getCurrentInterruption() == interruption {
            cancelSatisfyTask()
        }
        await decoratee.manage(triggeredInterruption: interruption)
    }
    
    func manage(satisfiedInterruption interruption: PreparationInterruption) async {
        if await getCurrentInterruption() == interruption {
            satisfyTask = Task { [weak self] in
                guard let self else { return }
                
                try? await Task.sleep(nanoseconds: satisfyDelayInNanoseconds)
                guard !Task.isCancelled else { return }
                
                await decoratee.manage(satisfiedInterruption: interruption)
            }
            await satisfyTask?.value
        } else {
            await decoratee.manage(satisfiedInterruption: interruption)
        }
    }
    
    private func cancelSatisfyTask() {
        satisfyTask?.cancel()
        satisfyTask = nil
    }
}
