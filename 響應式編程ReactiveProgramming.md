### 響應式編程 Reactive Programming  
> 此篇將以 `Swift` 的角度去簡化 RP 理論的解釋  
 
對於 iOS/OS 開發前端，這兩年很頻繁的會聽到這個名詞。  
尤其是 Apple 推出 SwiftUI 與 Combine 以後，似乎 RxSwift 已經變成不是選修條件，越來越多公司在職缺條件中 Combine 或 RxSwift 是必要條件。   
**註：Combine/ RXSwift 是 RP 的高階封裝框架。**  

#### 什麼是響應式編程(RP) ?
相信很多人 Google 之後會更加模糊，尤其是閱讀完 [Wikipedia](https://en.wikipedia.org/wiki/Reactive_programming) 艱深又空洞的理論介紹後，只看到一堆專業術語跟更多沒見過的名詞。    

**別擔心** 我會試著解釋這一切。   
<br>

---

#### **解決的問題**  

RP 解決 **Data 與 View** 是不同步的問題，  
在前端開發中，數據變化後再手動通知View 重新渲染，而在需求的增加與迭代開發後，最後就是 **`數據變化`** 與 **`刷新視圖`** 充斥在各處，交錯依賴難以維護。  
**(請見下方的偽代碼)**
 
```
var userInfo = User()  

func fetchUserInfo() {  
      task.fetchAPI { data in
      guard let userInfo = try? decord(data) 
           else { return }  
       self.userInfo = userInfo
       self.view.reload()
        }
    }

func changeUserName() {  
      userInfo.name = "Jhonny"  
      view.reload()  
    }

func changeUser() {  
       userInfo = newUserInfo()  
       view.reload()  
    } 
```
<br>
#### **實現的方法**
透過 **`資訊傳遞`** 的流動，拆分解藕每一個步驟。  
想像一下河流有其 **`源頭`** 、 **`目的地`** 與每一個 **`節點`**，  
透過這樣的劃分，這一切似乎就更好的去管理與控制河流的變化。  

- **事件 Event** (源頭)：remote url request、database request ....
- **轉換 Operator** (節點)：decord, data transform...
- **綁定 Binding** (目的地)：data cache、發送事件結束消息...
- **觀察 Observe** (目的地之後)：渲染畫面、下一個事件開始...  

#### 透過封裝後，把上面的邏輯組裝起來
```
fetchUserInfo() // Event
       .decord() // Operator
       .binding(on: self.userInfo) // 目的地
       
$self.userInfo.observe { self.view.reload } // Observe

func changeUserName() {  
      userInfo.name = "Jhonny"  
    }
 func changeUser() {  
       userInfo = newUserInfo()  
    } 
``` 
>- view 渲染的命令被收斂在對 userInfo 的觀察。  
>- userInfo 的相關的變化邏輯都與 UI 層解藕。  
>- data 從取得到變形被拆成一段一段去處理，便於管理代碼。  

<br>

---

### 觀察者模式 vs 響應式編程  
OOP 的 **`觀察者模式`** 最常與 **`RP`** 做比較，  
那它們之間最大的差別可以用想要解決的問題與執行的位子的差別來區分。   

#### 觀察者模式：  
> 為了解決不同物件 1 對多的數據傳遞問題。 
 
#### 響應式編程 
> 解決 **Data 與 View** 是不同步的問題

所以在實作上， **`觀察者模式`** 會在 B 、C、D 物件中對 A 的觀察。
而 **`響應式編程`** 中，物件時常觀察自己內部某個值去執行下一個事件。

<br>

---

### 響應式編程範圍
在轉換成 **`RP`** 過程中，你可能會對範圍有所困惑。  
意思是整支APP的架構要做到什麼程度才算是響應式編程？

經過一段時間的練習與實作後，  
我認為 **`RP`** 如同其它的設計模式一樣，  
你可以小到一個 View 內所有的狀態變化流動，  
也可以大到整支 APP 所有事件與數覺得流動。  
所以在轉換初期可以先試著已一個 View 與其 ViewModel 做嘗試。



***下一章節，將會 Demo 由 Combine 所編寫的 RP***
