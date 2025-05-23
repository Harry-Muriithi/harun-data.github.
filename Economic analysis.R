# Load required libraries
library(rio)
library(dplyr)
library(tidyr)
library(janitor)
library(ggplot2)

# Step 1: Import the data
Economic_data <- import("C:\\Users\\LENOVO\\Desktop\\Economics job\\Data comp.xlsx")
head(Economic_data)
summary(Economic_data)


# Step 2: Clean column names (removes spaces, converts to snake_case)
Economic_data <- clean_names(Economic_data)

# Step 3: Rename "index_year" column to just "year" since it only contains years
Economic_data <- Economic_data %>%
  rename(year = index_year)

# Step 4: Plot GDP per capita over time by country
ggplot(Economic_data, aes(x = year, y = gdp_per_capital, color = country)) +
  geom_line(size = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "GDP per Capita Over Time (2001–2021)",
    x = "Year",
    y = "GDP per Capita (USD)"
  ) +
  theme_minimal()



#Regress the Total Index on GDP per Capita
# Create a new variable for the total index as the average of the four indicators
Economic_data <- Economic_data %>%
  mutate(total_index = (property_rights + tax_burden + business_freedom + trade_freedom) / 4)

# 1. Regression: Total Index on GDP per Capita
model_total <- lm(gdp_per_capital ~ total_index, data = Economic_data)
summary(model_total)

# 2. Regression: Each individual index on GDP per Capita
model_property <- lm(gdp_per_capital ~ property_rights, data = Economic_data)
summary(model_property)

model_tax <- lm(gdp_per_capital ~ tax_burden, data = Economic_data)
summary(model_tax)

model_business <- lm(gdp_per_capital ~ business_freedom, data = Economic_data)
summary(model_business)

model_trade <- lm(gdp_per_capital ~ trade_freedom, data = Economic_data)
summary(model_trade)

