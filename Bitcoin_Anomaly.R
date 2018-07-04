library(dplyr)
library(ggplot2)
library(anomalize)
library(tidyverse)
library(tibbletime)
library(lubridate)

data = read_csv("all_currencies.csv")

timeSeriesBTC = data%>%
  filter(Symbol == "BTC")%>%
  select(-X1)

BTC_anomalised = timeSeriesBTC%>%
  time_decompose(Close)%>%
  anomalize(remainder)%>%
  time_recompose()

BTC_anomalised%>% glimpse()


p1 = BTC_anomalised %>%
  plot_anomaly_decomposition() +
  ggtitle("Plot/Auto")

timeSeriesBTC_2017 = timeSeriesBTC%>%
  mutate(Year = year(Date))%>%
  filter(Year >= 2017)

BTC_anomalised_2017 = timeSeriesBTC_2017%>%
  time_decompose(Close)%>%
  anomalize(remainder)%>%
  time_recompose()
 

p2 = BTC_anomalised_2017%>%
  plot_anomaly_decomposition()+
  ggtitle("For year 2017&2018")



timeSeriesBTC_2016 = timeSeriesBTC%>%
  mutate(Year = year(Date))%>%
  filter(Year >= 2016)

BTC_anomalised_2016 = timeSeriesBTC_2016%>%
  time_decompose(Close)%>%
  anomalize(remainder)%>%
  time_recompose()


p3 = BTC_anomalised_2016%>%
  plot_anomaly_decomposition()+
  ggtitle("For year 2016-18")


p4 = timeSeriesBTC_2016%>%
  time_decompose(Close, frequency = "auto", trend = "2 weeks")%>%
  anomalize(remainder)%>%
  time_recompose()%>%
  plot_anomaly_decomposition()+
  ggtitle("Trend = 2 Weeks ")

