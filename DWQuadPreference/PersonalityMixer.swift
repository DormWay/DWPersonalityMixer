import SwiftUI

public struct PersonalityTrait {
    public let name: String
    public let color: Color
    public let icon: String
    public let position: Position
    
    public init(name: String, color: Color, icon: String, position: Position) {
        self.name = name
        self.color = color
        self.icon = icon
        self.position = position
    }
    
    public enum Position {
        case top, right, bottom, left
        
        var angle: Double {
            switch self {
            case .top: return -90
            case .right: return 0
            case .bottom: return 90
            case .left: return 180
            }
        }
        
        var unitPoint: UnitPoint {
            switch self {
            case .top: return .top
            case .right: return .trailing
            case .bottom: return .bottom
            case .left: return .leading
            }
        }
    }
}

public struct PersonalityMixer: View {
    let traits: [PersonalityTrait]
    @Binding var mixerPosition: CGPoint
    
    @State private var isDragging = false
    @State private var localPosition: CGPoint? = nil
    @State private var wasInCenter = false
    @State private var hapticFeedback = UIImpactFeedbackGenerator(style: .light)
    
    private let circleSize: CGFloat = 300
    private let knobSize: CGFloat = 40
    private let centerThreshold: CGFloat = 0.15
    private let magneticStrength: CGFloat = 0.3
    private let magneticRadius: CGFloat = 0.25
    
    public init(traits: [PersonalityTrait], mixerPosition: Binding<CGPoint>) {
        self.traits = traits
        self._mixerPosition = mixerPosition
    }
    
    public var body: some View {
        ZStack {
            // Trait labels outside the circle
            ForEach(traits, id: \.name) { trait in
                traitLabel(for: trait)
            }
            
            // Glass container base
            ZStack {
                // Liquid glass background
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: circleSize, height: circleSize)
                    .overlay(
                        Circle()
                            .fill(blendedColor.opacity(0.3))
                    )
                
                // Main liquid fill with glass effect
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                blendedColor.opacity(0.7),
                                blendedColor.opacity(0.5)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: circleSize, height: circleSize)
                    .background(.ultraThinMaterial)
                    .overlay(
                        // Refractive glass distortion
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.clear,
                                        Color.black.opacity(0.1)
                                    ],
                                    center: UnitPoint(x: 0.3, y: 0.3),
                                    startRadius: 0,
                                    endRadius: circleSize * 0.6
                                )
                            )
                            .blendMode(.overlay)
                    )
                    .overlay(
                        // Glass surface reflections
                        GeometryReader { geo in
                            ForEach(0..<3) { i in
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.white.opacity(0.2 - Double(i) * 0.05),
                                                Color.clear
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .center
                                        )
                                    )
                                    .frame(width: 80 - CGFloat(i * 20), height: 80 - CGFloat(i * 20))
                                    .offset(x: -30 + CGFloat(i * 10), y: -30 + CGFloat(i * 10))
                                    .blur(radius: CGFloat(i))
                            }
                        }
                    )
                    .overlay(
                        // Liquid meniscus effect
                        Circle()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2),
                                        Color.clear
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .blur(radius: 1)
                    )
                    .overlay(
                        // Inner glass rim
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.4),
                                        Color.gray.opacity(0.2)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
            }
            .compositingGroup()
            .clipShape(Circle())
            .shadow(color: blendedColor.opacity(0.3), radius: 20, x: 0, y: 10)
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Liquid effect ripples
            Circle()
                .stroke(blendedColor.opacity(0.3), lineWidth: 2)
                .frame(width: circleSize * 0.8, height: circleSize * 0.8)
                .blur(radius: 1)
                .scaleEffect(isDragging ? 0.85 : 0.8)
                .animation(.easeInOut(duration: 0.6), value: isDragging)
            
            // Center reference
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.8),
                            Color.white.opacity(0.3)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 8
                    )
                )
                .frame(width: 16, height: 16)
                .blur(radius: 0.5)
            
            // Selector knob
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white,
                            Color.white.opacity(0.95)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: knobSize, height: knobSize)
                .overlay(
                    Circle()
                        .fill(blendedColor.opacity(0.3))
                        .frame(width: knobSize * 0.7, height: knobSize * 0.7)
                        .blur(radius: 2)
                )
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.8),
                                    Color.gray.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 4)
                .shadow(color: blendedColor.opacity(0.4), radius: 6, x: 0, y: 2)
                .scaleEffect(isDragging ? 1.15 : 1.0)
                .position(
                    x: (circleSize + 120) / 2 + currentPosition.x * (circleSize / 2),
                    y: (circleSize + 120) / 2 + currentPosition.y * (circleSize / 2)
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
        }
        .frame(width: circleSize + 120, height: circleSize + 120) // Extra space for labels
        .gesture(
            DragGesture()
                .onChanged { value in
                    isDragging = true
                    updatePosition(value: value, in: CGSize(width: circleSize + 120, height: circleSize + 120))
                }
                .onEnded { _ in
                    isDragging = false
                }
        )
        .onChange(of: mixerPosition) { newValue in
            if localPosition == nil {
                localPosition = newValue
            }
        }
        .onAppear {
            hapticFeedback.prepare()
        }
    }
    
    private func traitLabel(for trait: PersonalityTrait) -> some View {
        let weight = calculateWeight(for: trait.position)
        let isActive = weight > 0.1
        
        return ZStack {
            // Outer ring for active state
            if isActive {
                Circle()
                    .stroke(trait.color.opacity(weight * 0.6), lineWidth: 2)
                    .frame(width: 36, height: 36)
                    .blur(radius: 2)
                    .scaleEffect(1 + (weight * 0.3))
            }
            
            // Color dot
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            trait.color.opacity(0.9),
                            trait.color
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: 12
                    )
                )
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: trait.color.opacity(0.4), radius: 4, x: 0, y: 2)
                .scaleEffect(0.8 + (weight * 0.4))
            
            // SF Symbol icon
            Image(systemName: trait.icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 1, x: 0, y: 1)
        }
        .position(labelPosition(for: trait.position))
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: weight)
    }
    
    private func labelRotation(for position: PersonalityTrait.Position) -> Angle {
        switch position {
        case .top, .bottom:
            return .zero
        case .right:
            return .degrees(90)
        case .left:
            return .degrees(-90)
        }
    }
    
    private func labelPosition(for position: PersonalityTrait.Position) -> CGPoint {
        let frameSize = circleSize + 120
        let offset: CGFloat = circleSize / 2 + 25
        
        switch position {
        case .top:
            return CGPoint(x: frameSize / 2, y: frameSize / 2 - offset)
        case .right:
            return CGPoint(x: frameSize / 2 + offset, y: frameSize / 2)
        case .bottom:
            return CGPoint(x: frameSize / 2, y: frameSize / 2 + offset)
        case .left:
            return CGPoint(x: frameSize / 2 - offset, y: frameSize / 2)
        }
    }
    
    private func updatePosition(value: DragGesture.Value, in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let location = value.location
        
        // Calculate position relative to center
        var relativeX = (location.x - center.x) / (circleSize / 2)
        var relativeY = (location.y - center.y) / (circleSize / 2)
        
        // Constrain to circle
        var distance = sqrt(relativeX * relativeX + relativeY * relativeY)
        if distance > 1 {
            relativeX /= distance
            relativeY /= distance
            distance = 1
        }
        
        // Apply magnetic pull to center
        if distance < magneticRadius && distance > 0 {
            let pullStrength = (1 - distance / magneticRadius) * magneticStrength
            relativeX *= (1 - pullStrength)
            relativeY *= (1 - pullStrength)
            distance = sqrt(relativeX * relativeX + relativeY * relativeY)
        }
        
        // Check for center crossing for haptic feedback
        let isInCenter = distance < centerThreshold
        if isInCenter != wasInCenter {
            hapticFeedback.impactOccurred()
            wasInCenter = isInCenter
        }
        
        let newPosition = CGPoint(x: relativeX, y: relativeY)
        localPosition = newPosition
        mixerPosition = newPosition
    }
    
    private var currentPosition: CGPoint {
        localPosition ?? mixerPosition
    }
    
    private var blendedColor: Color {
        // Start with white
        var red: Double = 1.0
        var green: Double = 1.0
        var blue: Double = 1.0
        
        // Calculate total influence (distance from center)
        let totalInfluence = sqrt(currentPosition.x * currentPosition.x + currentPosition.y * currentPosition.y)
        
        if totalInfluence > 0 {
            // Mix colors based on weights
            var mixedRed: Double = 0
            var mixedGreen: Double = 0
            var mixedBlue: Double = 0
            var totalWeight: Double = 0
            
            for trait in traits {
                let weight = calculateWeight(for: trait.position)
                if weight > 0 {
                    // Get color components
                    let uiColor = UIColor(trait.color)
                    var r: CGFloat = 0
                    var g: CGFloat = 0
                    var b: CGFloat = 0
                    var a: CGFloat = 0
                    uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
                    
                    mixedRed += Double(r) * weight
                    mixedGreen += Double(g) * weight
                    mixedBlue += Double(b) * weight
                    totalWeight += weight
                }
            }
            
            if totalWeight > 0 {
                mixedRed /= totalWeight
                mixedGreen /= totalWeight
                mixedBlue /= totalWeight
                
                // Blend between white (center) and the mixed color (edges)
                red = 1.0 - (1.0 - mixedRed) * totalInfluence
                green = 1.0 - (1.0 - mixedGreen) * totalInfluence
                blue = 1.0 - (1.0 - mixedBlue) * totalInfluence
            }
        }
        
        return Color(red: red, green: green, blue: blue)
    }
    
    private func calculateWeight(for position: PersonalityTrait.Position) -> Double {
        let pos = currentPosition
        
        // If at center, return equal weights
        let distance = sqrt(pos.x * pos.x + pos.y * pos.y)
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
        let angle = atan2(pos.y, pos.x) * 180 / .pi
        
        // Calculate angular difference
        var angleDiff = abs(angle - traitAngle)
        if angleDiff > 180 {
            angleDiff = 360 - angleDiff
        }
        
        // Calculate raw weight based on angular proximity
        // Use raised cosine for sharper transitions
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
}

struct PersonalityMixer_Previews: PreviewProvider {
    static var previews: some View {
        PersonalityMixerDemo()
    }
}

struct PersonalityMixerDemo: View {
    @State private var mixerPosition: CGPoint = .zero
    
    let traits = [
        PersonalityTrait(name: "Creative", color: .purple, icon: "paintpalette", position: .top),
        PersonalityTrait(name: "Analytical", color: .blue, icon: "function", position: .right),
        PersonalityTrait(name: "Empathetic", color: .pink, icon: "heart", position: .bottom),
        PersonalityTrait(name: "Practical", color: .green, icon: "clock", position: .left)
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Text("AI Personality Mixer")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            PersonalityMixer(traits: traits, mixerPosition: $mixerPosition)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Personality Blend:")
                    .font(.headline)
                
                ForEach(traits, id: \.name) { trait in
                    HStack {
                        Image(systemName: trait.icon)
                            .font(.system(size: 16))
                            .foregroundColor(trait.color)
                            .frame(width: 24)
                        Text(trait.name)
                        Spacer()
                        Text("\(Int(calculateWeight(for: trait.position) * 100))%")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private func calculateWeight(for position: PersonalityTrait.Position) -> Double {
        let traitVector: CGPoint
        switch position {
        case .top: traitVector = CGPoint(x: 0, y: -1)
        case .right: traitVector = CGPoint(x: 1, y: 0)
        case .bottom: traitVector = CGPoint(x: 0, y: 1)
        case .left: traitVector = CGPoint(x: -1, y: 0)
        }
        
        let dotProduct = mixerPosition.x * traitVector.x + mixerPosition.y * traitVector.y
        return max(0, dotProduct)
    }
}
