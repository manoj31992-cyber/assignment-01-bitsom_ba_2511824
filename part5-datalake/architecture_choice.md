## Architecture Recommendation

For this food delivery startup I would recommend a Data Lakehouse architecture. Here is my reasoning.

The startup is collecting four very different types of data - GPS location logs, customer text reviews, payment transactions, and restaurant menu images. These are structurally completely different from each other. A traditional data warehouse like Snowflake or BigQuery is designed for structured, tabular data. It cannot efficiently store raw images, free-text reviews, or high-frequency GPS streams without a lot of preprocessing and schema design upfront. A pure data lake on the other hand can store all of these in raw form but it has no query performance or data quality guarantees, which makes business reporting difficult.

The Data Lakehouse gives you the best of both. You store everything raw in cheap object storage (like S3 or GCS) in open formats like Parquet or Delta Lake, and then layer query and governance tools on top that let you run SQL-style queries on that data when needed.

Here are my three specific reasons:

First, the variety of data makes a warehouse impossible to use alone. GPS logs come in millions of rows per minute. Menu images are binary files. Customer reviews are unstructured text. None of these fit neatly into a relational schema without heavy transformation. A lakehouse handles all these formats natively without forcing you to pre-define a schema.

Second, payment transactions still need ACID guarantees. You cannot have a situation where a payment is recorded as both completed and pending at the same time. Modern lakehouse formats like Delta Lake support ACID transactions on top of object storage, so the startup gets data reliability for payment data without having to run a separate relational database just for analytics.

Third, cost is a real concern for a fast-growing startup. GPS logs alone can grow to terabytes per day very quickly. Storing all of that in a data warehouse would be extremely expensive because warehouses charge for both storage and compute. A lakehouse keeps the raw data in low-cost object storage and only fires up compute when you actually query it, which is much more affordable at scale.

So the Lakehouse fits here because it is flexible enough for all the data types, reliable enough for payment records, and cost-efficient enough for the scale this startup will grow to.
