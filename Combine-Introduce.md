### [Combine](https://developer.apple.com/documentation/combine) 基礎概要
[上一篇](./響應式編程ReactiveProgramming.md) 以 **Swift** 角度介紹 **響應式編程** 。  
接下來我要介紹的是 **Swift** 原生的 **響應式框架** 基本架構與應用。

> 如果之前你已經學會 **RXSwift** 框架的話，  
> 基本上 **Combine** 的應用對你來說可能只是幾分鐘的事情，  
> 因為 **Combine** 整體架構與 API 設計 很大一部分都致敬了 **RXSwift**  
  
#### **主要組件 Base Component**
Combine 的架構主要由三個 **`Protocol`** 組合起來起來  

- Publisher - 發布商（訊號的源頭)
- Subscription - 訂閱商 (河道-類似經銷商的角色)
- Subscriber - 訂戶 (接收到數據要執行的事情)

**簡易關聯圖**  

![關聯圖](./resource/PSS關聯圖.png)

1. Subscriber 向 Publisher 登記一個訂閱，獲取 Subscription。
2.  Publisher 傳遞數據給 Subscription
3.  Subscription 再將數據傳遞給 Subscriber  

基本應用情境下，不會直接接觸到 Publisher 與 Subscriber 的實體，Combine 框架已經將它們封裝在 API 內。  
我們只要管理好 Subscription 的生命週期即可。  

---  
接下來的介紹建議搭配 [Playgraound](./CombineIntroduce.playground)

### Publisher  
從 Apple 推出 Combine 以後，也陸續替 Swift 基本數據庫中的成員增加 Publisher   以支援 Combine 的橋接。如：Timer, NoticationCenter, NSObject 與 基本型別等。  

**請查看 Publisher 頁籤**  

```
var arr: [Int] = [0, 1, 2]
var str: String = "ABCD"
var int: Int = 1000

arr.publisher.printValue().store(in: &bag)
str.publisher.printValue().store(in: &bag)
int.words.publisher.printValue().store(in: &bag) 
```  

arr, str, int 均提供相應的 Publisher 數據流的傳遞。  
>  請試著執行比較差異

---

### Subscriber 
Subscriber 為一段數據流的尾端，它封裝訂閱時所申明要執行的 closure。

**請查看 Subscriber 頁籤**  

```  
var arr: [Int] = [0, 1, 2]
let toDo: (Int)-> Void = { print($0 * 2) }

arr.publisher
    .sink(receiveValue: toDo)
    .store(in: &bag)  
``` 

---

### Subscription
Subscription 負責傳遞數據，它也掌握流的有效性。  

**請查看 Subscription 頁籤**  

```  
var arr: [Int] = [0, 1, 2]
var subscription: AnyCancellable? = arr.publisher
    .printValue()

subscription?.cancel()
// or
subscription = nil 
```  

Subscription 結束生命週期 或是執行 **`cancel()`** 停止訂閱  
，未來有新的數據就不會再傳遞 。

---

#### 實體
剛剛介紹了 Combine 三個主要協定，  
當然 Swift 團隊還提供很多遵守這些協定的實體，  
如：[Just](https://developer.apple.com/documentation/combine/just) 、[Future](https://developer.apple.com/documentation/combine/future)、[Empty](https://developer.apple.com/documentation/combine/empty) ...等。  

接下來會關注 Combine 內最常用三大元件、  

- [PassthroughSubject](https://developer.apple.com/documentation/combine/passthroughsubject)  
- [CurrentValueSubject
](https://developer.apple.com/documentation/combine/currentvaluesubject)  
- [Published](https://developer.apple.com/documentation/combine/published)  

它們直接提升 Swift 對屬性的監聽更加簡單容易，  
也是整個響應式框架的核心角色。 

### PassthroughSubject  
**`PassthroughSubject`** 提供發送值的功能，而本身不會存取這個值，就像一個郵差一樣的角色。

**請查看 PassthroughSubject 頁籤**  

```  
let infailableSubject = PassthroughSubject<Int, Never> ()
let failableSubject = PassthroughSubject<Int, MyError>()

infailableSubject.send(1)
failableSubject.send(1)
```  

初始化 **`PassthroughSubject`** 要先定義 Output 與 Failure 的型別。
  
- Output : Int   
- Failure : Never, MyError

>  請試著執行  

#### **補充**
**Never**：Combine 原生的 Error 型別，意思是Publisher 不會有錯誤狀況。  
**MyError** ：MyError 是我自己定義的錯誤型別 (Sources/Error.swift )  

```  
public enum MyError: Error {
    case someError
    case none
}
```  
### CurrentValueSubject  
**`CurrentValueSubject `** 發送一個新值並存取起來。與  **`PassthroughSubject`**  不同的是 **`CurrentValueSubject `** 會 Cache 最新的值。

**請查看 CurrentValueSubject 頁籤**  

```  
let infailableSubject = CurrentValueSubject<Int, Never> ()
let failableSubject = CurrentValueSubject<Int, MyError>()

infailableSubject.send(1)
failableSubject.send(1)
```  
>  請試著執行  

### Published  
**`Published `** 為一個屬性包裝器類型的 struct 。  
它會在其封裝的值 **即將** 改變時發送新值的訊號出去。  

**請查看 Published 頁籤**  

```  
@Published
var value: Int = 0
$value..sink(receiveValue: intClosure).store(in: &bag)

value = 1 // 值接更改即可
value = 2 
```  
>  請試著執行與 CurrentValueSubject 比較。  

#### 補充  
範例 **PublishedContainer** 內封裝了一個帶有 **`@Published`** 標籤的 泛型 value 。  
因為 **`Published`** 必須在 class 內部才能定義。  
申明觀察帶有 **`@Published`** 標籤的值時，需要加上前墜 **$** 符號。  

 








