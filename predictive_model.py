import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import classification_report, confusion_matrix

# Loading the Data
df = pd.read_csv("Clean_Churn.csv")

# Converting Sting categories into numerical
df['Contract'] = df['Contract'].astype('category').cat.codes
df['Geography'] = df['Geography'].astype('category').cat.codes

# Using columns as features
features = ['Geography', 'Contract', 'MonthlyCharges', 'Tenure', 'SupportTickets', 'UsageScore']
X = df[features]
y = df['Churn']

# Split and Train
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# n_estimators=200 makes the forest bigger/smarter
model =RandomForestClassifier(n_estimators=200, max_depth=10, random_state=42)
model.fit(X_train, y_train)

# Checking the score
predictions = model.predict(X_test)
print(f"Model Accuracy: {accuracy_score(y_test, predictions) * 100:.2f}%")

# Printing the detailed breakdown
print("Classification report")
print(classification_report(y_test, predictions))

# Getting importance from the model
importances = model.feature_importances_
indices = np.argsort(importances)[::1]
feature_names = [features[i] for i in indices]

# Creating the plot
plt.figure(figsize = (10,6))
plt.title("What's driving the predictions?")
plt.bar(range(X.shape[1]), importances[indices], align='center')
plt.xticks(range(X.shape[1]), feature_names, rotation=45)
plt.tight_layout()
plt.show()

test_probs = model.predict_proba(X_test)[:, 1]

results = pd.DataFrame({
    'CustomerID': df.iloc[X_test.index]['CustomerID'],
    'Churn_Probability': test_probs,
})

#results.to_csv('churn_risk_scores.csv', index=False)
print('Done')