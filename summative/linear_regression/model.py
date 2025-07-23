import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import pickle
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
from sklearn.ensemble import RandomForestRegressor
from sklearn.tree import DecisionTreeRegressor

# Load the dataset
df = pd.read_csv(r'c:\Users\Merveille\Downloads\watson_healthcare_modified.csv')
print(df.head())
print(df.dtypes)

# Finding the correlation to choose the right data to use
fdf = df.select_dtypes(include=[object])
categorical_columns = fdf.columns.tolist()
df_encoded = pd.get_dummies(df, columns=categorical_columns)

# Correlation matrix
correlation_matrix = df_encoded.corr()
years_at_company_corr = correlation_matrix['YearsAtCompany']
print("\nCorrelation with 'YearsAtCompany':")
print(years_at_company_corr)

# Selecting relevant columns
columns_to_use = ['Age', 'TotalWorkingYears', 'YearsAtCompany', 
                  'YearsInCurrentRole', 'YearsSinceLastPromotion', 
                  'YearsWithCurrManager', 'JobLevel', 'MonthlyIncome']
ndf = df.loc[:, columns_to_use]

# Defining features and target variable
Y = ndf['YearsAtCompany']
X = ndf.drop(columns=['YearsAtCompany'])

# Splitting the dataset
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

# Training Linear Regression model
model = LinearRegression()
model.fit(X_train, Y_train)

# Making predictions and calculating RMSE for Linear Regression
Y_pred = model.predict(X_test)
rmse = np.sqrt(mean_squared_error(Y_test, Y_pred))
print(f"Linear Regression RMSE: {rmse}")

# Training Random Forest Regressor
rf_model = RandomForestRegressor(random_state=42)
rf_model.fit(X_train, Y_train)

# Training Decision Tree Regressor
dtr_model = DecisionTreeRegressor(random_state=42)
dtr_model.fit(X_train, Y_train)

# Making predictions for Random Forest and Decision Trees
rf_pred = rf_model.predict(X_test)
dtr_pred = dtr_model.predict(X_test)

# Calculate RMSE for both models
rf_rmse = np.sqrt(mean_squared_error(Y_test, rf_pred))
dt_rmse = np.sqrt(mean_squared_error(Y_test, dtr_pred))

# Print RMSE for each model
print(f"Random Forest RMSE: {rf_rmse}")
print(f"Decision Tree RMSE: {dt_rmse}")

# Model rankings
model_rank = {
    'Linear Regression': rmse,
    'Random Forest': rf_rmse,
    'Decision Trees': dt_rmse
}
print("\nModel Rankings:")
print(model_rank)

# Save the Random Forest model
with open('randomforest_model.pkl', 'wb') as file:
    pickle.dump(rf_model, file)

print('Model saved as randomforest_model.pkl')