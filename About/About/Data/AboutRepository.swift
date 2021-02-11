//
//  AboutRepository.swift
//  About
//
//  Created by Indra Permana on 10/02/21.
//

import Foundation
import Core
import RxSwift

public struct GetAboutRepository: Repository {
  
  public typealias Request = Any
  public typealias Response = AboutDomainModel
  
  public init() {}
  
  public func execute(request: Any?) -> Observable<AboutDomainModel> {
    return Observable<AboutDomainModel>.create { observer in
      let about = AboutDomainModel(
        name: "Muhamad Yusuf Indra P. P.",
        email: "muhamadyusufindra@gmail.com",
        imageName: "yusuf.png"
      )
      observer.onNext(about)
      observer.onCompleted()
      return Disposables.create()
    }
  }
  
}
