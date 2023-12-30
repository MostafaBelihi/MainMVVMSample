//
//  DependencyInjector.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation
import Swinject
import Reachability

class DependencyInjector: ObservableObject {
	
	static let shared = DependencyInjector();
	var container: Container
	var safeResolver: Resolver
	
	// MARK: - Global Actors
	var settings: Settings!
	var auth: Auth!

	// MARK: - Init
	init() {
		container = Container();
		Container.loggingFunction = nil;
		safeResolver = container.synchronize();
		
		// Register Dependencies
		registerSupport();
		registerDataProviders();
		registerBusiness();
		registerRouters();
		registerGlobalActors();
	}
	
	// MARK: - Resolve dependencies
	// Credit: https://obscuredpixels.com/wrapping-dependencies-in-swiftui
	func resolve<T>(_ type: T.Type) -> T {
		safeResolver.resolve(T.self)!
	}
	
	// MARK: - Supportive Layer
	private func registerSupport() {
		container.register(Connectivity.self) { r in
			let instance = ConnectionManager();
			instance.setup(reachability: try! Reachability());
			
			return instance;
		}.inObjectScope(.container);
		
		container.register(Logging.self) { _ in DebugLogger() }.inObjectScope(.container);	// TODO: Should this be not globale app-wide (not a singleton)
		container.register(PDataCoder.self) { _ in DataCoder() }.inObjectScope(.container);	// TODO: Should this be not globale app-wide (not a singleton)
		container.register(PAuthenticationManager.self) { _ in AuthenticationManager() }.inObjectScope(.container);
		container.register(PNotificationManager.self) { _ in NotificationManager() }.inObjectScope(.container);
		container.register(PSimpleDataPersistence.self) { _ in UserDefaultsManager() }.inObjectScope(.container);
	}
	
	// MARK: - Data
	private func registerDataProviders() {
		container.register(PGeneralNetworkAPIData.self) { _ in GeneralNetworkAPIData() }.inObjectScope(.container);
		container.register(PGeneralDBData.self) { _ in GeneralDBData() }.inObjectScope(.container);
		container.register(PStoresDBData.self) { _ in StoresDBData() }.inObjectScope(.container);
		container.register(PUserAuthNetworkAPIData.self) { _ in UserAuthNetworkAPIData() }.inObjectScope(.container);
		container.register(PMerchantNetworkAPIData.self) { _ in MerchantNetworkAPIData() }.inObjectScope(.container);
		container.register(PProductNetworkAPIData.self) { _ in ProductNetworkAPIData() }.inObjectScope(.container);
	}
	
	// MARK: - Business
	private func registerBusiness() {
		container.register(PHomeBusiness.self) { _ in HomeInteractor() }.inObjectScope(.container);
		container.register(PStoreBusiness.self) { _ in StoreInteractor() }.inObjectScope(.container);
		container.register(PUserAuthBusiness.self) { _ in UserAuthInteractor() }.inObjectScope(.container);
		container.register(PMerchantBusiness.self) { _ in MerchantInteractor() }.inObjectScope(.container);
		container.register(PProductBusiness.self) { _ in ProductInteractor() }.inObjectScope(.container);

		container.register(PDataRequests.self) { _ in MainDataProvider() }.inObjectScope(.container);
	}
	
	// MARK: - Routers
	private func registerRouters() {
//		container.register(PMainRouter.self) { _ in MainRouter(di: self) }
	}
	
	// MARK: - Global Actors
	private func registerGlobalActors() {
		container.register(Settings.self) { [unowned self] _ in self.settings }.inObjectScope(.container);
		container.register(Auth.self) { [unowned self] _ in self.auth }.inObjectScope(.container);
	}

}
