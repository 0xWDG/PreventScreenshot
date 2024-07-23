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
    // The content which we going to wrap.
    let content: () -> Content

    // Initialize view with the content which we going to wrap.
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    // Create the NS(NextStep /AppKit) View
    func makeNSView(context: Context) -> PlatformView {
        return self.makeUIView(context: context)
    }

    // Create the UI(kit) View
    func makeUIView(context: Context) -> PlatformView {
        // Create a NSSecureTextField or UITextField (AKA PlatformTextField)
        let secureTextField = PlatformTextField()

#if !os(macOS)
        // Get the secure view
        guard let secureView = secureTextField.layer.sublayers?.first?.delegate as? PlatformView else {
            // Failed, return a default view
            return PlatformView()
        }

        // Tell the system that the entry needs to be secure (adds a non-screenshotable label)
        secureTextField.isSecureTextEntry = true

        // Tell the system that user interaction should not be enabled
        secureTextField.isUserInteractionEnabled = false
#else
        // Get the secure view, on macOS the layer is optional, so we need to chain it.
        guard let secureView = secureTextField.layer?.sublayers?.first?.delegate as? PlatformView else {
            // Failed, return a default view
            return PlatformView()
        }
#endif

        // Walk trough the subviews of our secure view
        secureView.subviews.forEach { subview in
            // Remove all subviews.
            subview.removeFromSuperview()
        }

        // Create a hosting controller for the SwiftUI view to make it usable for *Kit
        let hostedContent = PlatformHostingController(rootView: content())
        #if os(macOS)
        // This seems not to work
        hostedContent.view.layer?.backgroundColor = .clear
        #else
        // Make the background clear
        hostedContent.view.backgroundColor = .clear
        #endif
        // To not automatically create constraints.
        hostedContent.view.translatesAutoresizingMaskIntoConstraints = false

        // Add the hosted content to the secure view (as subview)
        secureView.addSubview(hostedContent.view)

        // Activate constraints
        NSLayoutConstraint.activate([
            hostedContent.view.topAnchor.constraint(equalTo: secureView.topAnchor),
            hostedContent.view.bottomAnchor.constraint(equalTo: secureView.bottomAnchor),
            hostedContent.view.leadingAnchor.constraint(equalTo: secureView.leadingAnchor),
            hostedContent.view.trailingAnchor.constraint(equalTo: secureView.trailingAnchor)
        ])

        // Return the new secure view
        return secureView
    }

    func updateNSView(_ nsView: PlatformView, context: Context) { }
    func updateUIView(_ uiView: PlatformView, context: Context) { }
}

extension View {
    /// Prevent Screenshot
    ///
    /// Adding this modifier to your SwiftUI View makes the view hidden in a screenshot.
    @ViewBuilder public func preventScreenshot() -> some View {
        ScreenshotPreventWrapper {
            self
                .redacted(reason: .privacy)
                .privacySensitive()
        }
    }
}
#endif
