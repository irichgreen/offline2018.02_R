## 데이터 핸들링

# 데이터 결합(Left, Right, Inner, Outter Join)
key_a= c(1, 2)
a = c("가", "나")
table_a = data.frame(key_a, a)

key_b= c(1, 3, 4)
b = c(100, 1500, 20)
table_b= data.frame(key_b, b)

inner = merge(table_a, table_b, all = F, by.x= c("key_a"),
              by.y= c("key_b"))

left = merge(table_a, table_b, all.x= T, by.x= c("key_a"),
             by.y= c("key_b"))

right = merge(table_a, table_b, all.y= T, by.x= c("key_a"),
              by.y= c("key_b"))

outer = merge(table_a, table_b, all = T, by.x= c("key_a"),
              by.y= c("key_b"))

# 데이터 정렬 및 중복제거

# 정렬
test = data.frame(x = c("a", "b", "c", "d", "e"), y = c(1, 5, 4, 7, 2))
test = test[order(-test$y),] # descending (-)

# 중복제거
test = data.frame(x = c("a", "b", "b", "c", "c", "d"), y = c(1, 2, 3, 4, 4, 5))
test1 = unique(test) #unique 사용
test2 = test[!duplicated(test$x),] #변수1개중복제거
