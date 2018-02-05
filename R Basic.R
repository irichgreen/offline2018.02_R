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

# 조건문
test <- 30
if (test > 20) {
  cat("UP")} else {
    cat("DOWN")
}

# SQL 사용
library(sqldf)

list <- as.data.frame(available.packages())

sam <- iris

colnames(sam) <- c("sl", "sw", "pl", "pw", "Species")

a <- sqldf("SELECT Species, sum(sl) FROM sam GROUP BY Species")
a

# Group으로 연산할 수 있는 함수 aggregate도 같은 기능을 한다
result2 <- aggregate(sam$sl ~ sam$Species, FUN = sum)
result2
colnames <- c("Species", "sl")

library(dplyr)
sam %>% 
  group_by(Species) %>% 
  summarize(sp_sum = sum(sl))
sam

glimpse(sam)

## R Graphs

x <- c(2,5,8,5,7,10,11,3,4,7,12,15)
y <- c(1,2,3,4,5,6,7,8,9,10,11,12)

plot(x, y)
plot(iris[,1:4])

# Barplot
x = c(2,5,8,5,7,10,11,3,4,7,12,15)
barplot(x)

# Histogram
x=c(2,5,8,5,7,10,11,3,4,7,12,15)
hist(x)

# Boxplot
x=c(2,5,8,5,7,10,11,3,4,7,12,15)
z=c(3.5, 2.2, 1.5, 4.6, 6.9)
boxplot(x,z)

# pairs 함수
x=c(2,5,8,5,7,10,11,3,4,7,12,15)
y=c(1,2,3,4,5,6,7,8,9,10,11,12)
a=data.frame(x,y)
pairs(a)
pairs(iris[1:4], pch= 21, bg= c("red", "green3",
                                  "blue")[unclass(iris$Species)])


## 자주 사용하는 수치 및 통계함수

x <- c(1,2,-3,4,5,10)
sample <- iris
quantile(sam$sl)

# table 함수를 이용한 교차 및 빈도분석

sam_iris=iris
table(sam_iris$Species)
table(sam_iris$Sepal.Length>5,sam_iris$Species)

# 데이터 검증
blackfriday <- read.csv("data/blackfriday.csv")
summary(blackfriday)
table(blackfriday$City_Category)

colnames(blackfriday) <- c("User-id", "city_categorie")

# blackfriday <- aggregate(blackfriday$Purchase ~ blackfriday$User_ID + blackfriday)

# t.테스트 검정
sales_t1 = c(14, 20, 39, 45, 15, 18, 76, 12, 37, 26)
sales_t2 = c(45, 50, 40, 48, 55, 36, 52, 40, 58, 56)

t.test(sales_t1, sales_t2)
