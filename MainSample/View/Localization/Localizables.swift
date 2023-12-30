//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation

enum Localizables: String {
	case xxx

	/* Tabs */
	case home
	case cart
	case merchants
	case profile
	
	/* Home */
	case merchTypeHeader
	case merchRecommendedHeader
	case merchTopProductsHeader

	/* General */
	case name
	case firstName
	case lastName
	case phone
	case email
	case street
	case password
	case newPassword
	case confirmPassword
	case login
	case register
	case logout
	
	case merchant
	case product
	case egp
	case egp2
	case egpEn
	case storeType
	case productSeller

	case allMerchants
	case allProducts

	case shippingMethodText
	case shippingMethodMerhcnat
	case metchantCategoryOffers

	case gram
	case kilo
	case gramShort
	case kiloShort
	case quarter
	case half
	case threeQuarter
	case quarterShort
	case halfShort
	case threeQuarterShort

	case min

	case address
	case addresses
	case orderDataShippingAddress

	case orderDataDeliveryTime
	case orderDataDeliveryTimeNow
	case orderDataDeliveryTimeNowDescription
	case orderDataDeliveryTimeLater
	case orderDataDeliveryTimeLaterDescription

	case orderDataDeliveryMethod
	case orderDataDeliveryMethodShipping
	case orderDataDeliveryMethodPickup

	case orderDataNotes

	case quantity
	case orderSummary
	case total
	case total2
	case total3
	case shippingCost
	case serviceFees
	case shippingCostFree
	case shippingCostFixed
	case paymentMethods
	case paymentMethodsCOD
	case paymentMethodsEWallet
	case paymentMethodsEWalletLong
	case paymentMethodsBankCard
	case paymentMethodsBankCardLong
	case couponCode
	case discount

	case selecteStore
	case general
	
	case orders
	case myOrders
	case orderDetailsTitleInProgress
	case orderDetailsTitleFinished
	case orderShippingStatus
	case orderBill
	case orderDate
	case deliveryDate
	
	case privacyPolicy
	case returnPolicy
	case contactUs
	case deleteAccount

	case select

	case wishlist
	case userWallet

	/* Titles */
	case storePickerTitle
	
	case loginUsername
	case loginForgotPassword
	case forgotPasswordTitle
	case forgotPasswordTitle2
	case changePasswordTitle
	case phoneVerificationTitle

	case cartTitle
	case barCodeReaderTitle

	/* Buttons */
	case ok
	case yes
	case no
	case retry
	case add
	case edit
	case save
	case delete
	case done
	case cancel
	case apply
	case details
	case update
	case confirm

	case viewAll
	case latestOrderGiftButton
	
	case addToCart
	case updateCart
	
	case continueAsGuest
	case registerCustomer
	case registerMerchant
	case submitRegister
	case submitVerifyPhone
	case submitPassword
	case resendCode
	case verify
	case proceed
	case shopMore

	case reloadCart
	case proceedShopping
	case deleteAll
	case deleteItem
	case quantityExpired

	case addAddress
	case editAddress
	case placeOrder

	case filterSort
	case filterPick

	case sortPriceLow
	case sortPriceHigh

	/*** Messages ***/
	/* General Messages */
	case headerSlogan
	case storePickerMessage

	case latestOrderGiftMessage
	
	case mustUpdateAppTitle
	case mustUpdateAppMessage
	
	case successTitle
	case failTitle
	case successRegister
	case successChangePassword
	case failedRegister
	case failedLogin
	case unauthFailure
	case failedPhoneVerification
	
	case authRequired
	case authRequired2

	case emptyList

	case logoutConfirmTitle
	case logoutConfirmMessage

	case placeholderSearch
	case placeholderSearchShort
	
	case formPlaceholderName
	case formPlaceholderFirstName
	case formPlaceholderLastName
	case formPlaceholderEmail
	case formPlaceholderPhone
	case formPlaceholderStreet
	case formPlaceholderPassword
	case formPlaceholderConfirmPassword
	case phoneVerificationMessage

	case emptyMerchantsList
	case emptyMerchantsList2

	case emptyHomeCategoriesList
	case emptyProductsList
	case initSearchList
	case emptySearchList
	case unavailableProductPrice
	
	case emptyCartMessage
	case emptyCartMessage2
	
	case exceededMaxQuantityTitle
	case exceededMaxQuantity
	case exceededMaxQuantity0
	case pieces1
	case pieces2
	case pieces3to10
	case pieces11plus
	case activeCartOperationInProgress
	case failedInitCart
	case failedAddToCartUniqueMerchant
	
	case clearCartConfirmTitle
	case clearCartConfirmMessage

	case placeOrderTitle
	case failedInitOrder
	case placeOrderConfirmMessage

	case emptyAddressesMessage
	case emptyAddressesMessage2

	case deleteAddressConfirmTitle
	case deleteAddressConfirmMessage

	case orderFormTitleStep1
	case orderFormTitleStep2
	case orderAddressPlaceholder
	case orderNotAllowedUnavailableItems
	case orderNotAllowedInsufficientCost
	case orderCouponCodePlaceholder
	case orderCouponCodeInactive
	case couponCodeSuccess
	case orderSuccess

	case orderGiftRedeemMessage1
	case orderGiftRedeemMessage2
	case orderGiftRedeemSuccMessage1
	case orderGiftRedeemSuccMessage2

	case deleteAccountTitle
	case deleteAccountConfirm
	
	case emptyOrdersListMessage

	case barCodeCameraFailMessage

	/* App Errors */
	case retryPostfix = "Retry"		// key postfix
	case titlePostfix = "Title"		// key postfix

	/* Form Validation Messages */
	case masterValidationMessage
	case masterValidationMessageTitle
	case fieldValidationMessageGlobal
	case valRequiredField
	case valStringRange
	case valStringMinLen
	case valStringMinLen2
	case valStringMaxLen
	case valPhoneNumberPattern
	case valUsernamePattern
	case valEmailPattern
	case valPasswordPattern
	case valMatchPassword
	case valPINCodeLength

	case valRequiredFieldUsername
	case valRequiredFieldPassword
	case valRequiredFieldName
	case valRequiredFieldEmail
	case valRequiredFieldPhoneNumber
	case valRequiredFieldStreet
	case valRequiredFieldPINCode
	case valRequiredFieldCode
	
	case valNotMatchingPasswords

	case valOrderMinValue
	case valOrderAddress
	case valCouponCodeEmpty
}

extension Localizables {
	var text: String { rawValue.localized }
}
