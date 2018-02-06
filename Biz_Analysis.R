### 비즈니스 분석1
## 1. 고객 분석

# 데이터 로드
blackfriday <- read.csv("data/blackfriday.csv")

# 고객 연령 분석
table(blackfriday$Age)

cust_id <- blackfriday[c(1, 4)]
cust_id2 <- unique(cust_id) # 고객 ID Unique 추출
cust_id2

table(cust_id2$Age)
plot(cust_id2$Age)

# 고객 성별 분석
cust_id <- blackfriday[c(1, 3)]
cust_id2 <- unique(cust_id)

table(cust_id2$Gender)
plot(cust_id2$Gender)

# 고객 연령별 성별 분석
cust_id <- blackfriday[c(1, 3, 4)]
cust_id2 <- unique(cust_id)

table(cust_id2)
plot(cust_id2$Age, cust_id2$Gender)

freq <- table(cust_id2$Age, cust_id2$Gender)
freq

margin.table(freq, 1)   # 행 합계
margin.table(freq, 2)   # 열 합계
prop.table(freq, 1)     # 행 백분율
prop.table(freq, 2)     # 열 백분율

# 구매횟수 분석

# 매출 데이터 생성
sale <- blackfriday
str(sale)

# 구매횟수 대신 고객별 구매상품 유형수 변수 생성
sale.cnt <- aggregate.data.frame(sale$Product_ID, list(sale$User_ID), length) # 고객별 구매상품 ID 개수 산출
colnames(sale.cnt) <- c("User_ID", "itemcnt")
summary(sale.cnt$itemcnt)   # 최대값 이상

# 데이터 검증
sam <- subset(sale, User_ID == "1001680") # 데이터 테이블로
samuni <- unique(sam$Product_ID)          # 중복검증 이상없음


# 구매상품 유형수 분석
summary(sale.cnt$itemcnt)

hist(sale.cnt$itemcnt)    # 히스토그램 플롯

sam <- subset(sale.cnt, itemcnt < 100)  # 100이하 고객 추출
hist(sam$itemcnt)

# 구매금액 분석
sale.amt <- aggregate.data.frame(sale$Purchase, list(sale$User_ID), sum) # 고객별 누적금액 합계 생성
colnames(sale.amt) <- c("User_ID", "amt")
summary(sale.amt$amt)
hist(sale.amt$amt)

# 고객 회단가 분석 (한번 살때 얼마나 사나)
sale.price <- merge(sale.cnt, sale.amt, by = "User_ID", all.xy = TRUE) # 상품유형수, 구매금액 병합
sale.price$unitpr <- round(sale.price$amt / sale.price$itemcnt) # 단가변수 생성

summary(sale.price$unitpr)
hist(sale.price$unitpr)

# 연령대별 구매금액 분석
# 1. 구매금액 & 연령정보 병합
sale.age <- merge(sale.price, cust_id2, by = "User_ID", all.xy = T)

# 2. 연령대별 구맥객수 생성
sale.age2 <- aggregate.data.frame(sale.age$User_ID, list(sale.age$Age), length)
colnames(sale.age2) <- c("age", "idcnt")

# 3. 연령대별 구매금액 합계 생성
sale.age3 <- aggregate.data.frame(sale.age$amt, list(sale.age$Age), sum)
colnames(sale.age3) <- c("age", "totamt")

# 4. 연령대별 구매구객수, 구매금액 병합
sale.age4 <- merge(sale.age2, sale.age3, by = "age", all.xy = T)

# 5. 연령배별 평균 구매금액 산출
sale.age4$useramt = round(sale.age4$totamt / sale.age4$idcnt)

sale.age4
