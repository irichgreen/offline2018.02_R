### 고객 세그먼트 분석
library(dplyr)
# 데이터 로드
ecommerce <- read.csv("data/ecommerce.csv")

# 고객 세분화 데이터 생성
seg <- ecommerce
glimpse(seg)

# 날짜 형태 변환
seg$orderdt <- as.Date(seg$InvoiceDate, "%m/%d/%Y") # source 데이터와 동일형태
str(seg)
summary(seg$orderdt)

# 고객별 최초 구매일을 가입일로 생성
seg.start <- aggregate.data.frame(seg$orderdt, list(seg$CustomerID), min)
colnames(seg.start) = c("CustomerID", "startdt")

seg.start$startym <- format(seg$orderdt, "%Y%m")
table(seg.term1$term1_yn)

seg.start$term <- as.numeric(as.Date("20120101", "%Y%m%d") - seg.start$startdt)

seg.start$loyaltyseg <- ifelse(seg.start$term <= 138, 1,
                               ifelse(seg.start$term <= 276, 2,
                                      ifelse(seg.start$term <= 354, 3, 4)))

table(seg.start$loyaltyseg)
barplot(table(seg.start$loyaltyseg))
aggregate(seg.start$term, list(seg.start$loyaltyseg), mean)

## 1. 구매금액 생성 = 수량 * 단가
seg$totamt <- seg$Quantity * seg$UnitPrice
summary(seg$totamt)

## 2. 고객별 구매금액 합계 생성
seg.profit <- aggregate.data.frame(seg$totamt, list(seg$CustomerID), sum)
colnames(seg.profit) <- c("CustomerID", "totamt")
summary(seg.profit$totamt)
hist(seg.profit$totamt)

## 3. 고객별 구매금액을 4분위수 기준으로 4개 그룹 생성
# 0 이하 금액을  0으로 처리
seg.profit$totamt <- ifelse(seg.profit$totamt < 0, 0, seg.profit$totamt)
seg.profit$profitseg <- ifelse(seg.profit$totamt <= 293, 1,
                               ifelse(seg.profit$totamt <= 648, 2,
                                      ifelse(seg.profit$totamt <= 1611, 3, 4))) 

## 4. 그룹별 평균금액 조회
table(seg.profit$profitseg)
barplot(table(seg.profit$profitseg))
aggregate(seg.profit$totamt, list(seg.profit$profitseg), mean) # 그룹별 평균


## R, F, M 정보 통합
seg.all <- merge(seg.start, seg.profit, by = "CustomerID", all.xy = T)

# 세분화 그룹 생성
seg.all$segid <- paste(seg.all$loyaltyseg, seg.all$profitseg, sep = "")
table(seg.all$segid)

# SQL을 활용하여 한번에 해결
