import Foundation

final class PreparationInterruptionsManager: PreparationInterruptionsManageable {
    var onCurrentInterruption: (PreparationInterruption?) -> Void = { _ in }
    
    private var currentInterruption: PreparationInterruption?
    private var observableInterruptions: Set<PreparationInterruption>
    private var pendingInterruptions: Set<PreparationInterruption> = []
    
    init(
        currentInterruption: PreparationInterruption? = nil,
        observableInterruptions: Set<PreparationInterruption> = []
    ) {
        self.currentInterruption = currentInterruption
        self.observableInterruptions = observableInterruptions
    }
    
    func add(observableInterruption interruption: PreparationInterruption) {
        observableInterruptions.insert(interruption)
    }
    
    func remove(observableInterruption interruption: PreparationInterruption) {
        observableInterruptions.remove(interruption)
    }
    
    func manage(triggeredInterruption interruption: PreparationInterruption) {
        guard observableInterruptions.contains(interruption) else { return }
        
        if let currentInterruption {
            guard interruption != currentInterruption else { return }
            
            if interruption.priority > currentInterruption.priority {
                set(currentInterruption: interruption)
                pendingInterruptions.insert(currentInterruption)
            } else {
                pendingInterruptions.insert(interruption)
            }
        } else {
            set(currentInterruption: interruption)
        }
    }
    
    func manage(satisfiedInterruption interruption: PreparationInterruption) {
        if let currentInterruption, interruption == currentInterruption {
            set(currentInterruption: nextPendingInterruption())
        } else {
            pendingInterruptions.remove(interruption)
        }
    }
    
    // MARK: - Helpers
    
    private func set(currentInterruption: PreparationInterruption?) {
        self.currentInterruption = currentInterruption
        onCurrentInterruption(currentInterruption)
    }
    
    private func nextPendingInterruption() -> PreparationInterruption? {
        return pendingInterruptions.max { $0.priority < $1.priority }
    }
}
