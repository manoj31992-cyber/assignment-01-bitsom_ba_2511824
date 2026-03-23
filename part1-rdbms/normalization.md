## Anomaly Analysis

### Insert Anomaly

When I opened orders_flat.csv, I noticed that if the company wants to add a new sales rep like SR04 who hasn't been assigned any order yet, there is no way to save that person's details in this table. The table only has rows for orders, so a sales rep can only be added if an order exists. Same goes for a new product - say the company stocks a new item called "Monitor" (P009) but no one has bought it yet, it simply cannot be recorded anywhere. This is the insert anomaly - you cannot insert data about an entity unless some other unrelated data (an order) also exists.

Relevant columns: `sales_rep_id`, `sales_rep_name`, `product_id`, `product_name`

---

### Update Anomaly

I found a clear example of this in the data itself. SR01 (Deepak Joshi) has his office address stored in every single row where he appears. In most rows the address is "Mumbai HQ, Nariman Point, Mumbai - 400021" but in rows like ORD1180, ORD1170, ORD1172, ORD1173 etc. it is written as "Mumbai HQ, Nariman Pt, Mumbai - 400021" (Pt instead of Point). So the same address is already inconsistent across rows. If the office shifts to a new location, someone would have to update 80+ rows manually. If they miss even one row, the database has conflicting information about where SR01 works.

Relevant columns: `office_address` for `sales_rep_id` = SR01 (compare ORD1091 vs ORD1180)

---

### Delete Anomaly

Product P008 (Webcam, Rs. 2100) appears in only one row in the entire file - ORD1185. If this order gets cancelled and the row is deleted, all information about the Webcam product is gone forever. There is no separate products table to keep the record. Similarly, if Arjun Nair (C007, arjun@gmail.com, Bangalore) cancels all his orders and those rows are deleted, his customer profile is completely wiped out even though the business might still want to keep his contact details for future marketing.

Relevant rows: ORD1185 (only row with P008), all rows where `customer_id` = C007

---

## Normalization Justification

I actually agree with the normalization approach and I think my manager's argument does not hold up well when you look at the actual data we have.

Let me give a real example. SR01 Deepak Joshi's office address shows up in over 80 rows of orders_flat.csv. And when I checked the data, I found that 13 of those rows have "Nariman Pt" while the rest say "Nariman Point" - this inconsistency already exists in the flat file right now. If someone needs to correct the address, they have to update every single row. In a normalized design with a separate sales_reps table, the address lives in exactly one place and one UPDATE fixes everything.

Another example - product P008 (Webcam) has only one order in the whole dataset (ORD1185). If that order gets deleted for any reason, the webcam product disappears from the database completely. In a normalized schema, the products table exists independently and an order deletion cannot wipe out product information.

My manager says joins make things complicated but honestly the complications in the flat file are much worse - duplicate data everywhere, inconsistencies building up over time, and no way to store new reps or products without fake orders. A normalized 3NF schema with separate tables for customers, products, sales_reps and orders removes all three types of anomalies. Yes there are joins to write but that is a one-time query writing effort, not an ongoing data corruption risk.

The "one big table is simpler" argument only works if the dataset never changes. For a growing retail business that adds new products and hires new reps regularly, normalization is the only practical choice.
