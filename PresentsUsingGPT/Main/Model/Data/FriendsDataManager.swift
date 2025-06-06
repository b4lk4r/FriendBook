class FriendsDataManager {
    static let shared = FriendsDataManager()
    
    private init() {}

    private var friends: [Friend] = []

    func setFriends(_ list: [Friend]) {
        self.friends = list
    }

    func getFriends() -> [Friend] {
        return friends
    }
}
