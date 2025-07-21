import SwiftUI
import Charts

public struct PersonalityPieChart: View {
    public let traits: [PersonalityTrait]
    public let weights: [Double]
    
    public init(traits: [PersonalityTrait], weights: [Double]) {
        self.traits = traits
        self.weights = weights
    }
    
    private var chartData: [(trait: PersonalityTrait, value: Double)] {
        let total = weights.reduce(0, +)
        guard total > 0 else {
            return traits.enumerated().map { (traits[$0.offset], 0.25) }
        }
        
        // Include all traits, even those with very small weights
        return traits.enumerated().map { index, trait in
            let weight = weights[index]
            // Ensure minimum visibility by giving at least 2% weight to traits with 0
            return (trait, weight > 0.02 ? weight : 0.02)
        }
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            // Pie Chart
            ZStack {
                Chart(chartData, id: \.trait.name) { item in
                    SectorMark(
                        angle: .value("Weight", item.value),
                        innerRadius: .ratio(0.4),
                        angularInset: 2
                    )
                    .foregroundStyle(item.trait.color)
                    .opacity(0.9)
                }
                .frame(height: 160)
                
                // Center text
                VStack(spacing: 4) {
                    Text("BLEND")
                        .font(.caption.weight(.bold).rounded())
                        .foregroundColor(.secondary)
                    
                    if let dominant = chartData.max(by: { $0.value < $1.value }) {
                        Image(systemName: dominant.trait.icon)
                            .font(.title2.weight(.medium))
                            .foregroundColor(dominant.trait.color)
                    }
                }
            }
            
            // Legend with percentages
            VStack(alignment: .leading, spacing: 8) {
                ForEach(chartData, id: \.trait.name) { item in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(item.trait.color)
                            .frame(width: 12, height: 12)
                        
                        Image(systemName: item.trait.icon)
                            .font(.footnote)
                            .foregroundColor(item.trait.color)
                            .frame(width: 20)
                        
                        Text(item.trait.name)
                            .font(.footnote.weight(.medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(Int(weights[traits.firstIndex(where: { $0.name == item.trait.name }) ?? 0] * 100))%")
                            .font(.footnote.weight(.semibold).rounded())
                            .foregroundColor(item.trait.color)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }
}
