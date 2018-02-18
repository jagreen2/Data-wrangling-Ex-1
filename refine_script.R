# Load packages
library(dplyr)
library(tidyr)
library(magrittr)

# Read CSV file
mydata = read.csv("refine_original.csv")

# Replace misspelled company names
mydata <- mydata %>% mutate(company = replace(company, company %in% c("Phillips", "phillips","phllips","phillps","phillipS","fillips","phlips"), "philips"), 
                   company = replace(company, company %in% c("Akzo", "AKZO", "akz0","ak zo"), "akzo"), 
                   company = replace(company, company %in% c("Van Houten","van Houten"), "van houten"), 
                   company = replace(company, company %in% c("unilver","Unilever"), "unilever"))

# Parse product codes from product numbers
mydata <- mydata %>% separate(Product.code...number, c("product_code","product_number"), sep = "-", remove = TRUE, convert = FALSE)

# Create new column for product_category, and populate it with values based on the values in product_code
mydata <- mydata %>% mutate(product_category = replace(product_category, product_code == "p", "Smartphone"), 
                              product_category = replace(product_category, product_code == "v", "TV"),
                              product_category = replace(product_category, product_code == "x", "Laptop"),
                              product_category = replace(product_category, product_code == "q", "Tablet"))

# Concatenate 3 address columns into one column
mydata <- mydata %>% unite("full_address", address, city, country, sep = ", ")

# Create dummy columns
mydata <- mydata %>% mutate(company_philips = ifelse(company == "philips", 1, 0))
mydata <- mydata %>% mutate(company_akzo = ifelse(company == "akzo", 1, 0))
mydata <- mydata %>% mutate(company_van_houten = ifelse(company == "van houten", 1, 0))
mydata <- mydata %>% mutate(company_unilever = ifelse(company == "unilever", 1, 0))
mydata <- mydata %>% mutate(product_smartphone = ifelse(product_category == "Smartphone", 1, 0))
mydata <- mydata %>% mutate(product_tv = ifelse(product_category == "TV", 1, 0))
mydata <- mydata %>% mutate(product_laptop = ifelse(product_category == "Laptop", 1, 0))
mydata <- mydata %>% mutate(product_tablet = ifelse(product_category == "Tablet", 1, 0))

