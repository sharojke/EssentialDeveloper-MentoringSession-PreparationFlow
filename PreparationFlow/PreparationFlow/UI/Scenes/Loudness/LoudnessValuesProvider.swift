enum LoudnessValuesProvider {
    static func provide(
        level: LoudnessLevel,
        loud: String = "Loudness is\nNOT OK",
        quiet: String = "Loudness is\nOK"
    ) -> (isLoud: Bool, title: String) {
        return switch level {
        case .loud:
            (true, loud)
            
        case .quiet:
            (false, quiet)
        }
    }
}
