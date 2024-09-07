protocol PreparationInterruptionsManageable {
    var onCurrentInterruption: (PreparationInterruption?) -> Void { get set }
    
    func add(observableInterruption interruption: PreparationInterruption)
    func remove(observableInterruption interruption: PreparationInterruption)
    func manage(triggeredInterruption interruption: PreparationInterruption)
    func manage(satisfiedInterruption interruption: PreparationInterruption)
}
