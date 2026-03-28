//
//  ExportImportTutorial.swift
//  Unwatched
//

import SwiftUI
import UnwatchedShared

struct ExportImportTutorial: View {
    @AppStorage(Const.themeColor) var theme = ThemeColor()
    @Binding var showFileImporter: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text("howToExportTitle")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)

                Link(destination: UrlService.youtubeTakeoutUrl) {
                    Text("googleTakeout")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(theme.contrastColor)
                .padding(15)

                Text("howToExport2")
                    .padding(.bottom, 40)

                Text("howToImportTitle")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)

                Text("howToImport1")

                Button {
                    showFileImporter = true
                } label: {
                    Text("selectFile")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(theme.contrastColor)
                .padding(15)

                Text("howToImport2")
                Spacer()
            }
            .fontWeight(.regular)
            .myTint()
            .padding(.horizontal, 20)
        }
    }
}
