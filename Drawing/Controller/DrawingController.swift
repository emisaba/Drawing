import UIKit
import PencilKit

class DrawingController: UIViewController {
    
    // MARK: - Properties
    
    private let selectedImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0.4
        return iv
    }()
    
    private lazy var showImagePickerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemYellow
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        return button
    }()
    
    private lazy var canvasView = PKCanvasView(frame: view.frame)
    private let toolPicker = PKToolPicker()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func showImagePicker() {
        
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.allowsEditing = true
        cameraPicker.sourceType = .camera
        cameraPicker.modalPresentationStyle = .fullScreen
        present(cameraPicker, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(selectedImageView)
        selectedImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 50)
        
        setupDrawing()
        
        view.addSubview(showImagePickerButton)
        showImagePickerButton.frame = CGRect(x: view.frame.width - 70,
                              y: view.safeAreaInsets.top + 10,
                              width: 50, height: 50)
    }
    
    func setupDrawing() {
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.becomeFirstResponder()
        view.addSubview(canvasView)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension DrawingController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        setupDrawing()
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        selectedImageView.image = image
        
        setupDrawing()
        dismiss(animated: true)
    }
}
