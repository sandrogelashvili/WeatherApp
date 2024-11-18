//
//  OnboardingPageViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 15.11.24.
//

import UIKit

private enum Constants {
    static let titleFontSize: CGFloat = 28
    static let descriptionFontSize: CGFloat = 16
    static let costumeImageSize: CGFloat = 270
}

final class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: Constants.titleFontSize, weight: .bold)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .max
        label.font = .systemFont(ofSize: Constants.descriptionFontSize, weight: .regular)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var pageIndicator: UIPageControl = {
        let pageIndicator = UIPageControl()
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicator.currentPageIndicatorTintColor = .neutralBlack
        pageIndicator.pageIndicatorTintColor = .grayLight
        pageIndicator.isUserInteractionEnabled = false
        return pageIndicator
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonAction), for: .touchUpInside)
        button.backgroundColor = .neutralBlack
        button.tintColor = .neutralWhite
        button.layer.cornerRadius = CornerRadius.l
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutralWhite
        setUpUI()
        updateUI()
        addSwipeGestures()
    }
    
    private func setUpUI() {
        addImageView()
        addTitleLabel()
        addDescriptionLabel()
        addPageIndicator()
        addActionButton()
    }
    
    private func addImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.xl5),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.costumeImageSize),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    private func addTitleLabel() {
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Space.xl5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.m),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.m)
        ])
    }
    
    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Space.m),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.m),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.m),
        ])
    }
    
    private func addPageIndicator() {
        view.addSubview(pageIndicator)
        NSLayoutConstraint.activate([
            pageIndicator.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Space.xl5),
            pageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func addActionButton() {
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.m),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Space.m),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Space.xl3),
            actionButton.heightAnchor.constraint(equalToConstant: Size.xl6.height)
        ])
    }
    
    private func updateUI() {
        let currentPage = viewModel.getCurrentPage()
        titleLabel.text = currentPage.title
        descriptionLabel.text = currentPage.description
        imageView.image = UIImage(named: currentPage.imageName)
        
        pageIndicator.numberOfPages = viewModel.pages.count
        pageIndicator.currentPage = viewModel.currentPageIndex
        
        actionButton.setTitle(viewModel.getButtonTitle(), for: .normal)
    }
    
    @objc private func handleButtonAction() {
        if viewModel.currentPageIndex == viewModel.pages.count - 1 {
            let loginViewController = LoginViewController()
            navigationController?.pushViewController(loginViewController, animated: true)
        } else {
            viewModel.getNextPage()
            updateUI()
        }
    }
    
    private func addSwipeGestures() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            if viewModel.currentPageIndex < viewModel.pages.count - 1 {
                viewModel.getNextPage()
                updateUI()
            }
        } else if gesture.direction == .right {
            if viewModel.currentPageIndex > .zero {
                viewModel.getPreviousPage()
                updateUI()
            }
        }
    }
}

