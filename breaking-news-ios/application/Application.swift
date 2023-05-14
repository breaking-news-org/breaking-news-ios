//
//  Application.swift
//  breaking-news-ios
//
//  Created by Roman Nabiullin on 05.05.2023.
//

import SwiftUI
import Dependencies

// MARK: - App

@main struct Application: App {

	// MARK: Body

	var body: some Scene {
		WindowGroup {
			NewsScreen(
				viewModel: NewsScreenViewModel()
			)
			.preferredColorScheme(.light)
		}
	}

}
