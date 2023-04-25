//
//  Recognizer.swift
//  VisionOCRSample
//
//  Created by Toshiharu Imaeda on 2023/04/25.
//

import Foundation
import Vision

public class Recognizer {
    public init() {}

    public func recognize(cgImage: CGImage) async throws -> [String] {
        return try await withCheckedThrowingContinuation({ continuation in
            var texts: [String] = []
            let request = VNRecognizeTextRequest { request, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: texts)
                    return
                }
                print("-------------------")
                for observation in observations {
                    let candidates = observation.topCandidates(5)
                    for candidate in candidates {
                        print(candidate.string)
                    }
                    if let text = candidates.first?.string {
                        texts.append(text)
                    }
                }
                continuation.resume(returning: texts)
            }
            request.recognitionLanguages = ["ja_JP"]
            let handler = VNImageRequestHandler(cgImage: cgImage)
            try? handler.perform([request])
        })
    }
}
