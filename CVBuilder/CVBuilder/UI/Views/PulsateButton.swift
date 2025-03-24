
import SwiftUI

struct PulsateButton: View {
    let totalBlinks = 2
    @State private var isPulse = false
    @State private var bipCount = 0
    @State private var timer: Timer? = nil
    
    let text: String
    let buttonAction: () -> Void
    
    var body: some View {
        Button(action: buttonAction) {
            ZStack {
                Color.cE1FF41
                
                Text(text)
                    .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                    .padding(.vertical, 20)
                    .foregroundStyle(.blackMain)
            }
            .frame(height: Constants.screenHeight < Constants.smallScreenHeight ? 48 : 60)
            .clipShape(RoundedRectangle(cornerRadius: 120))
            .scaleEffect(isPulse ? 0.95 : 1)
            .animation(Animation.easeInOut(duration: 0.45), value: isPulse)
        }
        .onReceive(AppRemoteConfigService.shared.$config, perform: { newValue in
            if newValue.isNavButtonAnimated && timer == nil {
                startBlinkingCycle()
            } else if !newValue.isNavButtonAnimated {
                stopTimer()
            }
        })
        .onDisappear {
            stopTimer()
        }
    }
}



extension PulsateButton {
    private func startBlinkingCycle() {
        isPulse = false
        bipCount = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.45, repeats: true) { _ in
            if self.bipCount < totalBlinks * 2 {
                withAnimation {
                    self.isPulse.toggle()
                }
                self.bipCount += 1
            } else {
                self.stopTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.startBlinkingCycle()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
