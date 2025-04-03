import SwiftUI
import PDFKit
import ShuffleIt

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.backTapped()
                } label: {
                    Image(.left)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(CircularButton())
                
                Spacer()
                
                HStack(spacing: 8) {
                    Button {
                        viewModel.sharePDF()
                    } label: {
                        Image(.shareapp)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(CircularButton())
                    
                    Button {
                        
                    } label: {
                        Image(.cross)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        
                    }
                    .buttonStyle(CircularButton())
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                if !viewModel.imagesForTemplates.isEmpty && !viewModel.isLoading && !viewModel.isResult {
                    CarouselStack(
                        templatesList,
                        initialIndex: viewModel.currentIndex
                    ) { template in
                        if let image = viewModel.imagesForTemplates[template.fileToUseString] {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 457)
                                .cornerRadius(16)
                        } else {
                            VStack {
                                
                            }
                            .frame(height: 457)
                            .cornerRadius(16)
                        }
                    }
                    .carouselScale(0.8)
                    .carouselStyle(.finiteScroll)
                    .onCarousel { new in
                        viewModel.chosenTemplate = templatesList[new.index]
                        viewModel.currentIndex = new.index
                        viewModel.generateCV()
                    }
                    .padding(.top, 10)
                    
                    TemplateDots(pageCount: templatesList.count, currentIndex: $viewModel.currentIndex)
                    
                } else if viewModel.isResult {
                    
                    Spacer(minLength: 20)
                    
                    if let item = viewModel.historyItem, let fileName = item.filePath {
                        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                        let fileURL = documentsURL.appendingPathComponent(fileName)
                        
                        if FileManager.default.fileExists(atPath: fileURL.path) {
                            if let fileData = try? Data(contentsOf: fileURL),
                               let generatedPDF = PDFDocument(data: fileData),
                               let firstPageImage = generatedPDF.imageRepresenation {
                                Image(uiImage: firstPageImage)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(16)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
            
            VStack(spacing: 16) {
                if !viewModel.isResult {
                    Button {
                        viewModel.showProfile()
                    } label: {
                        Text(R.string.localizable.edit())
                            .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(.blackMain)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .overlay {
                                RoundedRectangle(cornerRadius: 32)
                                    .stroke(.cE1FF41, lineWidth: 1)
                            }
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                
                Button {
                    viewModel.prepareAndExportPDF()
                } label: {
                    Text(R.string.localizable.download())
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.blackMain)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.cE1FF41)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .contentShape(Rectangle())
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
        }
        .overlay(content: {
            CustomProgressView(isShown: $viewModel.isLoading)
        })
        .task {
            if !viewModel.isResult {
                viewModel.generateAllCVPreviews()
                viewModel.generateCV()
            }
        }
        .sheet(isPresented: $viewModel.isDocumentPickerPresented) {
            if let fileURL = viewModel.exportFileURL {
                DocumentPicker(fileURL: fileURL)
            }
        }
        .sheet(isPresented: $viewModel.shareSheetIsPresented) {
            if let url = viewModel.temporaryShareURL {
                ActivityView(activityItems: [url])
                    .presentationDetents([.medium, .large])
            }
        }
        
    }
}

#Preview {
    ResultView(viewModel: .init(coordinator: .init(), chosenTemplate: .init(num: 1, templatePreview: .template1, fileToUseString: "template1.pdf"),  isResult: false, historyItem: nil))
}

