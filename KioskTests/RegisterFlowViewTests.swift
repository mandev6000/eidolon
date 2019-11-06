import Quick
import Nimble
@testable
import Kiosk
import Nimble_Snapshots

private let frame = CGRect(x: 0, y: 0, width: 180, height: 320)

class RegisterFlowViewConfiguration: QuickConfiguration {
    override class func configure(_ configuration: Configuration) {
        sharedExamples("a register flow view") { (sharedExampleContext: @escaping SharedExampleContext) in
            var subject: RegisterFlowView!

            beforeEach {
                subject = sharedExampleContext()["subject"] as! RegisterFlowView
            }

            it("looks right by default") {
                let bidDetails  = BidDetails(saleArtwork: nil, paddleNumber: nil, bidderPIN: nil, bidAmountCents: nil, auctionID: testAuctionID)
                bidDetails.newUser = NewUser()

                subject.details = bidDetails

                subject.snapshotView(afterScreenUpdates: true)
                expect(subject).to( haveValidSnapshot() )
            }

            it("handles partial data") {
                let bidDetails  = BidDetails(saleArtwork: nil, paddleNumber: nil, bidderPIN: nil, bidAmountCents: nil, auctionID: testAuctionID)
                bidDetails.newUser = NewUser()

                bidDetails.newUser.phoneNumber.value = "132131231"
                bidDetails.newUser.email.value = "xxx@yyy.com"

                subject.details = bidDetails

                subject.snapshotView(afterScreenUpdates: true)
                expect(subject).to( haveValidSnapshot() )
            }

            it("handles highlighted index") {
                let bidDetails  = BidDetails(saleArtwork: nil, paddleNumber: nil, bidderPIN: nil, bidAmountCents: nil, auctionID: testAuctionID)
                bidDetails.newUser = NewUser()

                bidDetails.newUser.phoneNumber.value = "132131231"
                bidDetails.newUser.email.value = "xxx@yyy.com"

                subject.highlightedIndex.value = RegistrationIndex.emailVC
                subject.details = bidDetails

                subject.snapshotView(afterScreenUpdates: true)
                expect(subject).to( haveValidSnapshot() )
            }


            it("handles full data") {
                let bidDetails  = BidDetails(saleArtwork: nil, paddleNumber: nil, bidderPIN: nil, bidAmountCents: nil, auctionID: testAuctionID)
                bidDetails.newUser = NewUser()

                bidDetails.newUser.phoneNumber.value = "132131231"
                bidDetails.newUser.creditCardToken.value = "...2323"
                bidDetails.newUser.email.value = "xxx@yyy.com"
                bidDetails.newUser.zipCode.value = "90210"
                bidDetails.newUser.name.value = "Fname Lname"
                subject.details = bidDetails

                subject.snapshotView(afterScreenUpdates: true)
                expect(subject).to( haveValidSnapshot() )
            }
        }
    }
}

class RegisterFlowViewTests: QuickSpec {
    override func spec() {
        var appSetup: AppSetup!
        var subject: RegisterFlowView!

        beforeEach {
            appSetup = AppSetup()
            subject = RegisterFlowView(frame: frame)
            subject.sale = makeSale()
            subject.constrainWidth("180")
            subject.constrainHeight("320")
            subject.appSetup = appSetup
            subject.backgroundColor = .white
        }

        describe("on a sale that has credit card requirements") {
            itBehavesLike("a register flow view") { () -> [String: Any] in
                return ["subject": subject]
            }
        }

        describe("on a sale that bypasses credit card requirements") {
            itBehavesLike("a register flow view") { () -> [String: Any] in
                subject.sale = makeSale(bypassCreditCardRequirement: true)
                return ["subject": subject]
            }
        }
    }
}
