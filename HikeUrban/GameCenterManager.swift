import Foundation
import GameKit
import UIKit
import Combine

// MARK: - Lightweight entry for SwiftUI

struct GCEntry: Identifiable {
    let id: String
    let rank: Int
    let displayName: String
    let steps: Int
    let isLocalPlayer: Bool
}

// MARK: - Manager

class GameCenterManager: ObservableObject {

    static let leaderboardID = "RoadRunner"

    @Published var isAuthenticated = false
    @Published var isLoading       = false
    @Published var entries: [GCEntry] = []

    // MARK: - Auth

    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] vc, _ in
            DispatchQueue.main.async {
                if let vc {
                    self?.presentOnKeyWindow(vc)
                } else if GKLocalPlayer.local.isAuthenticated {
                    self?.isAuthenticated = true
                    self?.loadLeaderboard()
                } else {
                    self?.isAuthenticated = false
                }
            }
        }
    }

    // MARK: - Submit

    func submitScore(_ totalSteps: Int) {
        guard GKLocalPlayer.local.isAuthenticated, totalSteps > 0 else { return }
        GKLeaderboard.submitScore(
            totalSteps,
            context: 0,
            player: GKLocalPlayer.local,
            leaderboardIDs: [Self.leaderboardID]
        ) { error in
            if let error { print("GC submit error: \(error.localizedDescription)") }
        }
    }

    // MARK: - Load

    func loadLeaderboard() {
        guard GKLocalPlayer.local.isAuthenticated else { return }
        isLoading = true

        GKLeaderboard.loadLeaderboards(IDs: [Self.leaderboardID]) { [weak self] boards, error in
            guard let board = boards?.first else {
                DispatchQueue.main.async { self?.isLoading = false }
                return
            }
            board.loadEntries(
                for: .global,
                timeScope: .allTime,
                range: NSRange(location: 1, length: 10)
            ) { [weak self] local, entries, _, _ in
                DispatchQueue.main.async {
                    self?.entries = (entries ?? []).map { e in
                        GCEntry(
                            id: e.player.gamePlayerID,
                            rank: e.rank,
                            displayName: e.player.displayName,
                            steps: e.score,
                            isLocalPlayer: e.player.gamePlayerID == GKLocalPlayer.local.gamePlayerID
                        )
                    }
                    self?.isLoading = false
                }
            }
        }
    }

    // MARK: - Present native UI

    func presentFullLeaderboard() {
        if #available(iOS 26.0, *) {
            GKAccessPoint.shared.trigger(
                leaderboardID: Self.leaderboardID,
                playerScope: .global,
                timeScope: .allTime
            )
        } else {
            let vc = GKGameCenterViewController(
                leaderboardID: Self.leaderboardID,
                playerScope: .global,
                timeScope: .allTime
            )
            vc.gameCenterDelegate = _GCDelegate.shared
            presentOnKeyWindow(vc)
        }
    }

    private func presentOnKeyWindow(_ vc: UIViewController) {
        guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
              let root = scene.keyWindow?.rootViewController else { return }

        var top = root
        while let presented = top.presentedViewController { top = presented }
        top.present(vc, animated: true)
    }
}

// MARK: - GKGameCenterControllerDelegate (singleton helper, iOS < 26 only)

@available(iOS, deprecated: 26.0)
private class _GCDelegate: NSObject, GKGameCenterControllerDelegate {
    static let shared = _GCDelegate()
    func gameCenterViewControllerDidFinish(_ vc: GKGameCenterViewController) {
        vc.dismiss(animated: true)
    }
}
