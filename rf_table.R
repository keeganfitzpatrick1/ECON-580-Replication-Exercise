# This R file brings in final datasets and produces Tables 1&2 and Figure 1 in the paper
# plus Table 3: Random Forest Top Words
install.packages("gridExtra")
library(gridExtra)

# datasets
dir_data="." # the directory of datasets
vocab10K=read.csv(paste0(dir_data,"/vocab10K.csv"),stringsAsFactors = FALSE)
trend=read.csv(paste0(dir_data,"/trend_stats.csv"))
trend$date=as.Date(trend$date)

# Table 1: Top 10 Words Most Predictive of Female/Male Posts 
tab1=cbind(vocab10K[order(vocab10K$ME,decreasing=TRUE)[1:10],c("word","ME")],
           vocab10K[order(vocab10K$ME,decreasing=FALSE)[1:10],c("word","ME")])
# save table 1
pdf("table1.pdf", width = 8, height = 6)
grid.table(tab1)
dev.off()

# Table 2: Top 10 Words Most Predictive of Female/Male Posts in the Pronoun Sample 
tab2=cbind(vocab10K[order(vocab10K$ME_pronoun,decreasing=TRUE)[1:10],c("word","ME_pronoun")],
           vocab10K[order(vocab10K$ME_pronoun,decreasing=FALSE)[1:10],c("word","ME_pronoun")])
# Save table 2
pdf("table2.pdf", width = 8, height = 6)
grid.table(tab2)
dev.off()

# Table 3: Random Forest Top 10 Words Most Predictive of Female/Male Posts
table_rf <- read.csv(paste0(dir_data, "/table_rf_top_words.csv"))

# Format the table 
table_rf_display <- data.frame(
  word_female = table_rf$word_female,
  rf_importance_female = sprintf("%.7f", table_rf$rf_importance_female),
  word_male = table_rf$word_male,
  rf_importance_male = sprintf("%.7f", table_rf$rf_importance_male)
)

colnames(table_rf_display) <- c("word", "RF Importance", "word", "RF Importance")

# Save Table 3
pdf("table3_random_forest.pdf", width = 10, height = 6)

# theme
tt <- ttheme_default(
  core = list(
    fg_params = list(hjust = 0.5, fontsize = 11),
    bg_params = list(fill = c(rep(c("white", "grey95"), 5)))
  ),
  colhead = list(
    fg_params = list(hjust = 0.5, fontsize = 12, fontface = "bold"),
    bg_params = list(fill = "grey70")
  )
)

# Create table
g <- tableGrob(table_rf_display, rows = NULL, theme = tt)

# Add title
title <- textGrob("Table 3: Top 10 Words Most Predictive in Random Forest Classifier",
                  gp = gpar(fontsize = 14, fontface = "bold"))

# Combine and draw
grid.arrange(title, g, ncol = 1, heights = c(1, 10))

dev.off()

# Figure 1: Fraction of Female (Male) Posts that Include any Top 50 Female (Male) Words, under Two Alternatives
# "frac" - the fraction of Female (Male) posts that contains any top 50 Female (Male) terms in the full gender sample
# "frac_pronoun" - same definition as "frac" but restrict to the pronoun sample 
library(ggplot2)
ggplot(trend,aes(x=date))+
  geom_point(aes(y=frac,color=as.factor(female),shape=as.factor(female)))+ 
  geom_point(aes(y=frac_pronoun,color=as.factor(female),shape=as.factor(female)))+
  geom_line(aes(y=frac,color=as.factor(female)))+
  geom_line(aes(y=frac_pronoun,color=as.factor(female)),linetype=2)+
  scale_color_manual(values=c("#56B4E9","#CC79A7"),labels=c("Male","Female"))+
  scale_shape_discrete(labels=c("Male","Female"))+
  scale_x_date(date_breaks="1 month",date_labels =  "%b %Y")+
  scale_y_continuous(breaks=seq(0.05,0.20,by=0.05),limits=c(0.05,0.20))+
  xlab("Month of the Latest Update")+ylab("Fraction of Female (Male) Posts")+
  theme(legend.position="bottom",legend.title=element_blank(),panel.background = element_blank(),
        axis.line = element_line(colour = "black"),axis.title=element_text(size=10),
        axis.text.x=element_text(angle = 90,vjust=-0.005,size=9))
#save figure1
ggsave("figure1.pdf", width = 8, height = 6)

# Print completion message
cat("\nAll tables and figures saved successfully!\n")
cat("- table1.pdf (LASSO Logit - Full Sample)\n")
cat("- table2.pdf (LASSO Logit - Pronoun Sample)\n")
cat("- table3_random_forest.pdf (Random Forest Top Words)\n")
cat("- figure1.pdf (Trends over time)\n")
