//
//  ResourceProvidor.swift
//  
//
//  Created by Toshiharu Imaeda on 2023/04/25.
//

import UIKit
import CoreGraphics

public class ResourceProvidor {
    public init() {}

    public func createImage(with url: URL?) async throws -> CGImage? {
        guard let url else { return nil }
        let session = URLSession(configuration: .default)
        let (data, _) = try await session.data(for: URLRequest(url: url))
        return UIImage(data: data)?.cgImage
    }
}
