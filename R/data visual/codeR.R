library(tidyverse)
library(sqldf)
library(glue)

#explore data
glimpse(mtcars)

mtcars
head(mtcars,3)
tail(mtcars,3)

#glue
#string template
my_name <- "toy"
my_age <- 34

glue("Hello my name is {my_name}, and I'm {my_age} years old")


#sql
#run sql query with R dataframe

sqldf("select * from mtcars where mpg > 30")

sqldf("select am, avg(mpg), sum(mpg) from mtcars group by am")


#tidyverse
#dplyr => data transformation
# 1. select
# 2. filter
# 3. mutate
# 4. arrange
# 5. summarise + gruoup by


# select columns
select(mtcars, mpg, hp, wt)

select(mtcars, contains("a"))

select(mtcars, starts_with("a"))
select(mtcars, ends_with("p"))
select(mtcars, 1,3,5)


# %>% Pip operator
#Data pipeline in R
data()
mtcars %>%
  select(mpg, hp, wt, am) %>%
  filter(mpg > 30 | am==1) %>%
  filter(mpg <20 )
  

mtcars %>%
  rownames_to_column() %>%
  select(model = rowname,
         milePerGallon = mpg,
         horsePower = hp,
         weight = wt) %>%
  head()
#ไม่อยากเขียน function rowบ่อยๆก้ใส่ทับ
mtcars <- mtcars %>%
  rownames_to_column() %>%
  rename(model = rowname)



#filter model names
mtcars %>%
  select(model,mpg,hp,wt)%>%
  filter(grepl("^M",model))

##filter(grepl("n$",model))


#mutate create new columns
df <- mtcars %>%
  select(model, mpg, hp)%>%
  head()%>%
  mutate(mpg_double = mpg*2,
         mpg_log = log(mpg),
         hp_double = hp*2)

#arrange sort data
mtcars %>%
  select(model, mpg, am)%>%
  arrange(am, desc(mpg)) %>%
  head(10)

#mutate create label
# am(0=auto, 1=manual)

mtcars <- mtcars %>%
  mutate(am = ifelse(am==0, "Auto","Manual"))

#create dataframe

df <- data.frame(
  id = 1:5,
  country = c("Thailand","Korea","Japan","USA","Belgium")
)

df %>%
  mutate(region = case_when(
    country %in% c("Thailand","Korea","Japan") ~ "Asia",
    country == "USA" ~ "America",
    TRUE ~ "Europe"
    ))


df2 <- data.frame(id = 6:8,
                  country = c("Germany","Italy", "Sweden"))



df3 <- data.frame(id = 9:10,
                  country = c("Canada", "Malaysia"))


df%>%
  bind_rows(df2)%>%
  bind_rows(df3)

#same answeras above
list_df <- list(df, df2, df3)
full_df = bind_rows(list_df)


full_df 


full_df %>%
  mutate(region = case_when(
    country %in% c("Thailand","Korea","Japan","Malaysia") ~ "Asia",
    country %in% c("Canada", "USA") ~ "America",
    TRUE ~ "Europe"
  ))

#case when in SQL
sqldf("select *, case
              when country in ('USA', 'Canada') then 'America'
              when country in ('Thailand','Korea','Japan','Malaysia') then 'Asia'
              else 'Europe'
              end as region
              from full_df
      ")



result <- mtcars %>%
  mutate(vs = ifelse(vs==0,"v-shaped","straight"))%>%
  group_by(am, vs)%>%
  summarise(avg_mpg = mean(mpg),
            sum_mpg = sum(mpg),
            min_mpg = min(mpg),
            max_mpg = max(mpg),
            n = n()) #count
View(result)

write_csv(result, "result.csv")
read_csv("result.csv")


#missing values
# NA (not available)

v1 <- c(5, 10, 14, NA, 25)
is.na(v1)

data("mtcars")
mtcars[5,1] <- NA


mtcars %>%
  filter(is.na(mpg))

mtcars %>%
  select(mpg, hp, wt)%>%
  filter(is.na(mpg))


mtcars %>%
  select(mpg, hp, wt)%>%
  filter(!is.na(mpg))

mtcars %>%
  summarise(avg_mpg = mean(mpg))


mtcars %>%
  summarise(avg_mpg = mean(mpg, na.rm = TRUE))

mtcars %>%
  filter(!is.na(mpg))%>%
  summarise(avg_mpg = mean(mpg, na.rm = TRUE))

mean_mpg <- mtcars %>%
  summarise(avg_mpg = mean(mpg, na.rm = TRUE)) %>%
  pull()


mtcars %>%
  select(mpg) %>%
  mutate(mpg2 = replace_na(mpg, mean_mpg))


#loop over dataframe

data("mtcars")
# 1 =row, 2=column
apply(mtcars, MAGIN = 2, mean)

apply(mtcars, 2, sum)

#join dataframe
# standard join inASQL
#inner, left, right, full

band_members
band_instruments

left_join(band_members, band_instruments, by = "name")

band_members %>%
  left_join(band_instruments, by = "name")

band_members %>%
  rename(memberName = name) -> band_members2

#case different name column
band_members2 %>%
  left_join(band_instruments, by = c("memberName"= "name"))


library(nycflights13)

glimpse(flights)


flights %>%
  filter(year == 2013 , month == 9) %>%
  count(carrier) %>%
  arrange(-n)%>%
  head(5)%>%
  left_join(airlines, by='carrier')

  
library(rvest)
library(tidyverse)

#Static Website

url <- "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"

url%>%
  read_html()%>%
  html_nodes("h3")%>%
  html_text2() #text2 clean data

movie_name <- url%>%
  read_html()%>%
  html_elements("h3.lister-item-header")%>%
  html_text2() #text2 clean data
movie_name


rating <- url%>%
  read_html()%>%
  html_elements("div.ratings-imdb-rating")%>%
  html_text2()%>% #text2 clean data
  as.numeric()


votes <- url%>%
  read_html()%>%
  html_elements("p.sort-num_votes-visible")%>%
  html_text2() #text2 clean data
  
df <- data_frame(movie_name,rating, votes)

View(df)

df %>%
  separate(votes,sep=" | ", into = c("votes","gross","tops"))%>%
  View()

#HW IMDB
#HW static website