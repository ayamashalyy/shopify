import UIKit

class ContactUsViewController: UIViewController {

    @IBAction func backToSettings(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Contact Us"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private let emailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Email Us", for: .normal)
        button.setImage(UIImage(systemName: "envelope.fill"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let phoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Call Us", for: .normal)
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let socialMediaStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let teamStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupSubviews()
        setupConstraints()
        configureSocialMedia()
        configureTeamMembers()
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(emailButton)
        view.addSubview(phoneButton)
        view.addSubview(socialMediaStackView)
        view.addSubview(teamStackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        emailButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        socialMediaStackView.translatesAutoresizingMaskIntoConstraints = false
        teamStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            emailButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 20),
            phoneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            socialMediaStackView.topAnchor.constraint(equalTo: phoneButton.bottomAnchor, constant: 20),
            socialMediaStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            socialMediaStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            teamStackView.topAnchor.constraint(equalTo: socialMediaStackView.bottomAnchor, constant: 20),
            teamStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            teamStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
 
    private func configureSocialMedia() {
        let socialMediaIcons = ["facebook.fill", "twitter.fill", "instagram.fill"]
        for iconName in socialMediaIcons {
            let button = UIButton(type: .system)
            button.setImage(UIImage(systemName: iconName), for: .normal)
            button.tintColor = .systemBlue
            button.addTarget(self, action: #selector(socialMediaButtonTapped(_:)), for: .touchUpInside)
            socialMediaStackView.addArrangedSubview(button)
        }
    }
    
    private func configureTeamMembers() {
        let titleLabel = UILabel()
        titleLabel.text = "Our Team"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        teamStackView.addArrangedSubview(titleLabel)
        
        let teamMembers = ["Rawan Elsayed", "Aya Mashaly", "Mayar Saleh", "Somia Amer"]
        for member in teamMembers {
            let label = UILabel()
            label.text = member
            label.font = UIFont.systemFont(ofSize: 16)
            teamStackView.addArrangedSubview(label)
        }
    }


    @objc private func emailButtonTapped() {
        if let emailURL = URL(string: "mailto:example@example.com") {
            UIApplication.shared.open(emailURL)
        }
    }
    
    @objc private func phoneButtonTapped() {
        if let phoneURL = URL(string: "tel://1234567890") {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    @objc private func socialMediaButtonTapped(_ sender: UIButton) {
        // Handle social media button tap
        // You can differentiate between buttons using tags or other means
    }
}
