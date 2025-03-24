import SwiftUI

struct PageDots: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount + 1, id: \.self) { index in
                if currentIndex == index {
                    Circle()
                        .fill(.cE1FF41)
                        .frame(width: 8, height: 8)
                } else {
                    Circle()
                        .fill(.c686868.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .animation(.easeInOut, value: currentIndex)
    }
}


import SwiftUI

struct TemplateDots: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                if currentIndex == index {
                    Circle()
                        .fill(.white)
                        .frame(width: 8, height: 8)
                } else {
                    Circle()
                        .fill(.c686868.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 6)
        .animation(.easeInOut, value: currentIndex)
    }
}
