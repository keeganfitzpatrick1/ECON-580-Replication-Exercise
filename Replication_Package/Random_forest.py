#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np 
import pandas as pd 
import os
from sklearn.ensemble import RandomForestClassifier

dir_data="./" # specify the directory to data files 
dir_output="./" # where the outputs are saved 

# Create output directory if it doesn't exist
os.makedirs(dir_output, exist_ok=True)

# Identify training sample
posts=pd.read_csv(dir_data+"gendered_posts.csv") 
keys_X=pd.read_csv(dir_data+'keys_to_X.csv')
keys_merged=pd.merge(keys_X,posts,on=['title_id','post_id'],how="left") 

i_train=np.where(keys_merged['training']==1)

y_train=keys_merged.loc[i_train[0],'female'].to_numpy() 

# Use word count matrix X
word_counts=np.load(dir_data+"X_word_count.npz",encoding='latin1', allow_pickle=True)
X=word_counts['X'][()] 
X_train=X[i_train[0],:]

# Select Predictors
vocab10K=pd.read_csv(dir_data+"vocab10K.csv")
exclude_vocab=vocab10K.loc[vocab10K['exclude']==1,:]
i_exclude=exclude_vocab['index']-1
i_columns=range(10000)
i_keep_columns=list(set(i_columns)-set(i_exclude)) 

X_train=X_train[:,i_keep_columns] 
print("Training set shape:", X_train.shape)

rf_model = RandomForestClassifier(
    n_estimators=100,
    max_depth=20,
    min_samples_split=10,
    min_samples_leaf=5,
    max_features='sqrt',
    random_state=42,
    n_jobs=-1,
    verbose=1
)

rf_model.fit(X_train, y_train)

# Save Feature Importances to create table
feature_importances = rf_model.feature_importances_
np.savetxt(dir_output+"feature_importance_rf.txt", feature_importances)

print("Successful creation")


# In[3]:


import numpy as np 
import pandas as pd 
from sklearn.ensemble import RandomForestClassifier

dir_data="./"
dir_output="./"

# Load vocabulary
vocab10K = pd.read_csv(dir_data+"vocab10K.csv")
rf_importance = np.loadtxt(dir_output+"feature_importance_rf.txt")

# Get kept columns
exclude_vocab = vocab10K.loc[vocab10K['exclude']==1,:]
i_exclude = exclude_vocab['index']-1
i_columns = range(10000)
i_keep_columns = list(set(i_columns)-set(i_exclude))

vocab_kept = vocab10K.iloc[i_keep_columns].copy()
vocab_kept['rf_importance'] = rf_importance

# Method 1: Use ME sign to determine direction, RF importance for magnitude
# This creates a "directional importance"
vocab_kept['rf_directional_importance'] = vocab_kept['rf_importance'] * np.sign(vocab_kept['ME'])

# Sort by directional importance
# Positive = female-associated
# Negative = male-associated

# Top 10 female words 
top_female = vocab_kept.nlargest(10, 'rf_directional_importance')[['word', 'rf_directional_importance']]

# Top 10 male words
top_male = vocab_kept.nsmallest(10, 'rf_directional_importance')[['word', 'rf_directional_importance']]

# Create comparison table
table_rf = pd.DataFrame({
    'word_female': top_female['word'].values,
    'rf_importance_female': top_female['rf_directional_importance'].values,
    'word_male': top_male['word'].values,
    'rf_importance_male': top_male['rf_directional_importance'].values
})

# Display
print("\nTable: Top 10 Words Most Predictive in Random Forest")
print("(Directional importance: positive = female, negative = male)")
print("="*80)
print(f"{'Word':<20} {'RF Importance':<20} {'Word':<20} {'RF Importance':<20}")
print("="*80)
for idx, row in table_rf.iterrows():
    print(f"{row['word_female']:<20} {row['rf_importance_female']:<20.7f} {row['word_male']:<20} {row['rf_importance_male']:<20.7f}")
print("="*80)

# Save
table_rf.to_csv(dir_output+"table_rf_top_words.csv", index=False)

print("\nTable saved!")

