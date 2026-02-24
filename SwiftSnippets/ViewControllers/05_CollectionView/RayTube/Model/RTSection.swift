//
//  RTSection.swift
//  SwiftSnippets
//
//  Created by huqilin on 2026/2/14.
//

import UIKit

class RTSection: Hashable {
    var id = UUID()
    var title: String
    var videos: [RTVideo]

    init(title: String, videos: [RTVideo]) {
        self.title = title
        self.videos = videos
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: RTSection, rhs: RTSection) -> Bool {
        lhs.id == rhs.id
    }
}

extension RTSection {
    static var allSections: [RTSection] = [
        RTSection(title: "SwiftUI", videos: [
            RTVideo(
                title: "SwiftUI",
                thumbnail: UIImage(named: "swiftui"),
                lessonCount: 37,
                link: URL(string: "https://www.raywenderlich.com/4001741-swiftui")
            )
        ]),
        RTSection(title: "UIKit", videos: [
            RTVideo(
                title: "Demystifying Views in iOS",
                thumbnail: UIImage(named: "views"),
                lessonCount: 26,
                link:URL(string: "https://www.raywenderlich.com/4518-demystifying-views-in-ios")
            ),
            RTVideo(
                title: "Reproducing Popular iOS Controls",
                thumbnail: UIImage(named: "controls"),
                lessonCount: 31,
                link: URL(string: "https://www.raywenderlich.com/5298-reproducing-popular-ios-controls")
            )
        ]),
        RTSection(title: "Frameworks", videos: [
            RTVideo(
                title: "Fastlane for iOS",
                thumbnail: UIImage(named: "fastlane"),
                lessonCount: 44,
                link: URL(string:"https://www.raywenderlich.com/1259223-fastlane-for-ios")
            ),
            RTVideo(
                title: "Beginning RxSwift",
                thumbnail: UIImage(named: "rxswift"),
                lessonCount: 39,
                link: URL(string: "https://www.raywenderlich.com/4743-beginning-rxswift")
            )
        ]),
        RTSection(title: "Miscellaneous", videos: [
            RTVideo(
                title: "Data Structures & Algorithms in Swift",
                thumbnail: UIImage(named: "datastructures"),
                lessonCount: 29,
                link: URL(string: "https://www.raywenderlich.com/977854-data-structures-algorithms-in-swift")
            ),
            RTVideo(
                title: "Beginning ARKit",
                thumbnail: UIImage(named: "arkit"),
                lessonCount: 46,
                link: URL(string: "https://www.raywenderlich.com/737368-beginning-arkit")
            ),
            RTVideo(
                title: "Machine Learning in iOS",
                thumbnail: UIImage(named: "machinelearning"),
                lessonCount: 15,
                link: URL(string: "https://www.raywenderlich.com/1320561-machine-learning-in-ios")
            ),
            RTVideo(
                title: "Push Notifications",
                thumbnail: UIImage(named: "notifications"),
                lessonCount: 33,
                link: URL(string: "https://www.raywenderlich.com/1258151-push-notifications")
            ),
        ])
    ]
}
