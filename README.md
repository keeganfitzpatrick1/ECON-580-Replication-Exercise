
# Replication Package for Wu (2018)

## Reccomended File Structure

Please download the replication package and organize your local directory as follows:
```
.
├── Replication Directory    # You creae this
    ├── data
    │   ├── gendered_posts.csv           # Main dataset of forum posts
    │   ├── keys_to_X.csv                # Keys to word count matrix
    │   ├── vocab10K.csv                 # Top 10K vocabulary with exclusions
    │   ├── trend_stats.csv              # Trend statistics for Figure 1
    │   └── X_word_count.npz             # Word count matrix (pickled)
    ├── code
    │   ├── fix-lasso-linear-pronoun-sample.py    # Linear LASSO (pronoun sample)
    │   ├── fix-lasso-logit-full-sample.py       # Logistic LASSO (full sample)
    │   ├── fix-lasso-logit-pronoun-sample.py     # Logistic LASSO (pronoun sample) 
    │   └── tables-figures.R                  # Generates Tables 1&2 and Figure 1
    ├── output                           # txt/pdf files generated from above .py and .R files may be stored in this folder
        ├── coef_lasso_logit_full.txt    # Model coefficients (full sample)
        ├── coef_lasso_logit_pronoun.txt # Model coefficients (pronoun sample)
        ├── ypred_*.txt                  # Predicted probabilities
        ├── table1.pdf                   # Table 1: Top predictive words
        ├── table2.pdf                   # Table 2: Top predictive words (pronoun)
        └── figure1.pdf                  # Figure 1: Trends over time
   
```

## Instructions
