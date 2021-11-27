//
//  PDFViewerController.swift
//
//
//  Created by MohammadReza Ansary on 7/19/21.
//
//

import UIKit
import PDFKit
import ExtensionKit

public class PDFViewerController: UIViewController {
    
    private let mainStackView = UIStackView() .. {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.semanticContentAttribute = .forceLeftToRight
    }
    
    private let pdfView = PDFView() .. {
        $0.displayDirection = .vertical
        $0.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        $0.autoScales = true
    }
    
    private let thumbnailView = PDFThumbnailView() .. {
        $0.thumbnailSize = CGSize(width: 100, height: 100)
        $0.layoutMode = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.widthAnchor.constraint(equalToConstant: 120).isActive = true
        $0.backgroundColor = .lightGray
    }
    
    private let sideBarButton = UIButton() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 24).isActive = true
        $0.widthAnchor.constraint(equalToConstant: 24).isActive = true
        let icon = UIImage(named: "sidebar.left", in: .module, compatibleWith: nil)//?.tintColor(.gray)
        $0.setImage(icon, for: .normal)
        $0.tintColor = .darkGray
        $0.addTarget(self, action: #selector(sidebarButtonDidTap), for: .touchUpInside)
    }
    
    private let closeButton = UIButton() .. {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("close", for: .normal)
        
        $0.setTitleColor(.darkGray, for: .normal)
        $0.addTarget(self, action: #selector(closeButtonDidTap), for: .touchUpInside)
    }
    
    
    private var document: PDFDocument!
    
    private var documentTitle: String? {
        document.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String
    }
    
    private var shouldUpdatePDFScrollPosition = true
    
    public init(PDF: PDFDocument) {
        super.init(nibName: nil, bundle: nil)
        document = PDF
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = .white
        
        navigationController?.navigationBar.semanticContentAttribute = .forceLeftToRight
        navigationItem.title = documentTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sideBarButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupViewContents()
        thumbnailView.pdfView = pdfView
        pdfView.document = document
    }
    
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if shouldUpdatePDFScrollPosition {
            fixPDFViewScrollPosition()
        }
    }
    
    // This code is required to fix PDFView Scroll Position when NOT using pdfView.usePageViewController(true)
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldUpdatePDFScrollPosition = false
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        pdfView.autoScales = true // This call is required to fix PDF document scale, seems to be bug inside PDFKit
    }
    
    
    private func setupViewContents() {
        
        // ** PDF and PDF Thumbnail View
        mainStackView.addArrangedSubview(thumbnailView)
        mainStackView.addArrangedSubview(pdfView)
        
        // ** Main Stack View
        view.addSubview(mainStackView)
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    private func fixPDFViewScrollPosition() {
        if let page = pdfView.document?.page(at: 0) {
            pdfView.go(to: PDFDestination(page: page, at: CGPoint(x: 0, y: page.bounds(for: pdfView.displayBox).size.height)))
        }
    }
    
    @objc private func sidebarButtonDidTap() {
        UIView.animate(withDuration: 0.2) {
            self.thumbnailView.isHidden = !self.thumbnailView.isHidden
        }
    }
    
    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
}
