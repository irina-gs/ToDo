import UIKit

protocol StatefullViewDelegate: AnyObject {
    func statefullView(_: StatefullView, addChild controller: UIViewController)
    func statefullView(_: StatefullView, didMoveToParent controller: UIViewController)
    func statefullViewReloadData(_: StatefullView)
    func statefullViewDidTapEmptyButton(_: StatefullView)
}

class StatefullView: UIView {
    // MARK: Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        log.debug("StatefullView released 🙌")
    }

    // MARK: Internal

    enum State {
        case data
        case empty(error: Error? = nil)
        case loading
    }

    weak var delegate: StatefullViewDelegate?

    var loaderColor: UIColor? {
        didSet {
            if let loaderColor {
                loader.image = UIImage.Common.loaderLarge.withTintColor(loaderColor)
            } else {
                loader.image = UIImage.Common.loaderLarge
            }
        }
    }

    var state: State = .loading {
        didSet {
            updateState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: Private

    private var emptyVC: EmptyViewController?
    private var emptyView: UIView!

    private lazy var loader: LoadingIndicatorImageView = {
        let loader = LoadingIndicatorImageView(image: UIImage.Common.loaderLarge)
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.heightAnchor.constraint(equalTo: loader.widthAnchor),
            loader.heightAnchor.constraint(equalToConstant: 44),
        ])
        return loader
    }()

    private lazy var loaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = UIColor.Color.white
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        return view
    }()

    private func setup() {
        let storyboard = UIStoryboard(name: "Empty", bundle: nil)
        guard let controller = storyboard.instantiateInitialViewController() else {
            return
        }

        emptyVC = controller as? EmptyViewController
        emptyView = emptyVC?.view
        emptyVC?.view.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true

        delegate?.statefullView(self, addChild: controller)
        addSubview(emptyView)
        delegate?.statefullView(self, didMoveToParent: controller)

        addSubview(loaderView)

        [emptyView, loaderView].forEach { subview in
            NSLayoutConstraint.activate([
                subview.leadingAnchor.constraint(equalTo: leadingAnchor),
                subview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
                subview.trailingAnchor.constraint(equalTo: trailingAnchor),
                subview.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            ])
        }
    }

    private func updateState() {
        switch state {
        case .data:
            emptyView.isHidden = true
            loaderView.isHidden = true
        case let .empty(error):
            bringSubviewToFront(emptyView)
            emptyVC?.state = error.flatMap { .error($0) } ?? .empty
            emptyVC?.action = { [weak self] in
                guard let self else {
                    return
                }
                if error == nil {
                    delegate?.statefullViewDidTapEmptyButton(self)
                } else {
                    delegate?.statefullViewReloadData(self)
                }
            }
            emptyView.isHidden = false
            loaderView.isHidden = true
        case .loading:
            bringSubviewToFront(loaderView)
            emptyView.isHidden = true
            loaderView.isHidden = false
        }
    }
}
