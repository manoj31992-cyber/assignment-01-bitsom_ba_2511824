## Storage Systems

The hospital has four different goals and each one needs a different type of storage because the data and access patterns are so different from each other.

For Goal 1 (predicting readmission risk), the data needed is historical - past diagnoses, lab results, treatment records, discharge summaries. This is structured data and I would store it in a Data Warehouse like Amazon Redshift or Snowflake. The ML model (something like XGBoost or a neural network) would be trained on this data. I would also add a Feature Store alongside it to pre-compute patient features so that when a new patient is admitted, the risk score can be generated quickly without recalculating everything from scratch.

For Goal 2 (doctors asking questions in plain English about patient history), the challenge is that clinical notes and doctor observations are free-text and unstructured. A normal SQL query cannot search these meaningfully. So I would store embeddings of all clinical text in a Vector Database like Pinecone or pgvector. When a doctor asks something like "has this patient had a cardiac event before?", the question gets converted to a vector and the system finds semantically similar records from the patient's history and returns a summarized answer.

For Goal 3 (monthly management reports on bed occupancy and costs), this is a classic analytics use case. The same Data Warehouse from Goal 1 handles this as well, with separate fact tables for admissions and costs, and a BI tool like Power BI or Tableau sitting on top for the reports.

For Goal 4 (real-time ICU vitals), devices are generating continuous streams of heart rate, blood pressure, SpO2 etc. at very high frequency. For this I would use a Time-Series Database like InfluxDB or Amazon Timestream which is specifically designed for sequential numeric data. Apache Kafka would sit in front to buffer the incoming stream before writing to the database.

---

## OLTP vs OLAP Boundary

The OLTP side includes everything that runs the hospital day to day - the EHR system where doctors write prescriptions, nurses update patient status, admissions desk registers new patients, and ICU devices send real-time vitals. These operations are frequent, small in size, and need to be accurate immediately. ACID guarantees are critical here.

The OLAP side starts when data moves from the EHR into the Data Warehouse. An ETL pipeline runs at scheduled intervals (or continuously via CDC) and pulls data from the operational EHR, cleans and transforms it, and loads it into the warehouse. After that point everything is read-heavy analytical work - training the ML model, running reports, doing trend analysis. The ML training pipeline, reporting dashboards, and feature engineering all sit on the OLAP side.

The Vector Database is a bit in between - it needs to be updated when new clinical notes are added (closer to OLTP frequency) but the actual searches run on it are read-heavy analytical queries.

---

## Trade-offs

The main trade-off I see in this design is the lag between what is happening in real time and what the analytics layer knows about.

When an ETL pipeline runs in batches, say every few hours, the Data Warehouse is always a few hours behind the live EHR. For monthly reports this is completely fine - a few hours of lag does not affect a monthly summary. But for the readmission risk prediction model, if a patient's condition changes significantly during their stay, the model might be working with outdated features if those changes have not yet been pushed to the warehouse.

The way I would handle this is by introducing Change Data Capture (CDC) using a tool like Debezium or AWS DMS. CDC listens to the EHR database's transaction log and pushes individual row-level changes to the Feature Store in near real-time, reducing the lag from hours to seconds. This way the ML model always has fresh data to work with.

The trade-off is that CDC adds complexity to the system - you need to manage schema changes carefully, handle failure and retry logic, and monitor the pipeline. But I would implement it selectively, only for the readmission prediction use case where freshness really matters, and keep the batch ETL for reporting where it is cheaper and simpler.
