### RFM 분석

# 데이터 로드
ecommerce <- read.csv("data/ecommerce.csv")
rfm <- ecommerce

# Recency 산출
rfm$orderdt <- as.Date(rfm$InvoiceDate, "%m/%d/%Y") # source 데이터와 동일형태

str(rfm)
summary(rfm$orderdt)

## 고객별 최종구매일부터 분석시점까지의 경과기간을 Recency로 생성
rfm.end <- aggregate.data.frame(rfm$orderdt, list(rfm$CustomerID), max) # 고객별 최종구매일 생성

colnames(rfm.end) <- c("CustomerID", "enddt")
rfm.end$endym <- format(rfm.end$enddt, "%Y%m") # 최종가입일을 문자로 변환
table(rfm.end$endym)
barplot(table(rfm.end$endym))



## 고객별가입기간생성
rfm.end$term= as.Date("20120101", "%Y%m%d") -rfm.end$enddt
summary(rfm.end$term) # 분석일자를‘20120101’로지정
rfm.end$term= as.numeric(as.Date("20120101", "%Y%m%d") -rfm.end$enddt)
summary(rfm.end$term) # term 변수를numeric 으로생성


## 고객 Recency 세분화
rfm.end$rseg <- ifelse(rfm.end$term <= 39, 1,
                       ifelse(rfm.end$term <= 73, 2,
                              ifelse(rfm.end$term <= 166, 3, 4))) # 4분위수 기준으로 4개 그룹으로 생성

table(rfm.end$rseg)
barplot(table(rfm.end$rseg))


# Frequency 산출
## 고객별구매일을count하여구매횟수생성
rfm.freq= subset(rfm, select = c("CustomerID", "orderdt"))
rfm.freq2 = unique(rfm.freq) # 구매일중복제거
rfm.freq3 = aggregate.data.frame(rfm.freq2$orderdt, list(rfm.freq2$CustomerID), length)
colnames(rfm.freq3) = c("CustomerID","cnt")
summary(rfm.freq3$cnt)
hist(rfm.freq3$cnt) # Histogram Plot


## 고객Frequency 세분화
rfm.end$loyaltyrfm= ifelse(rfm.end$term<= 39, 1,
                           ifelse(rfm.end$term<= 73, 2,
                                  ifelse(rfm.end$term<= 166, 3, 4 )))
# 4분위수기준으로4개그룹생성
table(rfm.end$loyaltyrfm)
barplot(table(rfm.end$loyaltyrfm))
aggregate(rfm.end$term, list(rfm.end$loyaltyrfm), mean) #그룹별평균frequency


##
## Moneytary 세분화
##
## 1. 구매금액 생성 = 수량 * 단가
rfm$totamt <- rfm$Quantity * rfm$UnitPrice
summary(rfm$totamt)

## 2. 고객별 구매금액 합계 생성
rfm.moneytary <- aggregate.data.frame(rfm$totamt, list(rfm$CustomerID), sum)
colnames(rfm.moneytary) <- c("CustomerID", "totamt")
summary(rfm.moneytary$totamt)
hist(rfm.moneytary$totamt)


# 4분위수기준으로4개그룹생성
table(rfm.monetary$mseg)
barplot(table(rfm.monetary$mseg))
aggregate(rfm.monetary$totamt, list(rfm.monetary$mseg), mean) #그룹별평균금액


## 3. 고객별 구매금액을 4분위수 기준으로 4개 그룹 생성
rfm.moneytary$mseg <- ifelse(rfm.moneytary$totamt <= 293, 1, 
                         ifelse(rfm.moneytary$totamt <= 648, 2,
                                ifelse(rfm.moneytary$totamt <= 1611, 3, 4))) # 4분위수 

## 4. 그룹별 평균금액 조회
table(rfm.moneytary$mseg)
barplot(table(rfm.moneytary$mseg))
aggregate(rfm.moneytary$totamt, list(rfm.moneytary$mseg), mean) # 그룹별 평균


## R, F, M 정보통합
rfm.all <-  merge(rfm.end, rfm.freq3, by = "CustomerID", all.xy= TRUE)
rfm.all <-  merge(rfm.all, rfm.monetary, by = "CustomerID", all.xy= TRUE)

## 세분화그룹생성
rfm.all$rfmid <- paste(rfm.all$rseg, rfm.all$fseg, rfm.all$mseg, sep="")
table(rfm.all$rfmid)


#--------------------------------------------------------------------------#

### RFM 세그먼트
## Step1 : 6개월(Term1) RFM 정보 생성
# 1. RFM 생성기간 데이터 추출
rfm1 <- subset(rfm, rfm$orderdt < as.Date("20110601", "%Y%m%d"))
summary(rfm1$orderdt)

# 2. 마지막 구매일자 생성
rfm1.end <- aggregate.data.frame(rfm1$orderdt, list(rfm1$CustomerID), max) # 고객별 
colnames(rfm1.end) <- c("CustomerID", "enddt")

# 3. 고객별 가입기간 생성
rfm1.end$term <- as.numeric(as.Date("20110601", "%Y%m%d") - rfm1.end$enddt)
summary(rfm1.end$term) # 분석일자를 '20110601'로 지정

## 고객 Recency 세분화

rfm1.end$rseg <- ifelse(rfm1.end$term <= 19, 4, 
                       ifelse(rfm1.end$term <= 50, 3,
                              ifelse(rfm1.end$term <= 98, 2, 1))) # 4분위수 기준으로 4개 그룹으로 생성

table(rfm1.end$rseg)
barplot(table(rfm1.end$rseg))


## Frequency 생성
# rnaodlfdmf 채ㅕㅜㅅ gkdu rnaoghlttn todtjd
rfm1.freq <- subset(rfm1, select = c("CustomerID", "orderdt"))
rfm1.freq2 <- unique(rfm1.freq)
rfm1.freq3 <- aggregate.data.frame(rfm1.freq2$orderdt, list(rfm1.freq2$CustomerID), length)
colnames(rfm1.freq3) = c("CustomerId", "cnt")

summary(rfm1.freq3$cnt)
hist(rfm1.freq3$cnt)

# Frequency 세분화
rfm1.freq3$fseg <- ifelse(rfm1.freq3$cnt <= 1, 1, 
                         ifelse(rfm1.freq3$cnt <= 2, 2,
                                ifelse(rfm1.freq3$cnt <= 3, 3, 4))) # 4분위수 
table(rfm1.freq3$fseg)


##
## Moneytary 세분화
##
## 1. 구매금액 생성 = 수량 * 단가
rfm1$totamt <- rfm1$Quantity * rfm1$UnitPrice
summary(rfm$totamt)

## 2. 고객별 구매금액 합계 생성
rfm1.moneytary <- aggregate.data.frame(rfm1$totamt, list(rfm1$CustomerID), sum)
colnames(rfm1.moneytary) <- c("CustomerID", "totamt")
summary(rfm1.moneytary$totamt)
hist(rfm1.moneytary$totamt)

## 3. 고객별 구매금액을 4분위수 기준으로 4개 그룹 생성
rfm1.moneytary$mseg <- ifelse(rfm1.moneytary$totamt <= 225, 1, 
                             ifelse(rfm1.moneytary$totamt <= 449, 2,
                                    ifelse(rfm1.moneytary$totamt <= 1024, 3, 4))) # 4분위수 

## 4. 그룹별 평균금액 조회
table(rfm1.moneytary$mseg)
barplot(table(rfm1.moneytary$mseg))
aggregate(rfm1.moneytary$totamt, list(rfm1.moneytary$mseg), mean) # 그룹별 평균


## R, F, M 정보 통합
rfm.all <- merge(rfm.end, rfm.freq3, by = "CustomerID", all.xy = T)
rfm.all <- merge(rfm.all, rfm.moneytary, by = "CustomerID", all.xy = T)

# 세분화 그룹 생성
rfm.all$rfmid <- paste(rfm.all$rseg, rfm.all$fseg, rfm.all$mseg, sep = "")
table(rfm.all$rfmid) 


