//
//  AudioPlayerViewModel.swift
//  Ondare
//
//  Created by Eldar Tutnjic on 5. 7. 2025..
//

import AVFoundation
import Foundation
import MediaPlayer

class AudioPlayerViewModel: ObservableObject {
    struct AudioPlayerState {
        var isPlaying = false
        var currentStationName: String? = nil
        var currentStationURL: URL? = nil
        var currentStationImageURL: URL? = nil
    }

    struct Metadata {
        var title: String
        var artist: String?
        var artworkURL: URL?
    }

    enum Action {
        case playOrPause
        case playRadioStation(URL)
    }

    @Published private(set) var state = AudioPlayerState()

    var audioPlayer: AVPlayer?

    init() {
        setupRemoteTransportControls()
        setupAudioSession()
    }
}

// MARK: - Utils

extension AudioPlayerViewModel {
    func send(_ action: Action, metadata: Metadata? = nil) {
        Task {
            await handle(action, metadata: metadata)
        }
    }
}

// MARK: - Actions

extension AudioPlayerViewModel {
    @MainActor
    private func handle(_ action: Action, metadata: Metadata? = nil) async {
        switch action {
        case .playOrPause:
            togglePlayPause()
        case .playRadioStation(let url):
            playRadioStation(from: url, metadata: metadata)
        }
    }
}

// MARK: - Functions

extension AudioPlayerViewModel {
    private func playRadioStation(from url: URL, metadata: Metadata?) {
        if state.currentStationURL == url {
            togglePlayPause()
            return
        }

        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()

        state.currentStationURL = url
        state.isPlaying = true

        if let metadata = metadata {
            updateNowPlayingInfo(
                title: metadata.title,
                artist: metadata.artist,
                artworkURL: metadata.artworkURL
            )

            state.currentStationName = metadata.title
            state.currentStationImageURL = metadata.artworkURL
        }
    }

    private func togglePlayPause() {
        guard let player = audioPlayer else { return }

        if state.isPlaying {
            player.pause()
        } else {
            player.play()
        }

        state.isPlaying.toggle()
    }

    private func updateNowPlayingInfo(
        title: String,
        artist: String? = nil,
        artworkURL: URL? = nil
    ) {
        var nowPlayingInfo: [String: Any] = [
            MPMediaItemPropertyTitle: title
        ]

        if let artist = artist {
            nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo

        if let artworkURL = artworkURL {
            Task {
                if let data = try? await URLSession.shared.data(from: artworkURL).0,
                   let image = UIImage(data: data)
                {
                    let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }

                    var updatedInfo = nowPlayingInfo
                    updatedInfo[MPMediaItemPropertyArtwork] = artwork

                    MPNowPlayingInfoCenter.default().nowPlayingInfo = updatedInfo
                }
            }
        }
    }

    private func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.audioPlayer?.play()
            self?.state.isPlaying = true
            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.audioPlayer?.pause()
            self?.state.isPlaying = false
            return .success
        }
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
}
