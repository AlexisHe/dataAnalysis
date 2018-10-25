
setwd("C:/Users/wxing/Desktop/spm")

library(TraMineR)
library(cluster)


inputFile <- "mixed.csv"

#inputFile <- "low_itemized_file.csv"

#inputFile <- "test.csv"

# Read input file
a <- read.csv(inputFile, head = F, stringsAsFactors=FALSE, na.strings= "NA")

mvad.seq <- seqdef(a, 1:22, right = "DEL")

cpal(mvad.seq) <- rainbow(94)


##
cpal(mvad.seq)




##pattern mining apporach

RepeatedState2Event <- function(seqdata){
  tse <- data.frame(id=rep(1:nrow(seqdata), ncol(seqdata)), 
                    event=unlist(seqdata), timestamp =sort(rep(0:(ncol(seqdata)-1), 
                                                               nrow(seqdata))))
  tse <- tse[order(tse$id, tse$timestamp, tse$event), ]
  return(seqecreate(tse))
}


mvseqe <- RepeatedState2Event(mvad.seq)
print(mvseqe[1])


## This takes some time to compute see below

constraint <- seqeconstraint(maxGap=10, windowSize=10) # creating variable with conditions
subseq <- seqefsub(mvseqe, pMinSupport=0.005, constraint=constraint) # searching for frequent event subsequences

#subseq <- seqefsub(mvseqe, pMinSupport=0.005)




##########how to retreive things from subseq https://github.com/cran/TraMineR/blob/master/R/subseqelist.R

s <- subseq$subseq
d <- subseq$data

f <- gsub("\\(+\\)+-","",s)
f <- gsub("-+\\(+\\)","",f)
f <- gsub("\\(+\\)","",f)

f <- cbind(f, d)
colnames(f)[1] <- "subseq"


f <- f[!(is.na(f$subseq) | f$subseq == ""), ]

f <- f[!duplicated(f[,1]),]


write.csv(f, "sequence_mixed.csv")



################differentiate between groups ###need a little bit more work
discrseq <- seqecmpgroup(df.subseq.time.constr, group=a$score) # searching for frequent sequences that are related to gender
head(discrseq)
plot(discrseq[1:10], cex=1.5) # plotting 10 frequent subsequences
plot(discrseq[1:10], ptype="resid", cex=1.5) # plotting 10 residuals













