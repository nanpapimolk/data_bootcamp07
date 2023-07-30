library(tidyverse)
library(RSQLite) #DBI
library(RPostgreSQL)
library(lubridate)
library(janitor) #clean data

#connect database

con <- dbConnect(SQLite(), "chinook.db")

#list table name
dbListTables(con)

#List fileds(column) in a table

dbListFields(con, "customers")

#write SQL queries
df<- dbGetQuery(con,"select * from customers limit 10")

df %>%
  select(FirstName)

df <- clean_names(df) #change column name into lowecasewith _


##write join syntax

df2 <- dbGetQuery(con, "select * from albums, artists
                 where albums.artistId = artists.artistId") %>%
  clean_names()

View(df2)

#write a table
dbWriteTable(con,"cars",mtcars)
dbListTables(con)

dbGetQuery(con,"select * from cars limit 5")


#drop table
dbRemoveTable(con,"cars")

#close connect dbDisConnect
dbDisconnect(con)




-----------------------------------------------------------------------

data()
  
  
## data visual
## ggplot => grammar of graphic

## base R visualization
#pch = plot character, col = color
plot(mtcars$mpg, mtcars$hp, pch = 16, col = "red")

#dataframe $ with column
boxplot(mtcars$mpg)

t1 <- table(mtcars$am)
barplot(t1)

hist(mtcars$mpg)

#base R ไม่ค่อยสวยเลยใช้ ggplot

#maaping เอาcolumn map element of chart// +render chart  mapp layer
#one variable numeric
ggplot(data = mtcars,
       mapping = aes(x = mpg)) +
         geom_histogram(bins = 10)

ggplot(data = mtcars, mapping = aes(x=mpg)) +
  geom_density()

#freqpoly ลากจุดเชื่อม
ggplot(data = mtcars, mapping = aes(x=mpg))+
  geom_freqpoly()

#ไม่ต้องใส่data mapping
p1 <- ggplot(mtcars, aes(mpg))+
  geom_histogram(bins = 5)

p2 <- ggplot(mtcars, aes(hp))+
  geom_histogram(bins=10)



mtcars %>%
  filter(hp <= 200) %>%
  count()



## summary table before make bar chart

mtcars <- mtcars %>%
  mutate(am = ifelse(am==0, "Auto", "Manual"))


# approach 01 - summary table + gem_col()

t2 <- mtcars %>%
  mutate(am = ifelse(am==0, "Auto", "Manual"))%>%
  count(am)

ggplot(t2, aes(am, n))+
  geom_col()


#approach 02 - geom_bar()
ggplot(mtcars, aes(am))+
  geom_bar()



## two variables ,numeric
## scatter plot


ggplot(mtcars, aes(hp, mpg))+
  geom_point(col="red", size = 5)









