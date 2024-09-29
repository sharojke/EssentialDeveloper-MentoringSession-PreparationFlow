enum SystemVolumeValuesProvider {
    static func provide(
        volume: Float,
        satisfyingVolume: Float
    ) -> (isSatisfied: Bool, title: String) {
        let volumeString = Int(volume * 100)
        let title = "System volume is\n\(volumeString)%"
        return (volume == satisfyingVolume, title)
    }
}
