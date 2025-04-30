# Importing all necessary libraries first
library('corrplot')
library('VIM')
library('dplyr')
library('naniar')
library('MASS')
library('e1071')

###################################################################################
#######################   Gas Turbine Emissions Analysis	#######################
###################################################################################

# Loading gas turbine co and nox emission datasets
	gt_2011 <- read.csv(file.choose(), header=T)
	gt_2012 <- read.csv(file.choose(), header=T)
	gt_2013 <- read.csv(file.choose(), header=T)
	gt_2014 <- read.csv(file.choose(), header=T)
	gt_2015 <- read.csv(file.choose(), header=T)

# Merging gas turbine co and nox emission datasets in one set
	gt_data <- rbind(gt_2011, gt_2012, gt_2013, gt_2014, gt_2015)
	summary(gt_data)
	str(gt_data)

# Check for missing values
	# 1) Graphically
	vis_miss(gt_data)
# => Graphical representation proves the data is 100% present
	# 2) Numerically
	mean(is.na(gt_data))
# => The function returns 0 which further proves there is no missing value


# Check for outliers
	scaled_gt_data <- scale(gt_data)
	boxplot(scaled_gt_data)
# => We scale the data in order to view all outliers on the same scale.
# => The graph proves that every single variable has outliers 

# Outlier Imputation
# Function to detect and impute outliers using median to not affect data
	flag_outliers_na <- function(column) {
	Q1 <- quantile(column, 0.25) 
	Q3 <- quantile(column, 0.75) 
	IQR <- Q3 - Q1                             
	lower_bound <- Q1 - 1.5 * IQR
	upper_bound <- Q3 + 1.5 * IQR
	column[column < lower_bound | column > upper_bound] <- NA
	return(column)
	}
# Apply on all columns
	gt_data_na <- as.data.frame(lapply(gt_data, flag_outliers_na))
	summary(gt_data_na)

# Impute with KNN
	gt_data_prep <- kNN(gt_data_na)
	summary(gt_data_prep)

# Remove the columns that have '_imp' suffix
	gt_data_prep_clean <- gt_data_prep[, !grepl("_imp", colnames(gt_data_prep))]

# Check the cleaned data
	summary(gt_data_prep_clean)

# We will check relationships and correlation between variables with our
# cleaned data in order to understand the linearity

# Check relation between independant variables and target CO graphically
# CO and Ambient Temperature
	plot(
  	x = gt_data_prep_clean$AT, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Ambient Temperature",
  	xlab = "Ambient Temperature", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ AT, data = gt_data_prep_clean), col = "red")

# => We can tell CO and AT aren't related because the points are loosely scattered
	
# CO and Ambient Pressure
	plot(
  	x = gt_data_prep_clean$AP, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Ambient Pressure",
  	xlab = "Ambient Pressure", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ AP, data = gt_data_prep_clean), col = "red")

# => We can tell CO and AP aren't related because the points are loosely scattered
	
# CO and Ambient Humidity
	plot(
  	x = gt_data_prep_clean$AH, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Ambient Humidity",
  	xlab = "Ambient Humidity", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ AH, data = gt_data_prep_clean), col = "red")

# => We can tell CO and AH aren't related because the points are loosely scattered
	
# CO and Air Filter Difference Pressure
	plot(
  	x = gt_data_prep_clean$AFDP, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Air Filter Difference Pressure",
  	xlab = "Air Filter Difference Pressure", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ AFDP, data = gt_data_prep_clean), col = "red")

# => As the x-axis variable increases, the y-axis variable decreases.
#    We can tell CO and AFDP have a negative relationship
	
# CO and Gas Turbine Exhaust Pressure
	plot(
  	x = gt_data_prep_clean$GTEP, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Gas Turbine Exhaust Pressure",
  	xlab = "Gas Turbine Exhaust Pressure", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ GTEP, data = gt_data_prep_clean), col = "red")

# => As the x-axis variable increases, the y-axis variable decreases.
#    We can tell CO and GTEP have a negative relationship

# CO and Turbine Inlet Temperature
	plot(
  	x = gt_data_prep_clean$TIT, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Turbine Inlet Temperature",
  	xlab = "Turbine Inlet Temperature", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ TIT, data = gt_data_prep_clean), col = "red")
	
# => As the x-axis variable increases, the y-axis variable decreases.
#    We can tell CO and TIT have a negative relationship

# CO and Turbine After Temperature
	plot(
  	x = gt_data_prep_clean$TAT, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Turbine After Temperature",
  	xlab = "Turbine After Temperature", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ TAT, data = gt_data_prep_clean), col = "red")

# => We can tell CO and TAT aren't related because the points are loosely scattered

# CO and Compressor Discharge Pressure
	plot(
  	x = gt_data_prep_clean$CDP, 
  	y = gt_data_prep_clean$CO, 
  	main = "Scatterplot of CO vs Compressor Discharge Pressure",
  	xlab = "Compressor Discharge Pressure", 
  	ylab = "CO",
  	pch = 16,           
  	col = "blue"        
	)
	abline(lm(CO ~ CDP, data = gt_data_prep_clean), col = "red")
# => As the x-axis variable increases, the y-axis variable decreases.
#    We can tell CO and CDP have a negative relationship

# => We can conclude that CO emissions increase with the decrease of AFDP
#    GTEP, TIT and CDP 

# Check for the distribution of all variables
	par(mfrow = c(3, 4))  # Set up a 3x4 grid for the plots
	for (col in names(gt_data_prep_clean)) {
  		hist(
    			gt_data_prep[[col]], 
    			main = paste("Histogram of", col), 
    			xlab = col, 
    			col = "skyblue", 
    			border = "white"
  			)
	}
	par(mfrow = c(1, 1))  # Reset plotting layout

# => We can remark that a few of our variables don't follow a normal distribution

# Variable normality test 
# 1) Skewness and Kurtosis
# We use skewness and kurtosis since our sample has more than 5000 entries

	skewness_values <- sapply(gt_data_prep_clean, skewness)  
	kurtosis_values <- sapply(gt_data_prep_clean, kurtosis)
	skewness_values
	kurtosis_values

# => Most of our variables are close to symmetric (~0) or have mild skewness except TAT 
# => Most of our variables have low kurtosis < 3 except TAT who's kurtosis > 4

# 2) Kolmogorov-Smirnov test 
	for (var in names(gt_data_prep_clean)) {
  	ks_result <- ks.test(gt_data_prep[[var]], "pnorm", mean(gt_data_prep[[var]]), sd(gt_data_prep[[var]]))
  	cat("\nK-S Test result for", var, ":\n")
  	print(ks_result)
	}

# => In conclusion, given the very small p-values (all < 2.2e-16), none of the variables 
# => in our dataset follow a normal distribution.

# Check coefficient relation between independant variables and target CO 
# We will use Spearman instead of Pearson because it doesn't need normality.
	cor_matrix <- cor(gt_data_prep_clean, method = "spearman")
	corrplot::corrplot(cor_matrix, method = "number", type = "upper")

# => As a matter of fact, TIT has the strongest relationship with CO (-0.59)
# => followed by CDP, TEY, GTEP and AFDP, whereas NOX only has a strong 
# => relationship with AT (-0.6) meaning as temperature decreases, NOX increases.
# => However, GTEP, TIT, TEY and CDP have strong relationships with each other
# => They provide the same information and we need to remove some variables.
# => We remove CDP and TEY because they have the strongest multicolinearility problem.

	gt_data_1 <- gt_data_prep_clean[, !(colnames(gt_data_prep_clean) %in% c("CDP", "TEY"))]
	cor_matrix1 <- cor(gt_data_1, method = "spearman")
	corrplot::corrplot(cor_matrix1, method = "number", type = "upper")

# Linear Regression Analysis
# Regress CO according to other variables in the sample.

# Before, we will normalize our dataset (using Z-score) 
	standardized_data <- as.data.frame(scale(gt_data_1))

# Full model with all predictors
full_model <- lm(CO ~ AT + AP + AH + AFDP + GTEP + TIT + TAT + NOX, data = standardized_data)
summary(full_model)

# Perform stepwise regression
stepwise_model <- stepAIC(full_model, direction = "both", trace = TRUE)

# View the final model summary
	summary(stepwise_model)

# => AT was removed in stepwise regression since it had a ' ' significance code 
# => meaning the p-value is over our risk of 5%
# => p-value of F-statistic < 5% which means our intercept and coefficients
# => do in fact reflect the reality (coeff != 0)

residuals <- resid(stepwise_model)
summary(residuals)

# Normality of residuals
# Graphically 
# 1) Histogram 
	hist(residuals, main = "Histogram of Residuals",
     	xlab = "Residuals", col = "lightblue", border = "white")
# 2) qqplot
	qqnorm(residuals, main="Normal Q-Q Plot")
	qqline(residuals, col="red")  # Add a reference line
# => The residuals seem to follow a normal distribution which is a good sign

# Numerically  
# 1) Skewness and Kurtosis
	resid_skewness <- skewness(residuals)
	resid_kurtosis <- kurtosis(residuals)
	resid_skewness # it's close to 0 meaning it's symmetric
	resid_kurtosis # it's less than 3 meaning it's lightly tailed since we imputed outliers

# => R-squared = 0.4216 which means our model explains ~42% of the variance 
# in the dependent variable (CO emissions).
# However if we check the data before outlier imputation
	model_before <- lm(gt_data$CO~.,data=gt_data)
	stepwise_before <- stepAIC(model_before, direction = "both", trace = TRUE)
	summary(stepwise_before)

# => The R-squared is considerably higher
# => This doesn't necessarily mean the model with outliers explained ~57% of CO
# => variance since the extreme outliers impacted the results.

# In a nutshell, the decrease of certain factors (AFDP, GTEP, TIT, TAT) are key 
# drivers of increased CO emissions in gas turbines.
# NOX emissions increase the lower Ambient Temperature is. 
# Although the model only explains ~42% of the variance in CO emissions, 
# further research could explore additional factors or refine the model to 
# improve predictive accuracy.
# Outlier imputation was critical in obtaining more stable and realistic results.

###################################################################################
#########################   ai4i Maintenance Analysis     #########################
###################################################################################

# Loading ai4i 2020 predictive maintenance dataset
	ai4i2020 <- read.csv(file.choose(), header=T)
	colnames(ai4i2020) <- c("UDI", "Product_ID", "Type", "Air_Temperature",
	"Process_Temperature", "Rotational_Speed", "Torque", "Tool_Wear",
	"Machine_Failure", "TWF", "HDF", "PWF", "OSF", "RNF")
	summary(ai4i2020)
	str(ai4i2020)

# Check for missing values
	# 1) Graphically
	vis_miss(ai4i2020)
# => Graphical representation proves the data is 100% present
	# 2) Numerically
	mean(is.na(ai4i2020))
# => The function returns 0 which further proves there is no missing value

# Check for outliers
	ai4i_selected <- ai4i2020[, c("Air_Temperature", "Process_Temperature"
	,"Rotational_Speed", "Torque", "Tool_Wear")]
	scaled_ai4i_num <- scale(ai4i_selected)
	boxplot(scaled_ai4i_num)
# => The graph proves that Rotational speed and Torque have outliers

# We will impute these outliers with kNN
	ai4i_na <- ai4i2020
	ai4i_na$Rotational_Speed <- flag_outliers_na(ai4i_na$Rotational_Speed)
	ai4i_na$Torque <- flag_outliers_na(ai4i_na$Torque)
	summary(ai4i_na)
	ai4i_prep <- kNN(ai4i_na)

# Remove the columns that have '_imp' suffix
	ai4i_prep_clean <- ai4i_prep[, !grepl("_imp", colnames(ai4i_prep))]
	summary(ai4i_prep_clean)
	names(ai4i_prep_clean)
	attach(ai4i_prep_clean)

# Check the distribution of Air Temperature, Process Temperature, Rotational Speed
# Torque and Tool Wear

	num_cols <- c("Air_Temperature", "Process_Temperature", "Rotational_Speed", "Torque", "Tool_Wear")
	
	par(mfrow = c(2, 3))  # Set up a 2x3 grid for the plots
	for (col in num_cols) {
  		hist(
    			ai4i_prep_clean[[col]], 
    			main = paste("Histogram of", col), 
    			xlab = col, 
    			col = "skyblue", 
    			border = "white"
  			)
	}
	par(mfrow = c(1, 1))  # Reset plotting layout

# Torque follows approximately a normal distribution, Rotational speed's distribution
# is positively skewed whereas the other don't follow a normal distribution

# Association between Type and Machine Failure
	table_quality_failure <- table(Type, Machine_Failure)
	table_quality_failure
	margin.table(table_result, 2)
	chisq.test(table_quality_failure)

# => p-value = 0.001032 < 0.05, the association between Product Type and
# Machine Failure is statistically significant.

# Association between Rotational Speed and Type

# Normality Tests for Rotational speed
# 1) Graphically
# Q-Q Plot for Rotational Speed
qqnorm(Rotational_Speed)
qqline(Rotational_Speed, col = "red")
# => The plot showcases deviations in the upper and lower sides suggesting skewness

# 2) Numerically
# Kolmogorov-Smirnov Test for Rotation speed's normality
# Kolmogorov-Smirnov Test for Rotational Speed by Type (Low)
	ks_low <- ks.test(Rotational_Speed[Type == "L"], "pnorm", 
                  mean(Rotational_Speed[Type == "L"]), 
                  sd(Rotational_Speed[Type == "L"]))

# Kolmogorov-Smirnov Test for Rotational Speed by Type (Medium)
	ks_medium <- ks.test(Rotational_Speed[Type == "M"], "pnorm", 
                     mean(Rotational_Speed[Type == "M"]), 
                     sd(Rotational_Speed[Type == "M"]))

# Kolmogorov-Smirnov Test for Rotational Speed by Type (High)
	ks_high <- ks.test(Rotational_Speed[Type == "H"], "pnorm", 
                   mean(Rotational_Speed[Type == "H"]), 
                   sd(Rotational_Speed[Type == "H"]))

# Print results
	ks_low
# => p-value < 2.2e-16 < 5% 
	ks_medium
# =>  p-value = 2.206e-10 < 5% 
	ks_high
# =>  p-value = 2.206e-10 < 5% 
# We can conclude that Rotational Speed doesn't follow a normal distribution in any
# of the categories


# Test for intra-group variance - significant difference
# Since normality is not met, we can't use ANOVA we'll use its non-parametric
# alternative kruskal-wallis since Type has 3 categories (H, L , M)
	kruskal_result <- kruskal.test(Rotational_Speed ~ Type, data = ai4i_prep_clean)
	print(kruskal_result)

# => p-value = 0.8498 > 5% meaning there is not a statistically significant difference 
# among the three variant quality products in relation to the rotational speed

# Association between Rotational Speed and Machine Failure
# Kolmogorov-Smirnov Test for Rotational Speed by Machine Failure (No)
	ks_no_failure <- ks.test(Rotational_Speed[Machine_Failure == 0], "pnorm", 
                         mean(Rotational_Speed[Machine_Failure == 0]), 
                         sd(Rotational_Speed[Machine_Failure == 0]))

# Kolmogorov-Smirnov Test for Rotational Speed by Machine Failure (Yes)
	ks_yes_failure <- ks.test(Rotational_Speed[Machine_Failure == 1], "pnorm", 
                          mean(Rotational_Speed[Machine_Failure == 1]), 
                          sd(Rotational_Speed[Machine_Failure == 1]))

# Print results
	ks_no_failure
# => p-value < 2.2e-16 < 5%
	ks_yes_failure
# =>  p-value = 5.486e-11 < 5%
# We can conclude that Rotational Speed doesn't follow a normal distribution whether
# there's machine failure or not

# Test for intra-group variance - significant difference
# Since normality is not met, we can't use T-Test we'll use its non-parametric
# alternative Wilcoxon-Mann-Whitney since Machine Failure has 2 categories (0,1)

# Wilcoxon-Mann-Whitney Test for Rotational Speed by Machine Failure
	wilcoxon_result <- wilcox.test(Rotational_Speed ~ Machine_Failure, data = ai4i_prep_clean)

# Display the result
	print(wilcoxon_result)

# => p-value < 2.2e-16 < 5% : Rotational Speed significantly differs between 
# machines that failed vs. those that did not fail.

# Association between Rotational Speed and Tool Wear Failure
# Kolmogorov-Smirnov Test for Rotational Speed by Tool Wear Failure (No)
	ks_twf_no_failure <- ks.test(Rotational_Speed[TWF == 0], "pnorm", 
                         mean(Rotational_Speed[TWF == 0]), 
                         sd(Rotational_Speed[TWF == 0]))

# Kolmogorov-Smirnov Test for Rotational Speed by Tool Wear Failure (Yes)
	ks_twf_yes_failure <- ks.test(Rotational_Speed[TWF == 1], "pnorm", 
                          mean(Rotational_Speed[TWF == 1]), 
                          sd(Rotational_Speed[TWF == 1]))

# Print results
	ks_twf_no_failure
# => p-value < 2.2e-16 < 5%
	ks_twf_yes_failure
# =>  p-value = 0.6761 > 5%
# We can conclude that Rotational Speed doesn't follow a normal distribution when 
# there's no TWF but follows a normal distribution when there's TWF

# Test for intra-group variance - significant difference
# Since normality is met for Rotational Speed during a Tool Wear Failure, let's check homogeneity
	bartlett.test(Rotational_Speed ~ TWF, data = ai4i_prep_clean)
ç# => p-value = 0.7532 > 5% that means homogeneity is met : variances are equal
# Thus we can run a T-Test 
	t.test(Rotational_Speed ~ TWF, data = ai4i_prep_clean)
# =>  p-value = 0.7073 : there is no significant difference in Rotational Speed between 
# machines with and without Tool Wear Failure.

# Since normality is not met when there's no TWF, we can't use T-Test we'll use its non-parametric
# alternative Wilcoxon-Mann-Whitney since Tool Wear Failure has 2 categories (0,1)

# Wilcoxon-Mann-Whitney Test for Rotational Speed by Machine Failure
	wilcoxon_result <- wilcox.test(Rotational_Speed ~ TWF , data = ai4i_prep_clean)

# Display the result
	print(wilcoxon_result)

# => p-value = 0.7059 > 5% : this confirms there is no significant difference in Rotational 
# Speed between machines with and without Tool Wear Failure.

# => Product Type significantly influences Machine Failure.
# => Rotational Speed does not follow a normal distribution in any category, 
#    and non-parametric tests such a kruskall and t_test were used.
# => Rotational Speed significantly differs between machines that failed vs. those that did 
#    not fail, but there is no significant difference in Rotational Speed based on Tool Wear Failure.


write.csv(ai4i_prep_clean, file = "C:/Users/DELL/Documents/4DS/Statistics/Projet/ai4i_output.csv", row.names = TRUE)
write.csv(standardized_data, file = "C:/Users/DELL/Documents/4DS/Statistics/Projet/gt_data_output.csv", row.names = TRUE)

