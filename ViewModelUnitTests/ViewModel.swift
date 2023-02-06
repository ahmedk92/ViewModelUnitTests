//
//  ViewModel.swift
//  ViewModelUnitTests
//
//  Created by Ahmed Khalaf on 27/01/2023.
//

import Foundation
import Combine

class ViewModel {
    @Published
    var email: String?
    
    @Published
    private(set) var message: String?
    
    @Published
    private(set) var didLog: Bool = false
    
    private let asyncRunner: AsyncRunner
    
    init(asyncRunner: AsyncRunner = DefaultAsyncRunner()) {
        self.asyncRunner = asyncRunner
        $email
            .compactMap { $0 }
            .map { "Did receive \($0)" }
            .map { [weak self] message in
                guard let self = self else { return message }
                self.asyncRunner.runAsync {
                    try await self.log(message: message)
                }
                return message
            }
            .assign(to: &$message)
    }
    
    private func log(message: String) async throws {
        try await Task.sleep(nanoseconds: 3 * 1000_000_000)
        print(message)
        didLog = true
    }
}

typealias AsyncBlock = () async throws -> Void
protocol AsyncRunner {
    func runAsync(block: @escaping AsyncBlock)
}

class DefaultAsyncRunner: AsyncRunner {
    func runAsync(block: @escaping AsyncBlock) {
        Task {
            try await block()
        }
    }
}
