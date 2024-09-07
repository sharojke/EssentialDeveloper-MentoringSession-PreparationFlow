protocol PreparationInterruptionsManageable {
    func add(subscription: @escaping (PreparationInterruption?) -> Void) async
    func add(observableInterruption interruption: PreparationInterruption) async
    func remove(observableInterruption interruption: PreparationInterruption) async
    func manage(triggeredInterruption interruption: PreparationInterruption) async
    func manage(satisfiedInterruption interruption: PreparationInterruption) async
}
