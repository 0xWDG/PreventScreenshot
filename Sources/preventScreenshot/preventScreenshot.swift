//
//  Inspect.swift
//  Inspect
//
//  Created by Wesley de Groot on 25/06/2024.
//  https://wesleydegroot.nl
//
//  https://github.com/0xWDG/preventScreenshot
//  MIT LICENCE
//

import Foundation
import SwiftUI

#if !os(watchOS)
#if os(macOS)
public typealias PlatformView = NSView
public typealias PlatformTextField = NSSecureTextField
public typealias PlatformRepresentable = NSViewRepresentable
public typealias PlatformHostingController = NSHostingController
#else
public typealias PlatformView = UIView
public typealias PlatformTextField = UITextField
public typealias PlatformRepresentable = UIViewRepresentable
public typealias PlatformHostingController = UIHostingController
#endif

/// Screenshot Prevent Wrapper
public struct ScreenshotPreventWrapper<Content: View>: PlatformRepresentable {
    let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public func makeNSView(context: Context) -> PlatformView {
        return self.makeUIView(context: context)
    }

    public func makeUIView(context: Context) -> PlatformView {
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
        // TODO: This seems not to work
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

    public func updateNSView(_ nsView: PlatformView, context: Context) { }
    public func updateUIView(_ uiView: PlatformView, context: Context) { }
}


extension View {
    @ViewBuilder public func preventScreenshot() -> some View {
        ScreenshotPreventWrapper {
            self
                .redacted(reason: .privacy)
                .privacySensitive()
        }
    }
}
#endif
