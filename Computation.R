# Preload required R librabires
gc()
rm()
library(tm)
library(ggplot2)
library(RWeka)
library(R.utils)
library(dplyr)
library(parallel)
library(wordcloud)

total1 <- file("./Coursera-Swiftkey/final/en_US/en_US.twitter.txt", open = "rb")
twitter <- readLines(total1, skipNul = TRUE, encoding="UTF-8")
close(total1)

total2 <- file("./Coursera-Swiftkey/final/en_US/en_US.news.txt", open = "rb")
news <- readLines(total2, skipNul = TRUE, encoding="UTF-8")
close(total2)

total3 <- file("./Coursera-Swiftkey/final/en_US/en_US.blogs.txt", open = "rb")
blogs <- readLines(total3, skipNul = TRUE, encoding="UTF-8")
close(total3)

sampletext <- function(textbody, sample) {
  taking <- sample(1:length(textbody), length(textbody)*sample)
  Sampletext <- textbody[taking]
  Sampletext
}

# sampling text files 
set.seed(65364)
sample <- .5
SampleTwitter <- sampletext(twitter, sample)
SampleBlog <- sampletext(blogs, sample)
SampleNews <- sampletext(news, sample)

# combine sampled texts into one variable
SampleTotal <- c(SampleBlog, SampleNews, SampleTwitter)

# write sampled texts into text files for further analysis
writeLines(SampleTotal, "./Sampleall/SampleTotal.txt")


##Data Cleaning

##Next, the corpus was converted to lowercase, strip white space, and removed punctuation and numbers.

cleaning <- function (textcp) {
  textcp <- tm_map(textcp, content_transformer(tolower))
  textcp <- tm_map(textcp, stripWhitespace)
  textcp <- tm_map(textcp, removePunctuation)
  textcp <- tm_map(textcp, removeNumbers)
  textcp
}

SampleTotal <- VCorpus(DirSource("./Sampleall", encoding = "UTF-8"))

# tokenizing sampled text 
SampleTotal <- cleaning(SampleTotal)

# Define function to make N grams
tdm_Ngram_function <- function (textcp, n) {
  NgramTokenizer <- function(x) {RWeka::NGramTokenizer(x, RWeka::Weka_control(min = n, max = n))}
  tdm_Ngram_function <- TermDocumentMatrix(textcp, control = list(tokenizer = NgramTokenizer))
  tdm_Ngram_function
}

# Define function to extract the N grams and sort
ngram_sorted_df <- function (tdm_Ngram_function) {
  tdm_Ngram_function_m <- as.matrix(tdm_Ngram_function)
  tdm_Ngram_function_df <- as.data.frame(tdm_Ngram_function_m)
  colnames(tdm_Ngram_function_df) <- "Count"
  tdm_Ngram_function_df <- tdm_Ngram_function_df[order(-tdm_Ngram_function_df$Count), , drop = FALSE]
  tdm_Ngram_function_df
}

# Calculate N-Grams
tdm_1gram <- tdm_Ngram_function(SampleTotal, 1)
tdm_2gram <- tdm_Ngram_function(SampleTotal, 2)
tdm_3gram <- tdm_Ngram_function(SampleTotal, 3)
tdm_4gram <- tdm_Ngram_function(SampleTotal, 4)


# Extract term-count tables from N-Grams and sort 
tdm_1gram_df <- ngram_sorted_df(tdm_1gram)
tdm_2gram_df <- ngram_sorted_df(tdm_2gram)
tdm_3gram_df <- ngram_sorted_df(tdm_3gram)
tdm_4gram_df <- ngram_sorted_df(tdm_4gram)

# Save data frames into r-compressed files

quadgramdata <- data.frame(rows=rownames(tdm_4gram_df),count=tdm_4gram_df$Count)
quadgramdata$rows <- as.character(quadgramdata$rows)
quadgramdata_split <- strsplit(as.character(quadgramdata$rows),split=" ")
quadgramdata <- transform(quadgramdata,first = sapply(quadgramdata_split,"[[",1),second = sapply(quadgramdata_split,"[[",2),third = sapply(quadgramdata_split,"[[",3), fourth = sapply(quadgramdata_split,"[[",4))
quadgramdata <- data.frame(unigram = quadgramdata$first,bigramdata = quadgramdata$second, trigramdata = quadgramdata$third, quadgramdata = quadgramdata$fourth, freq = quadgramdata$count,stringsAsFactors=FALSE)
write.csv(quadgramdata[quadgramdata$freq > 1,],"./ShinyApp/quadgramdata.csv",row.names=F)
quadgramdata <- read.csv("./ShinyApp/quadgramdata.csv",stringsAsFactors = F)
saveRDS(quadgramdata,"./ShinyApp/quadgramdata.RData")


trigramdata <- data.frame(rows=rownames(tdm_3gram_df),count=tdm_3gram_df$Count)
trigramdata$rows <- as.character(trigramdata$rows)
trigramdata_split <- strsplit(as.character(trigramdata$rows),split=" ")
trigramdata <- transform(trigramdata,first = sapply(trigramdata_split,"[[",1),second = sapply(trigramdata_split,"[[",2),third = sapply(trigramdata_split,"[[",3))
trigramdata <- data.frame(unigram = trigramdata$first,bigramdata = trigramdata$second, trigramdata = trigramdata$third, freq = trigramdata$count,stringsAsFactors=FALSE)
write.csv(trigramdata[trigramdata$freq > 1,],"./ShinyApp/trigramdata.csv",row.names=F)
trigramdata <- read.csv("./ShinyApp/trigramdata.csv",stringsAsFactors = F)
saveRDS(trigramdata,"./ShinyApp/trigramdata.RData")


bigramdata <- data.frame(rows=rownames(tdm_2gram_df),count=tdm_2gram_df$Count)
bigramdata$rows <- as.character(bigramdata$rows)
bigramdata_split <- strsplit(as.character(bigramdata$rows),split=" ")
bigramdata <- transform(bigramdata,first = sapply(bigramdata_split,"[[",1),second = sapply(bigramdata_split,"[[",2))
bigramdata <- data.frame(unigram = bigramdata$first,bigramdata = bigramdata$second,freq = bigramdata$count,stringsAsFactors=FALSE)
write.csv(bigramdata[bigramdata$freq > 1,],"./ShinyApp/bigramdata.csv",row.names=F)
bigramdata <- read.csv("./ShinyApp/bigramdata.csv",stringsAsFactors = F)
saveRDS(bigramdata,"./ShinyApp/bigramdata.RData")