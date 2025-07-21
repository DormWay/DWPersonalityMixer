import SwiftUI
import Charts

public struct PersonalityMixerView: View {
    let traits: [PersonalityTrait]
    let onBlendChange: (([(trait: PersonalityTrait, weight: Double)]) -> Void)?
    
    @State private var mixerPosition: CGPoint = .zero
    @State private var showDetails = false
    
    public init(
        traits: [PersonalityTrait],
        onBlendChange: (([(trait: PersonalityTrait, weight: Double)]) -> Void)? = nil
    ) {
        self.traits = traits
        self.onBlendChange = onBlendChange
    }
    
    public var body: some View {
        ZStack {
            // Main mixer control
            VStack(spacing: 0) {
                PersonalityMixer(traits: traits, mixerPosition: $mixerPosition)
                
                // Toggle button
                Button(action: { 
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) { 
                        showDetails.toggle() 
                    } 
                }) {
                    HStack {
                        Image(systemName: showDetails ? "chevron.up.circle.fill" : "chart.pie.fill")
                    }
                    
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.2),
                                                Color.clear
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.3),
                                                Color.gray.opacity(0.1)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.top, -10)
                .zIndex(2)
            }
            
            // Detail view with liquid glass effect
            ZStack {
                // Glass morphism background
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.1),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        // Glass rim effect
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.gray.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                PersonalityPieChart(traits: traits, weights: traitWeights)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.ultraThinMaterial)
                    )
            }
            .frame(width: 280, height: 280)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
            .shadow(color: Color.white.opacity(0.3), radius: 10, x: -5, y: -5)
            .scaleEffect(showDetails ? 1 : 0.3)
            .opacity(showDetails ? 1 : 0)
            .offset(y: showDetails ? 360 : 0)
            .allowsHitTesting(showDetails)
            .zIndex(showDetails ? 1 : 0)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height < -50 {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                showDetails = false
                            }
                        }
                    }
            )
        }
        .onChange(of: mixerPosition) { _ in
            notifyBlendChange()
        }
        .onAppear {
            notifyBlendChange()
        }
    }
    
    private var traitWeights: [Double] {
        traits.map { calculateWeight(for: $0.position) }
    }
    
    private func calculateWeight(for position: PersonalityTrait.Position) -> Double {
        // If at center, return equal weights
        let distance = sqrt(mixerPosition.x * mixerPosition.x + mixerPosition.y * mixerPosition.y)
        if distance < 0.15 {
            return 0.25
        }
        
        // Get trait angle
        let traitAngle: Double
        switch position {
        case .top: traitAngle = -90
        case .right: traitAngle = 0
        case .bottom: traitAngle = 90
        case .left: traitAngle = 180
        }
        
        // Calculate selector angle
        let angle = atan2(mixerPosition.y, mixerPosition.x) * 180 / .pi
        
        // Calculate angular difference
        var angleDiff = abs(angle - traitAngle)
        if angleDiff > 180 {
            angleDiff = 360 - angleDiff
        }
        
        // Calculate raw weight based on angular proximity
        let angleRad = angleDiff * .pi / 180
        let cosineWeight = (1 + cos(angleRad)) / 2
        let rawWeight = pow(cosineWeight, 2.5) // Sharper falloff
        
        // Calculate all raw weights to normalize
        let allRawWeights = traits.map { trait in
            let tAngle: Double
            switch trait.position {
            case .top: tAngle = -90
            case .right: tAngle = 0
            case .bottom: tAngle = 90
            case .left: tAngle = 180
            }
            var diff = abs(angle - tAngle)
            if diff > 180 {
                diff = 360 - diff
            }
            let rad = diff * .pi / 180
            let cosWeight = (1 + cos(rad)) / 2
            return pow(cosWeight, 2.5) // Sharper falloff
        }
        
        let totalWeight = allRawWeights.reduce(0, +)
        
        // Normalize to ensure sum = 1
        return totalWeight > 0 ? rawWeight / totalWeight : 0.25
    }
    
    private func notifyBlendChange() {
        let blend = traits.enumerated().map { index, trait in
            (trait: trait, weight: traitWeights[index])
        }
        onBlendChange?(blend)
    }
}

// Convenience initializer for common 4-trait personality system
public extension PersonalityMixerView {
    init(onBlendChange: (([(trait: PersonalityTrait, weight: Double)]) -> Void)? = nil) {
        self.init(
            traits: [
                PersonalityTrait(name: "Creative", color: .purple, icon: "paintpalette", position: .top),
                PersonalityTrait(name: "Analytical", color: .blue, icon: "function", position: .right),
                PersonalityTrait(name: "Empathetic", color: .pink, icon: "heart", position: .bottom),
                PersonalityTrait(name: "Practical", color: .green, icon: "clock", position: .left)
            ],
            onBlendChange: onBlendChange
        )
    }
}