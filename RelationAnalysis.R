###
### 연관구매분석
###

# Sample 데이터입력
a = c("1", "1", "2", "2", "2", "3", "3", "4", "4", "4", "5", "5")
b = c("오렌지", "딸기", "사과", "오렌지", "오이", "오렌지",
"당근", "오렌지", "당근", "딸기", "오이", "딸기")

basket  <-  cbind(a,b)
basket <-  as.data.frame(basket)
colnames(basket)  <-  c("id", "product")
basket
basket$product[basket$id == "B"]
