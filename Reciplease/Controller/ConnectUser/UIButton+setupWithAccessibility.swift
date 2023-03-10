//
//  UIButton+setupWithAccessibility.swift
//  Reciplease
//
//  Created by Greg Deveaux on 01/01/2023.
//

import UIKit

extension UIButton {
        // setup which use the configuration button
    static func setupButton(style: UIButton.Configuration,
                            title: String,
                            colorText: UIColor,
                            colorBackground: UIColor,
                            image: String,
                            accessibilityMessage: String,
                            activity: Bool?) -> UIButton {

        let button = UIButton()

            /// modify appearance of the button
        var configuration = style
        configuration.baseBackgroundColor = colorBackground
        configuration.baseForegroundColor = colorText
        configuration.cornerStyle = .dynamic

            /// add an image in the button with placement
        configuration.image = UIImage(systemName: image)
        configuration.imagePadding = 10
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        configuration.imagePlacement = .trailing
        configuration.title = title

            /// modify the font of the button
        let transformer = UIConfigurationTextAttributesTransformer { listTransform in
            var fontTransform = listTransform
            fontTransform.font = UIFont.boldSystemFont(ofSize: 20)
            return fontTransform
        }
        configuration.titleTextAttributesTransformer = transformer

            /// accessibility
        button.isAccessibilityElement = true
        button.accessibilityTraits = .button
        button.accessibilityHint = accessibilityMessage

            /// indicate activity indicator configuration after tapped
        button.configurationUpdateHandler = { button in
            var configuration = button.configuration
            guard let activity = activity else { return }
            configuration?.showsActivityIndicator = activity
            configuration?.imagePlacement = activity ? .leading : .trailing
            button.configuration = configuration
        }

        button.configuration = configuration
        return button
    }
}
