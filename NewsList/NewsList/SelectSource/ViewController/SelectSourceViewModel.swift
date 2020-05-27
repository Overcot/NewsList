//
//  SelectSourceViewModel.swift
//  NewsList
//
//  Created by Alex Ivashko on 25.05.2020.
//  Copyright © 2020 Alex Ivashko. All rights reserved.
//

import Foundation

protocol SelectSourceViewModelProtocol {
    var title: String { get }
    var updateSourcesList: (() -> Void)? { get set }
    var presentAlert: ((_ title: String, _ message: String) -> Void)? { get set }
    var presentError: ((String, String) -> Void)? { get set }
    
    func numberOfRows() -> Int
    func item(forIndexPath indexPath: IndexPath) -> SourceItem?
    func didSelectRowAt(indexPath: IndexPath)
    
    func addNewsSource()
    func userDidEnter(newLink link: String)
}

final class SelectSourceViewModel {
    // MARK: - Private Variables
    private let sourceService: SourceServiceProtocol
    
    private var sources: [SourceItem] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.updateSourcesList?()
            }
        }
    }
    
    // MARK: - Public Variables
    weak var coordinator: SelectSourceCoordinatorProtocol?
    
    // MARK: - SelectSourceViewModelProtocol
    var updateSourcesList: (() -> Void)?
    var presentAlert: ((String, String) -> Void)?
    var presentError: ((String, String) -> Void)?
    
    // MARK: - Initializers
    init(sourceService: SourceServiceProtocol) {
        self.sourceService = sourceService
        refreshSourcesList()
    }
}

extension SelectSourceViewModel {
    func presentError(withTitle title: String, andMessage message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.presentError?(title, message)
        }
    }
}

// MARK: - Protocol Conformance
// MARK: - SelectSourceViewModelProtocol
extension SelectSourceViewModel: SelectSourceViewModelProtocol {
    var title: String {
        "Добавьте или выберите источник"
    }
    func numberOfRows() -> Int {
        sources.count
    }
    
    func item(forIndexPath indexPath: IndexPath) -> SourceItem? {
        sources[safe: indexPath.row]
    }

    func refreshSourcesList() {
        sourceService.getSourcesList { [weak self] items in
            self?.sources = items
        }
    }
    func didSelectRowAt(indexPath: IndexPath) {
        guard let source = sources[safe: indexPath.row] else {
            return
        }
        coordinator?.userDidSelect(source: source)
    }
    
    func addNewsSource() {
        presentAlert?("Введите адрес ссылки rss", "")
    }
    
    func userDidEnter(newLink link: String) {
        sourceService.createNewSource(link: link) { [weak self] result in
            switch result {
            case .success(let sourceItem):
                self?.sources.append(sourceItem)
                
            case .failure(let error):
                switch error {
                case .alreadyExists:
                    self?.presentError(withTitle: "Эта ссылка уже есть", andMessage: "Попробуйте добавить другую")
                case .errorSaving:
                    self?.presentError(withTitle: "Ошибка при сохранении", andMessage: "Попробуйте еще раз")
                }
            }
        }
    }
}
