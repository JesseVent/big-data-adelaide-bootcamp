#   ____________________________________________________________________________
#   Load packages and data                                                  ####

library(readr)
library(ggplot2)
library(tidyverse)
library(ggthemes)
library(scales)
library(randomForest)
library(party)
library(caret)
car_train <- read_csv("Downloads/car_train.csv",
                      col_types = cols(
               acquisition_date = col_skip()))
car_test  <- read_csv("Downloads/car_submission.csv",
                      col_types = cols(
               acquisition_date = col_skip()))

#   ____________________________________________________________________________
#   Exploring Car Training Data                                             ####

str(car_train)
summary(car_train)

# Check target variable
ggplot(na.omit(car_train), aes(x = make, y = price, fill = factor(make))) +
  geom_boxplot() +
  geom_hline(
    aes(yintercept = 58000),
    colour         = 'red',
    linetype       = 'dashed',
    lwd            = 2
  ) +
  scale_y_continuous(labels = dollar_format()) +
  theme_fivethirtyeight()

# Remove outliers and recheck distribution
car_train$price <-
  ifelse(car_train$price >= 100000, NA, car_train$price)
ggplot(na.omit(car_train), aes(x = model, y = price, fill = factor(model))) +
  geom_boxplot() +
  scale_y_continuous(labels = dollar_format()) +
  theme_fivethirtyeight()
## Note how RAV4 look odd.. lets do some research on values of them for 2018 year.

# Add new rule for RAV4 and check disribution
car_train$price <-
  ifelse((car_train$price >= 50000) & (car_train$model == 'RAV4'),
         NA,
         car_train$price)
ggplot(na.omit(car_train), aes(x = model, y = price, fill = factor(model))) +
  geom_boxplot() +
  scale_y_continuous(labels = dollar_format()) +
  theme_fivethirtyeight()

#   ____________________________________________________________________________
#   Data exploration and feature analysis                                   ####

# Creating target variable on test dataset to be able to combine train/test data
car_test$price <- NA
car_all        <- rbind(car_train, car_test)

# View structure and NA records
summary(car_all)
sapply(car_all, function(x) {
  sum(is.na(x))
})
sapply(car_all, function(x) {
  if (is.character(x)) {
    table(x)
  }
})

# View makes and model
ggplot(data = car_all, aes(x = model, fill = make)) + geom_bar(stat = "count") +   theme_fivethirtyeight()

# View body types and standardise using subject knowledge.
table(car_all$model, car_all$body_type)
car_all$body_type[car_all$model       == 'Impreza' &
                    car_all$body_type == 'Wagon']    <- 'Hatch'
car_all$body_type[car_all$model       == 'RAV4']     <- 'SUV'
car_all$body_type[car_all$model       == 'Forester'] <- 'SUV'
ggplot(data = car_all, aes(x = body_type, fill = body_type)) +
  geom_bar(stat = "count") +
  facet_wrap(. ~ model) +
  theme_fivethirtyeight()

# View range of colours and standardise to remove noise.
table(car_all$colour)
car_all$colour <- gsub('/', '', car_all$colour)
car_all$colour[car_all$colour %in% c(
  'cloth',
  'Beige',
  'Brown',
  'Champagne',
  'Dune',
  'Sandstone',
  'Deep Cherry',
  'Envy',
  'Glacier',
  'Hazel',
  'Inferno',
  'Magenta',
  'Metal Storm',
  'Purple',
  'Yellow',
  'Other',
  'Ink'
)] <- 'Other'
ggplot(data = car_all, aes(x = colour, fill = colour)) +
  geom_bar(stat = "count") +
  theme_fivethirtyeight()

# View range of categories and standardise.
table(car_all$category)
car_all$category[car_all$category %in% c('Other', 'Other2')] <- 'Other'
car_all$category[is.na(car_all$category)]                    <- 'Other'
ggplot(data = car_all, aes(x = year, fill = model)) +
  geom_bar(stat = "count") +
  facet_wrap(. ~ category) +
  theme_fivethirtyeight()


# Impute numerical values
summary(all$Age)
Agefit <-
  rpart(
    Age ~ Employment + Education + Marital + Occupation + Income + Gender + Deductions + Hours,
    data   = df[!is.na(df$Age), ],
    method = "anova"
  )
df$Age[is.na(df$Age)] <- predict(Agefit, df[is.na(df$Age), ])

sapply(df, function(x) {
  sum(is.na(x))
})

# Factorise categoric variables
sapply(car_all, function(x) {
  if (is.character(x)) { as.factor(x) }
})

# Automated feature engineering/importance
library(bounceR)
test_ge <- featureSelection(
  data           = train.full.dt,
  target         = "target",
  index          = "ID",
  selection      = selectionControl(
    n_rounds     = 1000,
    n_mods       = 100,
    p            = 100,
    penalty      = 0.2,
    reward       = 0.1
  ),
  bootstrap      = "regular",
  early_stopping = "none",
  parallel       = TRUE
)

# Split back into datasets
trainClean <- car_all_ftr[!is.na(car_all_ftr$price), ]
testClean  <- car_all_ftr[is.na(car_all_ftr$price), ]




### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Random Forest Model                                                     ####
set.seed(415)
rf <- randomForest(formula,
               data       = trainClean,
               importance = TRUE,
               ntree      = 5000)
varImpPlot(rf)
rf_prediction <- predict(rf, testClean, OOB = TRUE, type = "response")

### . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . ..
### Conditional Inference Random Forest                                     ####
crf <- cforest(formula,
          data     = trainClean,
          controls = cforest_unbiased(
            ntree  = 2000,
            mtry   = 3))
varImpPlot(crf)
crf_prediction <- predict(crf, testClean, OOB = TRUE, type = "response")
