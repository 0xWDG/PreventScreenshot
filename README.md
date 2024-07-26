# PreventScreenshot

PreventScreenshot allows you to prevents screenshots of a SwiftUI Element.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreventScreenshot%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xWDG/PreventScreenshot)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xWDG%2FPreventScreenshot%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xWDG/PreventScreenshot)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)
![License](https://img.shields.io/github/license/0xWDG/PreventScreenshot)

## Requirements

- Swift 5.9+ (Xcode 15+)
- iOS 13+, macOS 10.15+, tvOS 15+, visionOS 1+

## Installation (Pakage.swift)

```swift
dependencies: [
    .package(url: "https://github.com/0xWDG/PreventScreenshot.git", branch: "main"),
],
targets: [
    .target(name: "MyTarget", dependencies: [
        .product(name: "PreventScreenshot", package: "PreventScreenshot"),
    ]),
]
```

## Installation (Xcode)

1. In Xcode, open your project and navigate to **File** → **Swift Packages** → **Add Package Dependency...**
2. Paste the repository URL (`https://github.com/0xWDG/PreventScreenshot`) and click **Next**.
3. Click **Finish**.

## Usage

Example to read a ImageView (Multi platform):

```swift
import SwiftUI
import PreventScreenshot

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Don't take a screenshot of this")
                .preventScreenshot()
        }
        .padding()
    }
}
```

## Contact

We can get in touch via [Twitter/X](https://twitter.com/0xWDG), [Discord](https://discordapp.com/users/918438083861573692), [Mastodon](https://mastodon.social/@0xWDG), [Email](mailto:email+oss@wesleydegroot.nl), [Website](https://wesleydegroot.nl).
