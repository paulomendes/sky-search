import Alamofire
import RxSwift

protocol NetworkRequestProviderType {
    func performRequest<T: Decodable>(target: Target) -> Single<T>
    func performRequestForHeader(target: Target) -> Single<URLComponents>
}

final class NetworkRequestProvider: NetworkRequestProviderType {
    private let sessionManager = SessionManager(configuration: .default)

    func performRequest<T: Decodable>(target: Target) -> Single<T> {
        do {
            let parameters = try self.encode(target.parameters)
            return request(url: target.requestURL, method: target.method, parameters: parameters)
        } catch {
            return .error(error)
        }
    }

    func performRequestForHeader(target: Target) -> Single<URLComponents> {
        do {
            let parameters = try self.encode(target.parameters)
            return headerRequest(url: target.requestURL, method: target.method, parameters: parameters)
        } catch {
            return .error(error)
        }
    }
}

private extension NetworkRequestProvider {
    func headerRequest(url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> Single<URLComponents> {
        return Single<URLComponents>.create { single -> Disposable in

            let request = self.sessionManager.request(url,
                                                      method: method,
                                                      parameters: parameters)
                .validate(contentType: ["application/x-www-form-urlencoded"])
                .response(completionHandler: { response in
                    guard let location = response.response?.allHeaderFields["Location"] as? String else {
                        single(.error(NetworkError.noHeader))
                        return
                    }

                    guard let locationURL = URLComponents(string: location) else {
                        single(.error(NetworkError.noData))
                        return
                    }

                    single(.success(locationURL))

                })
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func request<T: Decodable>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?) -> Single<T> {
        return Single<T>.create { single -> Disposable in

            let request = self.sessionManager.request(url,
                                                      method: method,
                                                      parameters: parameters)
                .validate()
                .responseJSON(completionHandler: { response in
                    do {
                        guard let responseData = response.data else {
                            single(.error(NetworkError.noData))
                            return
                        }
                        let responseDecoded = try JSONDecoder().decode(T.self, from: responseData)
                        single(.success(responseDecoded))
                    } catch {
                        single(.error(NetworkError.serializationError))
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func encode(_ parameters: EncodingTrait?) throws -> Parameters? {
        guard let parameters = try parameters?.encode() else {
            return nil
        }
        return parameters
    }
}
