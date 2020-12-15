rm(list = ls())
data= read.csv('M6-NasdaqReturns.csv')

nasm= data.matrix(data[,4:123])
rownames(nasm)= data$StockSymbol
write.csv(nasm,'NasdaqReturnsRedone.csv')

nasm[1:5,1:5]

nasmt= t(nasm)
q = cov(nasmt)

library(reshape2)
q= melt(q)
q[1:5,]

library(RMySQL)
library(dplyr)

rowMeans(nasm)
nasm[1:5,116:120]

r= cbind(rownames(nasm),rowMeans(nasm))
r[1:5,]

test <- r[1:5,]

db<- RMySQL::dbConnect(RMySQL :: MySQL(), dbname= 'nasdaq', username = 'root', password = 'Groot')
dbListTables(db)


library(svMisc)

j = 0 

for (i in 1:nrow(q)){
  print(i)
  dbSendQuery(db, sprintf("insert into cov (stock1, stock2, covarience) values ('%s','%s', %s)",
                          q[i,]$Var1,q[i,]$Var2, q[i,]$value))
}

for (i in 1:nrow(r)) {
  print(i)
  dbSendQuery(db, sprintf("insert into r (stock, meanReturn) values ('%s', %s)", r[i,1],r[i,2]))
  }

dbDisconnect(db)