//
//  ViewController.swift
//  VisionOCRSample
//
//  Created by Toshiharu Imaeda on 2023/04/25.
//

import UIKit
import MainModule

class ViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicator2: UIActivityIndicatorView!

    private let recognizer = Recognizer()
    private let resourceProvidor = ResourceProvidor()

    private let defaultUrlString = "https://mixltd.jp/cms/wp-content/uploads/IMG_6622-768x509.png"

    private enum AIStatus {
        case show
        case dismiss
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        indicator(status: .dismiss)
        indicator2(status: .dismiss)
        initialFetch()
    }

    private func initialFetch() {
        let urlString = defaultUrlString
        searchBar.text = urlString
        fetchImageAndRecognize(urlString: urlString)
    }

    private func indicator(status: AIStatus) {
        switch status {
        case .show:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()

        case .dismiss:
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        }
    }

    private func indicator2(status: AIStatus) {
        switch status {
        case .show:
            activityIndicator2.isHidden = false
            activityIndicator2.startAnimating()

        case .dismiss:
            activityIndicator2.isHidden = true
            activityIndicator2.stopAnimating()
        }
    }

    private func fetchImageAndRecognize(urlString: String?) {
        guard let urlString else {
            indicator(status: .dismiss)
            return
        }
        indicator(status: .show)

        Task {
            // Fetch image
            guard let image = try? await resourceProvidor.createImage(with: .init(string: urlString)) else {
                indicator(status: .dismiss)
                imageView.image = nil
                resultLabel.text = nil
                return
            }
            imageView.image = image
            guard let cgImage = image.cgImage else {
                indicator(status: .dismiss)
                resultLabel.text = nil
                return
            }
            indicator(status: .dismiss)

            // Recognize texts from image
            indicator2(status: .show)
            let texts: [String] = (try? await recognizer.recognize(cgImage: cgImage)) ?? []
            resultLabel.text = texts.joined(separator: "\n")
            indicator2(status: .dismiss)
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        fetchImageAndRecognize(urlString: searchBar.text)
    }
}

