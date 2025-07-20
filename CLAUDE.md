# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DWQuadPreference is an iOS application built with SwiftUI, targeting iOS 26.0+. This appears to be a component of the larger DormWay ecosystem, likely handling quad (dormitory area) preferences for students.

## Development Commands

### Building
```bash
# Build for simulator
xcodebuild -project DWQuadPreference.xcodeproj -scheme DWQuadPreference -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build

# Build for device
xcodebuild -project DWQuadPreference.xcodeproj -scheme DWQuadPreference -destination 'generic/platform=iOS' build

# Clean build
xcodebuild -project DWQuadPreference.xcodeproj -scheme DWQuadPreference clean
```

### Running
- Open `DWQuadPreference.xcodeproj` in Xcode 26.0
- Select target device/simulator
- Press Cmd+R or click Run button

### Testing
```bash
# Run all tests (when test targets are added)
xcodebuild test -project DWQuadPreference.xcodeproj -scheme DWQuadPreference -destination 'platform=iOS Simulator,name=iPhone 15 Pro'
```

## Architecture & Structure

### Current Structure
The project is in initial state with minimal SwiftUI template code:
- `DWQuadPreferenceApp.swift` - App entry point using @main attribute
- `ContentView.swift` - Main UI view
- `Assets.xcassets` - Asset catalog for images and colors

### Key Technical Details
- **Minimum iOS Version**: 26.0 (beta/experimental)
- **UI Framework**: SwiftUI with modern Swift concurrency
- **Development Team ID**: 9796V9ZFQ6
- **Build System**: Xcode's modern build system with file system synchronization

### Integration with DormWay Ecosystem
Based on the parent directory context, this app likely integrates with:
- DormWay's authentication system (AuthService)
- Telemetry and data collection services
- Context-aware intelligence features
- Campus-specific functionality

When implementing features:
1. Follow DormWay's dependency injection patterns (no singletons)
2. Use @Observable and Swift Concurrency
3. Implement proper error handling and privacy-first data collection
4. Consider offline functionality and data queuing

## Important Notes

- This project targets iOS 26.0, which is a future/beta version
- Currently contains only template code - actual implementation pending
- Part of the larger DormWay development effort focused on context-aware campus features
- When adding features, maintain consistency with DormWay's architecture patterns