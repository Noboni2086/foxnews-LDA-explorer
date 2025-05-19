# foxnews-LDA-explorer

**foxnews-LDA-explorer** is a pipeline for mining, cleaning, and preparing Fox News articles for topic modeling using Latent Dirichlet Allocation (LDA). It provides a structured process for acquiring web content, preprocessing text, and exporting data for advanced NLP applications.

---

## 📌 Overview

This project enables:
- Automated scraping of Fox News articles across multiple categories
- Extraction of article metadata (title, author, date, category, content)
- Text cleaning and preprocessing (stopword removal, lemmatization, etc.)
- Preparation of data for unsupervised topic modeling

---

## 🧰 Tools & Libraries Used

- **rvest**, **xml2** – For web scraping and XML parsing
- **tm**, **SnowballC**, **textstem** – For text cleaning and lemmatization
- **tokenizers**, **stopwords** – For token-level processing
- **dplyr**, **purrr** – For data wrangling and functional programming

---

## 📁 Output Files

- **Raw_news.csv**: Contains raw scraped data from Fox News (titles, dates, content, etc.)
- **news_clean.csv**: Preprocessed and lemmatized article content ready for LDA modeling

---

## 💡 Project Highlights

- Supports multiple categories: Politics, World, Entertainment, Sports, Lifestyle
- Designed to be modular and easily extensible
- Future-ready: planned integration with Latent Semantic Analysis (LSA) and visualization tools

---

## 🚀 Future Enhancements

- Integration with LSA (Latent Semantic Analysis)
- Interactive topic visualization using tools like LDAvis
- More robust error handling and scraper optimization
- Expansion to other news outlets for comparative topic analysis

---

## 📄 License

This project is intended for academic and research use only. Content retrieved belongs to [Fox News](https://www.foxnews.com).

---

## 🤝 Contributing

Contributions are welcome! If you'd like to collaborate, improve scraping performance, or integrate new analysis tools, feel free to fork the repository and open a pull request.

---

## 📫 Contact

Maintained by **shraboni2086@gmail.com**  
For inquiries, please open an issue in the repository.
