//
//  OnboardingPageViewController.swift
//  WeatherApp
//
//  Created by Sandro Gelashvili on 15.11.24.
//

import UIKit
import SnapKit

private enum Constants {
    static let customImageSize: CGFloat = 270
}

final class OnboardingViewController: UIViewController {
    
    private let viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.requiredError)
    }
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: FontConstants.headline2, weight: .bold)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .max
        label.font = .systemFont(ofSize: FontConstants.body1, weight: .regular)
        label.textColor = .neutralBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var pageIndicator: UIPageControl = {
        let pageIndicator = UIPageControl()
        pageIndicator.translatesAutoresizingMaskIntoConstraints = false
        pageIndicator.currentPageIndicatorTintColor = .neutralBlack
        pageIndicator.pageIndicatorTintColor = .grayLight
        pageIndicator.isUserInteractionEnabled = false
        return pageIndicator
    }()
    
    private var onboardingButton: CustomButton = {
        let button = CustomButton(
            title: String.continueButtonTitle
        )
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .neutralWhite
        setUpUI()
        configureButtonAction()
        updateUI()
        addSwipeGestures()
    }
    
    private func setUpUI() {
        addImageView()
        addTitleLabel()
        addDescriptionLabel()
        addPageIndicator()
        addOnboardingButton()
    }
    
    private func addImageView() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Space.xl5)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.75)
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    private func addTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Space.xl5)
            make.centerX.equalTo(view)
        }
    }
    
    private func addDescriptionLabel() {
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Space.m)
            make.centerX.equalTo(view)
        }
    }
    
    private func addPageIndicator() {
        view.addSubview(pageIndicator)
        pageIndicator.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Space.xl5)
            make.centerX.equalTo(view)
        }
    }
    
    private func addOnboardingButton() {
        view.addSubview(onboardingButton)
        onboardingButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Space.m)
            make.trailing.equalToSuperview().offset(-Space.m)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-Space.xl3)
            make.height.equalTo(Size.xl6.height)
        }
    }
    
    private func updateUI() {
        let currentPage = viewModel.getCurrentPage()
        titleLabel.text = currentPage.title
        descriptionLabel.text = currentPage.description
        imageView.image = UIImage(named: currentPage.imageName)
        
        pageIndicator.numberOfPages = viewModel.pages.count
        pageIndicator.currentPage = viewModel.currentPageIndex
        
        onboardingButton.configure(title: viewModel.getButtonTitle())
    }
    
    private func configureButtonAction() {
        onboardingButton.setAction { [weak self] in
            self?.handleButtonAction()
        }
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

