import Foundation
import SwiftUI
import PhotosUI
import Combine

class UserProfile: ObservableObject {

    @Published var displayName: String {
        didSet { UserDefaults.standard.set(displayName, forKey: "profile_name") }
    }
    @Published var homeNeighborhood: String {
        didSet { UserDefaults.standard.set(homeNeighborhood, forKey: "profile_neighborhood") }
    }
    @Published var bio: String {
        didSet { UserDefaults.standard.set(bio, forKey: "profile_bio") }
    }
    @Published var profileImageData: Data? {
        didSet { UserDefaults.standard.set(profileImageData, forKey: "profile_image") }
    }

    var profileImage: UIImage? {
        guard let data = profileImageData else { return nil }
        return UIImage(data: data)
    }

    var initials: String {
        let parts = displayName.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return displayName.prefix(2).uppercased()
    }

    var isSetUp: Bool { !displayName.isEmpty }

    init() {
        displayName      = UserDefaults.standard.string(forKey: "profile_name")         ?? ""
        homeNeighborhood = UserDefaults.standard.string(forKey: "profile_neighborhood") ?? ""
        bio              = UserDefaults.standard.string(forKey: "profile_bio")          ?? ""
        profileImageData = UserDefaults.standard.data(forKey: "profile_image")
    }
}
