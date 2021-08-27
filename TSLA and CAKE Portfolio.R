library(quantmod)

#Download the monthly returns
c("TSLA","CAKE") -> ALL

for (SYMBOL in ALL)   {
  getSymbols( SYMBOL , from="2016-8-1" , to="2021-8-1" , auto.assign = F) -> PRICE
  monthlyReturn(PRICE[,6]) -> RETURN
  if( SYMBOL==ALL[1])   { RETURN -> pancake }
  else { cbind(pancake,RETURN) -> pancake }
}

ALL -> colnames(pancake)

head( pancake , 5 )

#Convert the historic data into timeSeries format
library(fPortfolio)

as.timeSeries(pancake) -> PANCAKE
head(PANCAKE,5)

portfolioFrontier(PANCAKE) -> PIE
plot(PIE)

frontierPoints(PIE) -> POINTS
tail(POINTS)

getWeights(PIE) -> WEIGHTS
tail(WEIGHTS)

data.frame(POINTS,WEIGHTS) -> ALL
tail(ALL)

options(scipen=20)

#install.packages("scatterD3")
library(scatterD3)

#ROUND 1*********************************************
scatterD3( x=ALL$targetRisk , y=ALL$targetReturn )

#ROUND 2*********************************************
#Color must be based on HTML color codes
scatterD3( x=ALL$targetRisk , y=ALL$targetReturn , 
           xlab="Std. Dev." , ylab="Exp. Monthly Return" , hover_size=10, color="#F27CB1")

#ROUND 3*********************************************
library(formattable)

paste( "Exp. Monthly Return :" , percent(ALL$targetReturn) ) -> HOVER

tail(HOVER)

#Create the scatterplot
scatterD3( x=ALL$targetRisk , y=ALL$targetReturn ,
           xlab="Std. Dev." , ylab="Exp. Monthly Return" , color="#F27CB1" ,
           hover_size=10 , tooltip_text=HOVER)

#ROUND 4*********************************************
paste( "Exp. Monthly Return :" , percent(ALL$targetReturn) ,
       "Std. Dev. of Returns :" , percent(ALL$targetRisk) ) -> HOVER

#ROUND 5*********************************************
paste( "Exp. Monthly Return :" , percent(ALL$targetReturn) ,
       "<br>Std. Dev. of Returns :" , percent(ALL$targetRisk) ,
       "<br>Tesla Stocks :" , percent(ALL$TSLA)     ) -> HOVER

#ROUND 6*********************************************
paste( "Exp. Monthly Return :" , percent(ALL$targetReturn) ,
       "<br>Std. Dev. of Returns :" , percent(ALL$targetRisk) ,
       "<br>Tesla Stocks :" , percent(ALL$TSLA) ,
       "<br>Cheesecake Stocks :" , percent(ALL$CAKE)  ) -> HOVER
