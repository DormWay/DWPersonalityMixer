# Changelog

All notable changes to PersonalityMixer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-01-20

### 🐛 Fixed

- **Crash Prevention** - Fixed force unwrap in PersonalityPieChart that could cause crashes with duplicate trait names (#1)
- **External Updates** - PersonalityMixer now properly responds to external position updates, enabling programmatic control (#2)
- **Dynamic Type Support** - Replaced all hardcoded font sizes with semantic styles for better accessibility (#3)
- **Proper Logging** - Replaced console print statements with os.Logger for production-ready logging (#4)

### 🔧 Improved

- Better two-way binding support for mixer position
- Enhanced accessibility with Dynamic Type
- Professional logging practices in examples

## [1.0.0] - 2025-01-20

### 🎉 Initial Release

PersonalityMixer is a beautiful SwiftUI component for mixing personality traits or any quaternary attributes. Perfect for AI personality configuration, game character creation, or any interface requiring smooth blending between four cardinal options.

### ✨ Features

#### Core Functionality
- **Intuitive Mixer Control** - Drag to blend between four traits positioned at cardinal points
- **Real-time Visual Feedback** - Live color blending shows the current mix
- **Precise Percentages** - Always sums to 100% for accurate trait distribution
- **Slide-out Detail View** - Beautiful pie chart visualization with swipe-to-dismiss

#### Visual Design
- **Liquid Glass Aesthetics** - iOS 26-style glass morphism with ultra-thin materials
- **Dynamic Color Blending** - Smooth transitions between trait colors
- **Refractive Glass Effects** - Multiple layers create depth and realism
- **Mesh Gradient Backgrounds** - Modern, vibrant backdrop for the component

#### Interaction Design
- **Haptic Feedback** - Subtle impact when crossing the center point
- **Magnetic Center** - Gentle pull effect makes it easy to achieve balanced 25/25/25/25
- **Spring Animations** - Natural, responsive movements throughout
- **Gesture Support** - Swipe up to dismiss detail view

#### Customization
- **Flexible Traits** - Use any colors, names, and SF Symbol icons
- **Callback System** - Get notified of blend changes in real-time
- **Default Configuration** - Works out-of-the-box with Creative/Analytical/Empathetic/Practical

### 📦 Distribution
- Swift Package Manager support
- Full documentation with examples
- MIT License for maximum flexibility

### 🛠 Technical Details
- Requires iOS 26.0+ for MeshGradient and advanced effects
- Built with SwiftUI and Swift Charts
- No external dependencies
- Fully public API for easy integration

### 📚 Documentation
- Comprehensive README with installation and usage
- Four detailed example implementations
- Contributing guidelines
- API documentation

### 🙏 Acknowledgments
Created by DormWay LLC with inspiration from color theory and professional mixing interfaces.