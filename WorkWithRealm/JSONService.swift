//
//  WorkWithJSON.swift
//  WorkWithRealm
//
//  Created by Viktoria on 8/11/17.
//  Copyright © 2017 Viktoria. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import PromiseKit

class JSONService {
    let realm = try! Realm()

    func getJSONFromServer() -> Promise<String> {

        return Promise<String> { fulfill, _ in
            let url = "http://localhost:3000/users"
            Alamofire.request(url)
                .responseArray { (response: DataResponse<[User]>) in
                    switch response.result {
                    case .success(let users):
                        do {
                            let realm = try! Realm()
                            try realm.write {
                                for user in users {
                                    realm.add(user)
                                    fulfill("Successully filled realm")
                                }
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                    case .failure(let error):
                        print(error)
                    }
            }
        }

    }
    @discardableResult func deleteJSONFromServer(user: User) -> Promise<String> {

        return Promise<String> { fulfill, _ in
            let url = "http://localhost:3000/users/\(user.id)"
            let realm = try! Realm()
            try! realm.write {
                let jsonUser = user.toJSON()
                request(url, method: .delete, parameters: jsonUser, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { responseJSON in

                    switch responseJSON.result {
                    case .success(let value):
                        let jsonObject = responseJSON.result.value
                        fulfill("Successully deleted")
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    @discardableResult func putJSONToServer(user: User) -> Promise<String> {

        return Promise<String> { fulfill, _ in
            let url = "http://localhost:3000/users/\(user.id)"
            try! realm.write {
                let jsonUser = user.toJSON()
                request(url, method: .put, parameters: jsonUser, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { responseJSON in

                    switch responseJSON.result {
                    case .success(let value):
                        let jsonObject = responseJSON.result.value
                        fulfill("Successully edited")
                    case .failure(let error):
                        print(error)
                    }
                }

            }
        }
    }
    @discardableResult func postJSONToServer(user: User) -> Promise<String> {

        return Promise<String> { fulfill, _ in
            let url = "http://localhost:3000/users"
            try! realm.write {
                let jsonUser = user.toJSON()
                request(url, method: .post, parameters: jsonUser, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let value):
                        _ = responseJSON.result.value
                        fulfill("Successully added")
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
}
