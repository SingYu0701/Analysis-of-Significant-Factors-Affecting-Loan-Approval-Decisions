#install.packages("readr")
#install.packages("VIM")
#install.packages("car")
#install.packages("MASS")

#input data file
library(readr)
loan_train <- read_csv("loan_train.csv")

#check this data
head(loan_train)
str(loan_train)

#check missing value
sum(is.na(loan_train))

#KNN to deal with missing value
library(VIM)
loan<-kNN(loan_train)
loan <- loan[, 1:12] #刪除kNN判定值
loan <- loan[, -c(3,7,9)] #刪除不理解的變數

#check missing value again
sum(is.na(loan))

#變數解釋
#Gender(x1):貸款申請者的性別
#Married(x2)：貸款者是否已婚
#Education(x3)：申請人是否在學
#Self_Employed(x4)：是否為自僱人士
#Applicant_Income(x5)：申請人年收入
#Loan_Amount(x6)：貸款金額
#Credit_History(x7)：信用歷史，表示申請者之前是否有遵守貸款還款
#Area(x8)：申請人地區
#Status(y)：核准與否

#處理資料類型
loan$Gender<-as.factor(loan$Gender)
loan$Married<-as.factor(loan$Married)
loan$Education<-as.factor(loan$Education)
loan$Self_Employed<-as.factor(loan$Self_Employed)
loan$Credit_History<-as.factor(loan$Credit_History)
loan$Status<-as.factor(loan$Status)
loan$Area<-as.factor(loan$Area)


#敘述統計
summary(loan)

#列聯表
gs<-table(loan$Status, loan$Gender)
gs
prop.table(gs)

ms<-table(loan$Status, loan$Married)
ms
prop.table(ms)

es<-table(loan$Status, loan$Education)
es
prop.table(es)

ss<-table(loan$Status, loan$Self_Employed)
ss
prop.table(ss)

cs<-table(loan$Status, loan$Credit_History)
cs
prop.table(cs)

as<-table(loan$Status, loan$Area)
as
prop.table(as)

#差異性分析

#性別對貸款核准影響結果是否顯著
chisq.test(loan$Gender,loan$Status)#不顯著

#已婚與否對貸款核准影響結果是否顯著
chisq.test(loan$Married,loan$Status)#影響顯著

#是否在學對貸款核准影響結果是否顯著
chisq.test(loan$Education,loan$Status)#影響顯著

#是否為自僱工作者對貸款核准結果影響是否顯著
chisq.test(loan$Self_Employed,loan$Status)#影響不顯著

#信用歷史對貸款核准結果影響是否顯著
chisq.test(loan$Credit_History,loan$Status)#影響顯著

#申請人地區對貸款核准結果影響是否顯著
chisq.test(loan$Area,loan$Status)#影響顯著

#申請貸款總額對貸款核准結果影響是否顯著
la_y<-c()
la_n<-c()
for (i in (1:614)) {
  if (loan$Status[i] == "Y") {
    la_y <- c(la_y, loan$Loan_Amount[i])
  } else {
    la_n <- c(la_n, loan$Loan_Amount[i])
  }
}
summary(la_y)
summary(la_n)
#因為長度不同、且為獨立樣本，我們使用Mann-Whitney U 檢定來判定是否有顯著影響
wilcox.test(la_y,la_n)#借貸金額對審核結果沒有顯著影響

#申請者薪水對貸款核准結果影響是否顯著
aa_y<-c()
aa_n<-c()
for (i in (1:614)) {
  if (loan$Status[i] == "Y") {
    aa_y <- c(aa_y, loan$Applicant_Income[i])
  } else {
    aa_n <- c(aa_n, loan$Applicant_Income[i])
  }
}
summary(aa_y)
summary(aa_n)
#因為長度不同、且為獨立樣本，我們使用Mann-Whitney U 檢定來判定是否有顯著影響
wilcox.test(aa_y,aa_n)#申請者薪水對審核結果沒有顯著影響

#邏輯斯迴歸分析
library(car)
yes<-loan$Status=="Y"
no<-loan$Status=="N"
fit1<-glm(yes/(yes+no) ~ Married+Education+Credit_History+Area,weights=yes+no, family=binomial,data = loan)
fit2<-glm(yes/(yes+no) ~ Married+Education+Credit_History+Area+Married*Credit_History+Area*Credit_History+Married*Area+Education*Married+Education*Credit_History+Education*Area,weights=yes+no, family=binomial,data = loan)
anova(fit1, fit2, test="LRT")

library(MASS)
stepAIC(fit1)
fit3<-glm(yes/(yes+no) ~ Married+Credit_History+Area,weights=yes+no, family=binomial,data = loan)
fit4<-glm(yes/(yes+no) ~ Married+Credit_History+Area+Married*Credit_History+Area*Credit_History+Married*Area,weights=yes+no, family=binomial,data = loan)
anova(fit3, fit4, test="LRT")

#model checking
married<-rep(c("Y","Y","N","N"),3)
history<-rep(c("Y","N","Y","N"),3)
area<-c(rep("urban",4),rep("semi",4),rep("rural",4))
table(loan$Status, loan$Married,loan$Credit_History,loan$Area)
y<-c(92,1,40,0,120,2,55,2,71,1,37,1)
n<-c(21,18,17,13,13,17,14,10,24,20,17,8)
Model_check<-data.frame(married, history, area,y,n)
Model_check
fit5 <- glm(y/(y+n) ~ married+history+area, weights=y+n, family=binomial,data=Model_check)
N<-y+n
fit.yes <-N*fitted(fit5)
fit.no <- N*(1 - fitted(fit5))
data.frame(married, history, area, y, fit.yes, n, fit.no)

fitt.prob<-fitted(fit3)
tt<-c()
tf<-c()
ft<-c()
ff<-c()
for (i in c(1:614)){
  if(fitt.prob[i] >=0.5 && loan$Status[i]=="Y"){
    tt<-c(tt,loan$Status[i])
  }else if(fitt.prob[i]>=0.5 && loan$Status[i]=="N"){
    tf<-c(tf,loan$Status[i])
  }else if(fitt.prob[i]<0.5 && loan$Status[i]=="Y"){
    ft<-c(ft,loan$Status[i])    
  }else{
    ff<-c(ff,loan$Status[i])
    }
}
length(tt)/614
length(tf)/614
length(ff)/614
length(ft)/614
library(pROC)
rocplot <- roc((yes/(yes+no)) ~ fitted(fit3), data=loan)
plot.roc(rocplot, legacy.axes=TRUE)
auc(rocplot)
