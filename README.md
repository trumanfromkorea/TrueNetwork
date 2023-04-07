# TrueNetwork

<img src="https://user-images.githubusercontent.com/55919701/208962188-ddea2d3a-08e1-4df2-9590-d0db9f948d30.gif" width="200">

- `URLSession` 을 이용한 네트워크 통신 모듈입니다.
- API 통신에 쓰이는 데이터들을 추상화하고, 통신 과정을 간편화하여 구현하는 것을 목표로 했습니다.

## 설치
- SPM (Swift Package Manager)

``` 
https://github.com/trumanfromkorea/TrueNetwork.git
```

## 사용법

### RequestConvertible

- Request 를 생성하는데 사용될 규격인 `RequestConvertible` 프로토콜을 활용합니다.
- 일반적으로 API 요청에 사용되는 요소들을 가지고 있습니다.
- `RequestConvertible` 프로토콜은 아래와 같이 구현되어 있습니다.

```swift
// Request 를 생성하는데 사용될 규격
public protocol RequestConvertible {
    var baseUrl: String { get }
    var method: HTTPMethod { get }
    var paths: [String] { get }
    var parameters: [String: Any]? { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
}
```

- `RequestConvertible` 을 준수하는 객체를 생성합니다.
- 예시에서는 `Endpoint` 라는 이름의 열거형을 생성했습니다.
- 프로퍼티 내에서 각 case 마다 사용할 값들을 리턴합니다.

```swift
enum Endpoint {
    case fetchPosts
    case fetchCommentsWithParams(postId: Int)
    case writePost(post: PostInfo)
    case updatePost(postId: Int, post: PostInfo)
    case deletePost(postId: Int)
}

extension Endpoint: RequestConvertible {
    var baseUrl: String {
        return "https://jsonplaceholder.typicode.com"
    }

    var method: HTTPMethod {
        switch self {
        case .fetchPosts, .fetchCommentsWithParams:
            return .get

        case .writePost:
            return .post

        case .updatePost:
            return .put
            
        case .deletePost:
            return .delete
        }
    }

    var paths: [String] {
        switch self {
        case .fetchPosts:
            return ["posts"]

        case .fetchCommentsWithParams:
            return ["comments"]

        case .writePost:
            return ["posts"]

        case let .updatePost(postId, _), .deletePost(postId):
            return ["posts", "\(postId)"]
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .fetchCommentsWithParams(postId):
            return ["postId": postId]

        default:
            return nil
        }
    }

    var body: [String: Any]? {
        switch self {
        case let .writePost(post):
            return post.dict

        case let .updatePost(_, post):
            return post.dict

        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json; charset=UTF-8"]
    }
}
```

### request 메소드 호출

- 제네릭 타입을 활용해 원하는 응답 객체를 `NetworkProvider` 로 생성할 수 있습니다. 
- `enpoint` 파라미터에는 위의 `RequestConvertible` 을 준수하는 객체를 활용합니다. 예시의 경우 `Endpoint` 객체를 사용합니다.
- `completion` 의 경우 객체를 생성할 때 사용했던 제네릭 타입과 `NetworkError` 로 이루어진 `Result` 타입을 파라미터로 갖습니다.
- 아래는 해당 메소드를 직접 호출한 예입니다.

```swift
NetworkProvider<[PostInfo]>()
    .request(endpoint: Endpoint.fetchPosts) { [weak self] result in
        switch result {
        case let .success(data):
            // 성공 시 data 를 이용한 작업
        case let .failure(error):
            // 실패 시 error 을 이용한 예외처리
        }
    }
```

- 레포지토리에 포함된 Example 프로젝트에서 더 자세한 사용법을 확인하실 수 있습니다. 
