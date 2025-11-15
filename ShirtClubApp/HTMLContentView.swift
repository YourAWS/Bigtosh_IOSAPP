import SwiftUI
import WebKit

struct HTMLContentView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let styledHTML = createStyledHTML(content: htmlContent)
        uiView.loadHTMLString(styledHTML, baseURL: nil)
    }
    
    private func createStyledHTML(content: String) -> String {
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <style>
                body {
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    padding: 20px;
                    line-height: 1.6;
                    color: #333;
                    background-color: #ffffff;
                    margin: 0;
                }
                h4 {
                    color: #2c3e50;
                    margin-bottom: 20px;
                    font-size: 1.3em;
                }
                p {
                    margin-bottom: 15px;
                    font-size: 16px;
                }
                strong {
                    color: #2c3e50;
                    font-weight: 600;
                }
                ul {
                    padding-left: 20px;
                    margin-bottom: 15px;
                }
                li {
                    margin-bottom: 8px;
                    font-size: 16px;
                }
                @media (prefers-color-scheme: dark) {
                    body {
                        background-color: #1a1a1a;
                        color: #e0e0e0;
                    }
                    h4, strong {
                        color: #4a9eff;
                    }
                }
            </style>
        </head>
        <body>
            \(content)
        </body>
        </html>
        """
    }
}

struct HTMLDetailView: View {
    let htmlContent: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HTMLContentView(htmlContent: htmlContent)
        }
        .navigationTitle("Shirt Message")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(Color("BigToshBlue"))
            }
        }
    }
}
