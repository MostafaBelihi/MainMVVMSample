//
//  LoginView.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 27/02/2023.
//

import SwiftUI

struct LoginView: View {
	
	// MARK: - Dependencies
	@StateObject private var presenter = LoginPresenter()
	@StateObject private var alertManager = AlertManager()
	@EnvironmentObject private var auth: Auth

	// MARK: - Validation
	@StateObject var usernameValidator = Validator(forType: String.self)
	@StateObject var passwordValidator = Validator(forType: String.self)
	
	// MARK: - More Variables
	
	// MARK: - View Specs
	@Environment(\.dismiss) var dismiss
	@Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
	
	// MARK: - Body
	var body: some View {
		GeometryReader { geo in
			ScrollView {
				VStack {
					VStack(spacing: 45) {
						Image("MainSample-logo-login")
						
						// Form
						VStack(spacing: 25) {
							// Username
							VStack(alignment: .leading) {
								Text(Localizables.loginUsername.text)
									.formFieldTitleStyle()
								TextField("", text: $presenter.username)
									.textContentType(.emailAddress)
									.textInputAutocapitalization(.never)
									.disableAutocorrection(true)
									.textFieldStyle(.roundedBorder)
									.formTextFieldStyle()
								// Validation
								if (!usernameValidator.isValid) {
									ForEach(usernameValidator.validationMessages ?? [], id: \.self) { element in
										Text(element)
											.formValidationMessageStyle()
									}
								}
							}
							
							// Password
							VStack(alignment: .leading) {
								Text(Localizables.password.text)
									.formFieldTitleStyle()
								SecureField("", text: $presenter.password)
									.textContentType(.password)
									.textInputAutocapitalization(.never)
									.disableAutocorrection(true)
									.textFieldStyle(.roundedBorder)
									.formTextFieldStyle()
								// Validation
								if (!passwordValidator.isValid) {
									ForEach(passwordValidator.validationMessages ?? [], id: \.self) { element in
										Text(element)
											.formValidationMessageStyle()
									}
								}
								
								// Forgot Password
								HStack {
									Spacer()
									NavigationLink {
										// SampleSimplification:: 
//										ForgotPasswordView()
									} label: {
										Text(Localizables.loginForgotPassword.text)
											.grayButtonStyle()
									}
								}
								.frame(maxWidth: .infinity)
							}
						}
						
						// Submit
						VStack(spacing: 15) {
							TintedButton(title: Localizables.login.text,
										 height: ViewSpecs.mainButtonHeight,
										 cornerRadius: ViewSpecs.globalCornerRadius,
										 spinningIndicator: $presenter.isSubmitting) {
								onSubmit();
							}
							
							NavigationLink {
								// SampleSimplification:: 
//								RegisterIntroView()
							} label: {
								Text(Localizables.register.text)
									.frame(maxWidth: .infinity)
									.frame(height: ViewSpecs.mainButtonHeight)
									.secondaryButtonStyle(cornerRadius: ViewSpecs.globalCornerRadius)
							}
						}
						
						// Continue as Guest
						Button(action: {
							rootPresentationMode.wrappedValue.dismiss()
						}, label: {
							Text(Localizables.continueAsGuest.text)
								.underline()
								.plainButtonStyle()
						})
					}
					.frame(width: geo.size.width * 0.8)
					.padding(.bottom, 50)
				}
				.frame(width: geo.size.width)
			}
		}
		.onTapGesture {
			hideKeyboard()
		}
		
		// MARK: - NavBar
		.navigationBarBackButtonHidden(true)
		.tintedNavBarStyle()
		.toolbar(content: {
			ToolbarItem(placement: .navigationBarLeading) {
				Button {
					dismiss()
				} label: {
					Image(systemName: "control").tint(.black)
						.rotationEffect(Angle(degrees: -90))
				}
				.foregroundColor(.white)
			}
		})
		
		// MARK: - Alerts
		.advancedAlert(alertManager: alertManager)
		
		// MARK: - Events
		.onViewLoad {
			onViewLoad();
		}
		.onChange(of: presenter.triggeredAlert) { _ in
			onTriggerAlert()
		}
	}
	
	// MARK: - Events Handlers
	private func onViewLoad() {
		setupValidation();
	}
	
	private func onSubmit() {
		hideKeyboard()
		
		// Validate
		let isFormValid = validateForm();
		
		guard isFormValid else {
			return;
		}

		// Submit
		presenter.submit {
			auth.refreshAuthData();
			rootPresentationMode.wrappedValue.dismiss();
		}
	}
	
	private func onTriggerAlert() {
		alertManager.showError(title: presenter.alertInfo.title,
							   message: presenter.alertInfo.message,
							   actionButtonText: presenter.alertInfo.actionButtonText,
							   handler: presenter.alertInfo.actionButtonHandler);
	}
	
}

// MARK: - Validation
extension LoginView {
	private func setupValidation() {
		usernameValidator.validations = [
			.required(errorMessage: Localizables.valRequiredFieldUsername.text)
		];
		passwordValidator.validations = [
			.required(errorMessage: Localizables.valRequiredFieldPassword.text)
		];
	}
	
	private func validateForm() -> Bool {
		usernameValidator.validate(presenter.username);
		passwordValidator.validate(presenter.password);
		return usernameValidator.isValid && passwordValidator.isValid;
	}
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
		LoginView()
    }
}
