//
//  PreventScreenshot.swift
//  PreventScreenshot
//
//  Created by Wesley de Groot on 25/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/PreventScreenshot
//  MIT LICENCE
//

#if !os(watchOS) && !os(Linux)
import SwiftUI

#if os(macOS)
typealias PlatformView = NSView
typealias PlatformTextField = NSSecureTextField
typealias PlatformRepresentable = NSViewRepresentable
typealias PlatformHostingController = NSHostingController
#else
typealias PlatformView = UIView
typealias PlatformTextField = UITextField
typealias PlatformRepresentable = UIViewRepresentable
typealias PlatformHostingController = UIHostingController
#endif

/// Screenshot Prevent Wrapper
struct ScreenshotPreventWrapper<Content: View>: PlatformRepresentable {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeNSView(context: Context) -> PlatformView {
        return self.makeUIView(context: context)
    }

    func makeUIView(context: Context) -> PlatformView {
        let secureTextField = PlatformTextField()

#if !os(macOS)
        guard let secureView = secureTextField.layer.sublayers?.first?.delegate as? PlatformView else {
            return PlatformView()
        }

        secureTextField.isSecureTextEntry = true
        secureTextField.isUserInteractionEnabled = false
#else
        guard let secureView = secureTextField.layer?.sublayers?.first?.delegate as? PlatformView else {
            return PlatformView()
        }
#endif

        secureView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        let hostedContent = PlatformHostingController(rootView: content())
        #if os(macOS)
        // This seems not to work
        hostedContent.view.layer?.backgroundColor = .clear
        #else
        hostedContent.view.backgroundColor = .clear
        #endif
        hostedContent.view.translatesAutoresizingMaskIntoConstraints = false

        secureView.addSubview(hostedContent.view)
        NSLayoutConstraint.activate([
            hostedContent.view.topAnchor.constraint(equalTo: secureView.topAnchor),
            hostedContent.view.bottomAnchor.constraint(equalTo: secureView.bottomAnchor),
            hostedContent.view.leadingAnchor.constraint(equalTo: secureView.leadingAnchor),
            hostedContent.view.trailingAnchor.constraint(equalTo: secureView.trailingAnchor)
        ])

        return secureView
    }

    func updateNSView(_ nsView: PlatformView, context: Context) { }
    func updateUIView(_ uiView: PlatformView, context: Context) { }
}

extension View {
    /// Prevent Screenshot
    @ViewBuilder public func preventScreenshot() -> some View {
        ScreenshotPreventWrapper {
            self
                .redacted(reason: .privacy)
                .privacySensitive()
        }
    }
}
#endif
