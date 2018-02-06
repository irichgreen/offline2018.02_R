### RFM 분석

# 데이터 로드
ecommerce <- read.csv("data/ecommerce.csv")
churn <- ecommerce

str(churn)


# 날짜 형태 변환
churn$orderdt <- as.Date(rfm$InvoiceDate, "%m/%d/%Y") # source 데이터와 동일형태
summary(churn$orderdt)

# 고객별 구매 년월 생성
churn$orderym <- format(churn$orderdt, "%Y%m")
table(churn$orderym)
barplot(table(churn$orderym))

# term1, term2 구매여부 정보 생성*

churn$term1_yn <- ifelse(churn$orderdt < as.Date("20110601", "%Y%m%d"), 1, 0)
churn$term2_yn <- ifelse(churn$orderdt >= as.Date("20110601", "%Y%m%d") & churn$oderdt < as.Date("20111201",  "%Y%m%d"), 1, 0)

table(churn$term1_yn)
table(churn$term2_yn)

# 고객별 Term 정보 생성
churn.term1 <- aggregate(churn$term1_yn, list(churn$Customer_ID), sum)
colnames(churn.term1) = c("CustomerID", "term1_cnt")
churn.term1$term1_yn <- ifelse(churn,term1$term1_cnt) > 0, 1, 0)
table(churn.term1$term1_yn)

churn.term2 <- aggregate(churn$term2_yn, list(churn$Customer_ID), sum)
colnames(churn.term2) = c("CustomerID", "term2_cnt")
churn.term2$term2_yn <- ifelse(churn,term2$term2_cnt) > 0, 1, 0)
table(churn.term2$term2_yn)

# Term1 기준으로 고객별 Term2 구매정보 추가

churn2 <- merge(churn.term1, chunr.term2, by = "Customer_ID", all.x = T)
table(churn2$term1_yn, churn2$term2_yn)

churn_rate = 832 / (832+1935) * 100  # 이탈율 산출
churn_rate