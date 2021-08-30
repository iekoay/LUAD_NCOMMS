install.packages("rJava")
library(rJava)
library(xlsxjars)
library(xlsx)
options(stringsAsFactors = F, warn = -1)

## import the peak area of the detected metabolites
df <- read.csv("Example data-peak area.csv", 
               sep = ",", header = T)
# df <- df[,-c(590:595)]

## how many batches do you have? 
total_batch_num <- 3

## Calculate the mean peak area of all the QC (quality control) samples in all batches: df.QC$all_mean
if (T) {
  df.QC <- df[, grep(pattern="QC", colnames(df))]
  rownames(df.QC) <- df$Metabolite
  colnames(df.QC) <- gsub("[.]", "_", colnames(df.QC))
  df.QC$all_mean <- apply(df.QC, 1, mean)
}

## start QC and TIC (total ion chromatogram) normalization
df_final.S <- as.data.frame(df[,1])
df_final.QC <- as.data.frame(df[,1])
for (i in 1:total_batch_num) {
  # batch name
  batch_name <- paste("Batch", sprintf("%02d", i), sep = "")
  
  # sample sequence of each batch
  sam_seq <- na.omit(read.xlsx("sample information.xlsx", 
                               sheetIndex = i, header = F, startRow = 1, as.data.frame = T))
  # QC index in each batch
  QC_index <- grep(pattern="QC_", sam_seq$X1)
  batch_QC_num <- length(QC_index)
  
  for (j in 1:batch_QC_num) {
    # recognize the 2 adjacent QC samples to a given group of test samples 
    s <- ifelse(j!=1 && QC_index[j]-QC_index[j-1]>1, T, F)
    
    if(s){
      # 2 adjacent QC samples of each group, j-1 and j, # sprintf("%02d", i), "_", 
      QC1 <- paste(batch_name, "_QC_", sprintf("%02d", j-1), sep = "")
      QC2 <- paste(batch_name, "_QC_", sprintf("%02d", j), sep = "")
      group_QC <- df.QC[, which(colnames(df.QC) == QC1 | colnames(df.QC) == QC2)]
      
      # calculate the mean value of QC samples in each group   # calculate the normalization factor of each group
      group_QC_mean <- apply(group_QC, 1, mean)
      group_QC_factor <- as.data.frame(df.QC$all_mean/group_QC_mean)
      
      #recognize the test samples in each group
      group_j <- sam_seq$X1[c((QC_index[j-1]+1):(QC_index[j]-1))]
      group_j <- gsub("Injection_", paste(batch_name, "_", sep = ""), group_j)
      group_index <- match(group_j, colnames(df))
      
      if(complete.cases(group_index)){
        # sample QC_mean Normalization
        df_S.QCm_normalized <- df[,group_index]*group_QC_factor[,1]
        df_QC.QCm_normalized <- group_QC*group_QC_factor[,1]
        
        # Sample TIC Normalization
        df_S.TIC_normalized <- apply(df_S.QCm_normalized, 2, function(x) x / sum(x))
        df_QC.TIC_normalized <- apply(df_QC.QCm_normalized, 2, function(x) x / sum(x))
        
        # merge all batches
        df_final.S <- cbind(df_final.S, df_S.TIC_normalized, stringsAsFactors = F)
        df_final.QC <- cbind(df_final.QC, df_QC.TIC_normalized, stringsAsFactors = F)
      }
    }
  }
}

colnames(df_final.S)[1] <- "Metabolite"
colnames(df_final.QC)[1] <- "Metabolite"
df_final <- cbind(df_final.S[,-1], df_final.QC[,-1])

write.csv(df_final, "D:/Expected Output.csv", quote = F, row.names = T)

