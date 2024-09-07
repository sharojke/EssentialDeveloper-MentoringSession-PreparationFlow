enum PreparationInterruption: Equatable, CaseIterable {
    case headphones
    case systemVolume
    case loudness
    
    var priority: Int {
        return switch self {
        case .headphones:
            750
            
        case .systemVolume:
            500
            
        case .loudness:
            250
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.priority == rhs.priority
    }
}
