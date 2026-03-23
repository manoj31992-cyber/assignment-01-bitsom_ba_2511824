## ETL Decisions

### Decision 1 — Fixing Mixed Date Formats
Problem: When I opened retail_transactions.csv, the date column was a mess. Some rows had dates in YYYY-MM-DD format (like 2023-02-05), some had DD/MM/YYYY with slashes (like 29/08/2023), and some had DD-MM-YYYY with hyphens (like 20-02-2023). If I loaded this directly into a DATE column in the warehouse, it would either throw errors or silently read the wrong date - for example 12-12-2023 might get read as December 12 in one format and fail in another.

Resolution: I wrote a parsing step that checks the format of each date string before converting it. Dates with slashes were treated as DD/MM/YYYY, dates with hyphens where the first part is greater than 12 were treated as DD-MM-YYYY, and the rest were ISO format. Everything was converted to YYYY-MM-DD before loading. The date_key in dim_date is stored as an integer in YYYYMMDD format which makes it easy to sort and filter by time.

---

### Decision 2 — Standardizing Category Names
Problem: The category column had inconsistent casing and naming. Some rows had "electronics" in lowercase, some had "Electronics" with a capital E, and groceries was written as both "Grocery" and "Groceries" across different rows. This is a big problem because GROUP BY queries would treat "electronics" and "Electronics" as two different categories, breaking all the sales reports by category.

Resolution: I converted all category values to title case first and then mapped them to a fixed standard list. "electronics" and "Electronics" both became "Electronics". "Groceries" became "Grocery" to keep it consistent. I created the canonical list based on what made sense in the context of the data and applied it during the transformation step before loading into dim_product.

---

### Decision 3 — Handling Missing Customer IDs and Zero Prices
Problem: A few rows in the transactions file had blank or missing customer_id values. Since the fact table has a customer_id column and some analysis depends on it, just leaving NULLs would break certain queries and also made the data look messy. Additionally there were a small number of rows where unit_price was 0 or missing, especially in the grocery category, which would make revenue calculations wrong.

Resolution: For missing customer IDs, I substituted the value "CUST_UNKNOWN" as a placeholder. This way the row can still be loaded and counted in overall sales, but analysts can filter it out when doing customer-level analysis. For missing or zero unit prices, I looked up the correct price by matching the product name against other rows in the same file where the price was available, and used the most common (modal) price for that product. Any rows where I could not determine the price were logged separately and excluded from the final load.
