import UIKit
import CocoaLumberjack
import WordPressShared
import WordPressUI

class JetpackRestoreStatusViewController: BaseRestoreStatusViewController {

    // MARK: - Properties

    private lazy var coordinator: JetpackRestoreStatusCoordinator = {
        return JetpackRestoreStatusCoordinator(site: self.site, view: self)
    }()


    // MARK: - Initialization

    override init(site: JetpackSiteRef, activity: Activity) {
        let restoreStatusConfiguration = JetpackRestoreStatusConfiguration(
            title: NSLocalizedString("Restore", comment: "Title for Jetpack Restore Status screen"),
            iconImage: .gridicon(.history),
            messageTitle: NSLocalizedString("Currently restoring site", comment: "Title for the Jetpack Restore Status message."),
            messageDescription: NSLocalizedString("We're restoring your site back to %1$@.", comment: "Description for the Jetpack Restore Status message. %1$@ is a placeholder for the selected date."),
            hint: NSLocalizedString("No need to wait around. We'll notify you when your site has been fully restored.", comment: "A hint to users about restoring their site."),
            primaryButtonTitle: NSLocalizedString("OK, notify me!", comment: "Title for the button that will dismiss this view."),
            placeholderProgressTitle: NSLocalizedString("Initializing the restore process", comment: "Placeholder for the restore progress title."),
            progressDescription: NSLocalizedString("Currently restoring: %1$@", comment: "Description of the current entry being restored. %1$@ is a placeholder for the specific entry being restored.")
        )
        super.init(site: site, activity: activity, configuration: restoreStatusConfiguration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator.viewWillDisappear()
    }
}

extension JetpackRestoreStatusViewController: JetpackRestoreStatusView {

    func render(_ rewindStatus: RewindStatus) {
        guard let progress = rewindStatus.restore?.progress else {
            return
        }

        var progressDescription: String?
        if let progressDescriptionFormat = configuration.progressDescription,
           let currentEntry = rewindStatus.restore?.currentEntry {
            progressDescription = String(format: progressDescriptionFormat, currentEntry)
        }

        statusView.update(progress: progress,
                          progressTitle: rewindStatus.restore?.message,
                          progressDescription: progressDescription)
    }

    func showRestoreFailed() {
        // Go to complete VC and show error message
        // let errorTitle = NSLocalizedString("Unable to restore your site, please try again later or contact support.", comment: "Text displayed when a site restore fails.")
    }

    func showRestoreComplete() {
        let completeVC = JetpackRestoreCompleteViewController(site: site, activity: activity)
        self.navigationController?.pushViewController(completeVC, animated: true)
    }
}
