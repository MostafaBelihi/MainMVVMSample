//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Foundation
import Moya

enum APIEndpoints {
	case homeData(userID: String?)
	case stores
	case banners
	
	case login(model: APILoginRequest)

	case getHomeMerchants(storeID: Int)
	case getHomeMerchantsProducts(storeID: Int)
	
	case products(model: APIProductsListRequest)
	case product(model: APIProductDetailsRequest)
}

struct SubPaths {
	static let home = "MobileHome"
	static let stores = "MobileStores"
	static let banners = "MobileBanner"
	static let auth = "MobileAuth"
	static let merchants = "MobileMerchants"
	static let products2 = "MobileNewProduct"
}

extension APIEndpoints: TargetType {
	private var auth: PAuthenticationManager {
		return DependencyInjector.shared.resolve(PAuthenticationManager.self);
	}
	
	var baseURL: URL {
		var subPath = "";

		switch self {
			case .homeData: subPath = SubPaths.home;
			case .stores: subPath = SubPaths.stores;
			case .banners: subPath = SubPaths.banners;
			
			case .login: subPath = SubPaths.auth;
			
			case .getHomeMerchants: subPath = SubPaths.merchants;
			case .getHomeMerchantsProducts: subPath = SubPaths.merchants;
			
			case .products: subPath = SubPaths.products2;
			case .product: subPath = SubPaths.products2;
		}
		
		let finalPath = (subPath == "") ? APIConstants.baseURL : "\(APIConstants.baseURL)/\(subPath)";
		return URL(string: finalPath)!
	}

	var path: String {
		switch self {
			case .homeData(let userID):
				if let userID = userID { return "MobileHomeSetting/\(userID)"; }
				return "MobileHomeSetting/null";
			
			case .stores: return "GetMerchantStores";
			case .banners: return "GetAll";
			
			case .login: return "LoginUser";
				
			case .getHomeMerchants(let storeID): return "GetFavMerchants/\(storeID)";
			case .getHomeMerchantsProducts(let storeID): return "GetHomePageMerchants/\(storeID)";

			case .products: return "GetAllProductFilter";
			case .product: return "GetProductDetails";
		}
	}
	
	var method: Moya.Method {
		switch self {
			case .homeData: return .get;
			case .stores: return .get;
			case .banners: return .get;
			
			case .login: return .post;
				
			case .getHomeMerchants: return .get;
			case .getHomeMerchantsProducts: return .get;

			case .products: return .post;
			case .product: return .post;
		}
	}
	
	var task: Task {
		switch self {
			case .login(let model): return generateDefaultEncodedParameters(from: model);
			case .products(let model): return generateDefaultEncodedParameters(from: model);
			case .product(let model): return generateDefaultEncodedParameters(from: model);

			default:
				return .requestPlain;
		}
	}

	var headers: [String: String]? {
		var headers: Dictionary<String, String> = ["Content-Type": "application/json"];
		headers["Authorization"] = "Bearer \(auth.userToken)";
		return headers;
	}
	
	// MARK: - Private Functions
	private func generateDefaultEncodedParameters<TModel: Encodable>(from model: TModel) -> Task {
		guard let parameters = model.dictionary else {
			return .requestPlain;
		}
		
		return .requestParameters(parameters: parameters, encoding: JSONEncoding.default);
	}
}
