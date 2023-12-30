//
//  MainDataProvider.swift
//  MainSample
//
//  Created by Mostafa AlBelliehy on 26/02/2023.
//

import Foundation

class MainDataProvider: PDataRequests {
	
	// MARK: - Dependencies
	@Inject private var generalAPIData: PGeneralNetworkAPIData
	@Inject private var generalDBData: PGeneralDBData
	@Inject private var storesDBData: PStoresDBData
	@Inject private var userAuthAPIData: PUserAuthNetworkAPIData
	@Inject private var merchantAPIData: PMerchantNetworkAPIData
	@Inject private var productAPIData: PProductNetworkAPIData

	// MARK: - Data
	
	
	// MARK: - General
	func getAppGlobalData(userID: String?) async throws -> AppGlobalData {
		do {
			let data = try await generalAPIData.getHomeData(userID: userID)

			let adapterOut = Adapter(typeAdapter: APIHomeDataToAppGlobalDataAdapter());
			let item = adapterOut.convert(from: data);
			return item;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}

	func getHomeBanners() async throws -> [Banner] {
		do {
			let data = try await generalAPIData.getBanners();

			let adapterOut = Adapter(typeAdapter: APIBannerToBannerAdapter());
			let items = adapterOut.convert(from: data);
			return items;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}

	func saveAppSettings(items: AppSettings) {
		generalDBData.saveAppSettings(items: items);
	}
	
	func loadAppSettings() -> AppSettings? {
		return generalDBData.loadAppSettings();
	}
	
	// MARK: - Stores
	func fetchStores() async throws -> [Store] {
		do {
			let data = try await generalAPIData.getStores();
			
			let adapterOut = Adapter(typeAdapter: APIStoreToStoreAdapter());
			let item = adapterOut.convert(from: data);
			return item;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}
	
	func saveActiveStore(_ item: Store) {
		let adapterIn = Adapter(typeAdapter: StoreToAPIStoreAdapter());
		let model = adapterIn.convert(from: item);
		storesDBData.saveActiveStore(item: model);
	}
	
	func loadActiveStore() -> Store {
		var data = storesDBData.loadActiveStore();
		
		if (data == nil) {
			data = APIConstants.defaultStore;
		}
		
		let adapterOut = Adapter(typeAdapter: APIStoreToStoreAdapter());
		let item = adapterOut.convert(from: data!);
		return item;
	}

	// MARK: - User Auth
	func login(username: String, password: String) async throws -> UserAuth {
		do {
			let model = APILoginRequest(userName: username,
										password: password);
			
			let data = try await userAuthAPIData.loginUser(model: model);
			
			let adapterOut = Adapter(typeAdapter: APIAuthResponseToUserAuthAdapter());
			let item = adapterOut.convert(from: data);
			return item;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}
	
	func registerUserDevice(userID: String, deviceToken: String) async throws -> Bool {
		do {
			let model = APISyncUserDeviceRequest(userId: userID, deviceId: deviceToken);
			let data = try await userAuthAPIData.syncUserDevice(model: model);
			
			guard data else {
				throw AppError(type: .dataError);
			}
			
			return data;
		}
		catch let data as DataError<String> {
			throw convertAPIError(data: data);
		}
	}

	// MARK: - Merchants
	func getRecommendedMerchants(storeID: Int) async throws -> [Merchant] {
		do {
			let data = try await merchantAPIData.getHomeMerchants(storeID: storeID);

			let adapterOut = Adapter(typeAdapter: APIMerchantToMerchantAdapter());
			let items = adapterOut.convert(from: data);
			return items;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}

	func getTopMerchantsProducts(storeID: Int) async throws -> [HomeMerchantProductsDTO] {
		do {
			let data = try await merchantAPIData.getHomeMerchantsProducts(storeID: storeID);

			let adapterOut = Adapter(typeAdapter: APIMerchantProductToHomeMerchantProductsDTOAdapter());
			let items = adapterOut.convert(from: data);
			return items;
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}

	// MARK: - Products
	func getProductsPaged(listParameters: ProductsListParameters) async throws -> PagedList<Product> {
		do {
			let adapterIn = Adapter(typeAdapter: ProductsListParametersToAPIProductsListRequestAdapter());
			let model = adapterIn.convert(from: listParameters);
			
			let data = try await productAPIData.getProductsList(model: model);
			
			let adapterOut = Adapter(typeAdapter: APIProductToProductAdapter());
			let items = adapterOut.convert(from: data.items);
			return PagedList(list: items,
							 totalCount: data.itemsCount,
							 totalPages: calculateTotalPages(itemsCount: data.itemsCount, pageSize: model.pageSize));
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}

	func getProductDetails(id: Int, storeID: Int, merchantID: String, userID: String?, subCategoryID: Int) async throws -> Product {
		do {
			let model = APIProductDetailsRequest(productId: id,
												 storeId: storeID,
												 customerId: userID,
												 subCategoryId: subCategoryID,
												 merchantId: merchantID);
			
			let data = try await productAPIData.getProductDetails(model: model);
			
			let adapterOut = Adapter(typeAdapter: APIProductToProductAdapter());
			return adapterOut.convert(from: data);
		}
		catch let data as DataError<APIError> {
			throw convertAPIError(data: data);
		}
	}
	
	// MARK: - Private
	private func convertAPIError(data: DataError<String>) -> AppError {
		let adapter = Adapter(typeAdapter: DataErrorStringToAppErrorAdapter());
		return adapter.convert(from: data);
	}
	
	private func convertAPIError(data: DataError<APIError>) -> AppError {
		let adapter = Adapter(typeAdapter: DataErrorAPIErrorToAppErrorAdapter());
		return adapter.convert(from: data);
	}
	
	private func convertAPIError(data: DataError<APIAdvancedError>) -> AppError {
		let adapter = Adapter(typeAdapter: DataErrorAPIAdvancedErrorToAppErrorAdapter());
		return adapter.convert(from: data);
	}
	
	private func calculateTotalPages(itemsCount: Int, pageSize: Int) -> Int {
		Int(Math.round(number: Double(itemsCount / pageSize), decimalPoints: 0))
	}
	
}
