
# Replication Package for Wu (2018)

Below are directions to replicate my replication of Wu 2018.

## Reccomended File Structure

Once downloaded the replication package it is reccomended to organize your files as follows:
```
.
├── Replication Directory    # You create this
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

1. Download all files from "Replication Package" (NOT "original replication package") and refer to above file structure if interested.
2. Run .py files anyway you see fit. This can be done within the terminal but I reccomend downloading Jupyterlab and viewing these files in a notebook.
3. The .py files may take up to 30 minutes to completely run and after completion the .txt files will be saved in the parent directory of the .py files
4. Run the .R file. I reccomend running this file in RStudio making sure that in this IDE your working directory is set to "data" (or whichever folder contains the files shown above).
5. The .pdf files of the figures/tables will be saved in the parent directory once you have ran the .R file. This concludes the replication of the original paper.
