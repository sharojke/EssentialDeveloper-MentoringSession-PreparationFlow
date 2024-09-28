enum HeadphonesConnectionTitleProvider {
    static func provide(
        isConnected: Bool,
        connected: String = "Headphones are\nCONNECTED",
        disconnected: String = "Headphones are\nNOT CONNECTED"
    ) -> String {
        return isConnected ? connected : disconnected
    }
}
