
# Load required libraries
library(pROC)
library(caret)
library(pROC)
library(caret)
library(ggplot2)
library(reshape2)
library(dplyr)
#import the data 
df<-read.csv("C:\\Users\\LENOVO\\Desktop\\CLASSES\\Dhuvrik\\Data analytic\\presentation\\diabetes.csv")

# first five  row
head(df)

# Check for missing values
colSums(is.na(df))

# View dataset structure
str(df)

# Replace zero values with NA for relevant columns
zero_columns <- c("Glucose", "BloodPressure", "SkinThickness", "Insulin", "BMI")
df[zero_columns] <- lapply(df[zero_columns], function(x) ifelse(x == 0, NA, x))

# Impute missing values using median
for (col in zero_columns) {
  df[[col]][is.na(df[[col]])] <- median(df[[col]], na.rm = TRUE)
}
#Exploratory Data Analysis (EDA
# Summary statistics of the dataset
summary_stats <- summary(df)
print(summary_stats)
# Distribution of Outcome Variable
ggplot(df, aes(x = factor(Outcome))) +
  geom_bar(fill = c("blue", "red")) +
  labs(title = "Distribution of Outcome Variable", x = "Diabetes Outcome", y = "Count") +
  theme_minimal()

# Boxplots for Continuous Variables
df_melt <- melt(df, id.vars = "Outcome")
ggplot(df_melt, aes(x = factor(Outcome), y = value, fill = factor(Outcome))) +
  geom_boxplot() +
  facet_wrap(~variable, scales = "free") +
  labs(title = "Boxplots of Features by Outcome", x = "Diabetes Outcome", y = "Value") +
  theme_minimal()


# Correlation Heatmap
cor_matrix <- cor(df[, -9])  # Exclude Outcome column
melted_cor <- melt(cor_matrix)
ggplot(melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1,1)) +
  theme_minimal() +
  labs(title = "Feature Correlation Heatmap", x = "", y = "")



#Building model

set.seed(123)  # For reproducibility
library(caret)

# Split data into training (80%) and testing (20%)
trainIndex <- createDataPartition(df$Outcome, p = 0.8, list = FALSE)
trainData <- df[trainIndex, ]
testData <- df[-trainIndex, ]

# Train logistic regression model
log_model <- glm(Outcome ~ ., data = trainData, family = binomial)

# Summary of the model
summary(log_model)
# Predict probabilities
pred_probs <- predict(log_model, testData, type = "response")

# Convert probabilities to binary outcome (threshold = 0.5)
predictions <- ifelse(pred_probs > 0.5, 1, 0)

# Evaluate accuracy
conf_matrix <- table(Predicted = predictions, Actual = testData$Outcome)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)

# Print results
print(conf_matrix)
print(paste("Accuracy:", round(accuracy * 100, 2), "%"))


# Confusion Matrix Visualization
conf_matrix_df <- as.data.frame(as.table(conf_matrix))
colnames(conf_matrix_df) <- c("Actual", "Predicted", "Freq")

ggplot(conf_matrix_df, aes(x = Predicted, y = Actual, fill = Freq)) +
  geom_tile(color = "white") +
  geom_text(aes(label = Freq), vjust = 1) +
  scale_fill_gradient(low = "lightblue", high = "blue") +
  labs(title = "Confusion Matrix Heatmap", x = "Predicted", y = "Actual") +
  theme_minimal()

# ROC Curve Visualization
roc_obj <- roc(testData$Outcome, pred_probs)

ggplot(data.frame(fpr = rev(roc_obj$specificities), tpr = rev(roc_obj$sensitivities)), aes(x = fpr, y = tpr)) +
  geom_line(color = "blue", size = 1) +
  geom_abline(linetype = "dashed", color = "gray") +
  labs(title = "ROC Curve", x = "False Positive Rate", y = "True Positive Rate") +
  theme_minimal() +
  annotate("text", x = 0.6, y = 0.2, label = paste("AUC =", round(auc(roc_obj), 2)), size = 5, color = "red")