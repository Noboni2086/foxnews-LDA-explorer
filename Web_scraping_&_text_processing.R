
library(rvest)
library(dplyr)
library(purrr)
library(xml2)
library(tm)
library(SnowballC)
library(textstem)
library(tokenizers)
library(stopwords)

categories <- c("politics", "world", "entertainment", "sports", "lifestyle")


get_fox_urls <- function(category, num_articles = 100) {
  index_url <- "https://www.foxnews.com/sitemap.xml"
  doc <- read_xml(index_url)
  ns <- xml_ns(doc)
  sitemap_urls <- xml_find_all(doc, ".//d1:loc", ns) %>% xml_text()
  article_sitemaps <- sitemap_urls[grepl("type=articles", sitemap_urls)]
  article_sitemaps <- unique(article_sitemaps)[1:10]
  urls <- c()
  for (sm_url in article_sitemaps) {
    sm_doc <- read_xml(sm_url)
    ns2 <- xml_ns(sm_doc)
    locs <- xml_find_all(sm_doc, ".//d1:loc", ns2) %>% xml_text()
    cat_urls <- locs[grepl(paste0("/", category, "/"), locs)]
    urls <- c(urls, cat_urls)
    if (length(urls) >= num_articles) break
  }
  unique(urls)[1:num_articles]
}


scrape_news_article <- function(url, category_guess) {
  tryCatch({
    page <- read_html(url)
    title <- page %>% html_node("h1.headline, h1") %>% html_text(trim = TRUE)
    description <- page %>%
      html_nodes("article p, .article-body p, .article-content p, .speakable p") %>%
      html_text(trim = TRUE) %>% paste(collapse = "\n")
    date <- page %>% html_node(".article-date") %>% html_text(trim = TRUE)
    if (is.na(date) || date == "") date <- NA
    author <- page %>% html_node(".author-byline a") %>% html_text(trim = TRUE)
    if (is.na(author) || author == "") author <- NA
    match <- regexec("foxnews.com/([^/]+)/", url)
    regmatch <- regmatches(url, match)
    cat_val <- if (length(regmatch[[1]]) > 1) regmatch[[1]][2] else category_guess
    data.frame(
      url = url,
      title = title,
      description = description,
      date = date,
      author = author,
      category = cat_val,
      stringsAsFactors = FALSE
    )
  }, error = function(e) {
    message(sprintf("Failed to scrape: %s\nReason: %s", url, e$message))
    return(NULL)
  })
}


scrape_news <- function(category, num_articles = 100) {
  message("Scraping category: ", category)
  urls <- get_fox_urls(category, num_articles)
  articles <- map_dfr(urls, ~ scrape_news_article(.x, category))
  head(articles, num_articles)
}


news_data <- map_df(categories, ~ scrape_news(.x, num_articles = 100))


write.csv(news_data, "Raw_news.csv", row.names = FALSE, fileEncoding = "UTF-8")

head(df$description)




setwd("G://datascience final")
df <- read.csv("Raw_news.csv", stringsAsFactors = FALSE)


corpus_title <- VCorpus(VectorSource(df$title))
corpus_content <- VCorpus(VectorSource(df$description))


clean_corpus <- function(corpus) {
  corpus <- tm_map(corpus, content_transformer(tolower)) 
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(function(x) gsub("[^a-z\\s]", " ", x)))  
  return(corpus)
}


corpus_title_clean <- clean_corpus(corpus_title)
corpus_content_clean <- clean_corpus(corpus_content)


df$cleaned_title <- sapply(corpus_title_clean, content)
df$cleaned_content <- sapply(corpus_content_clean, content)


tokenize_text_rowwise <- function(text_vector) {
  lapply(text_vector, function(text) {
    tokens <- tokenize_words(text)[[1]]
    tokens <- tokens[!tokens %in% stopwords("en")]
    return(tokens)
  })
}



lemmatize_text_rowwise <- function(token_list) {
  lapply(token_list, function(tokens) {
    tokens <- lemmatize_words(tokens)
    return(tokens)
  })
}



title_tokens_list <- tokenize_text_rowwise(df$cleaned_title)
content_tokens_list <- tokenize_text_rowwise(df$cleaned_content)

print("Tokenization")
print(head(content_tokens_list),10)



lemmatized_title_list <- lemmatize_text_rowwise(title_tokens_list)
lemmatized_content_list <- lemmatize_text_rowwise(content_tokens_list)


df$lemmatized_title <- sapply(lemmatized_title_list, paste, collapse = " ")
df$lemmatized_content <- sapply(lemmatized_content_list, paste, collapse = " ")


write.csv(df["lemmatized_content"], "clean_news.csv", row.names = FALSE, fileEncoding = "UTF-8")


print("lemmatization")
df$lemmatized_content <- lemmatized_content_list
print(head(df$lemmatized_content),10)

