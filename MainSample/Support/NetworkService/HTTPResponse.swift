//
//  iOS Project Infrastructure, by Mostafa AlBelliehy
//  Copyright © 2022 Mostafa AlBelliehy. All rights reserved.
//

import Alamofire

struct HTTPResponse<TModel> {
	var data: TModel
	var statusCode: Int
	var headers: Alamofire.HTTPHeaders?
}

struct HTTPResponseResult<TModel, TError> {
	var result: Result<TModel, DataError<TError>>
	var statusCode: Int
	var headers: Alamofire.HTTPHeaders?
}
