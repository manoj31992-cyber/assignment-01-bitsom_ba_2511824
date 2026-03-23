// ============================================================
// Part 2.2 — MongoDB Operations
// Collection: products
// ============================================================

// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    _id: "prod_elec_001",
    category: "Electronics",
    name: "Samsung 4K QLED TV 55-inch",
    brand: "Samsung",
    sku: "SM-TV-55-QLED",
    price: 89999,
    currency: "INR",
    stock: 42,
    specs: {
      screen_size_inches: 55,
      resolution: "3840x2160",
      display_type: "QLED",
      refresh_rate_hz: 120,
      hdmi_ports: 4,
      usb_ports: 2,
      smart_tv: true,
      os: "Tizen",
      voltage: "220V",
      warranty_years: 2
    },
    in_box: ["TV Unit", "Remote Control", "Wall Mount Screws", "Power Cable"],
    ratings: { average: 4.5, count: 312 },
    tags: ["television", "4k", "smart-tv", "qled"]
  },
  {
    _id: "prod_cloth_001",
    category: "Clothing",
    name: "Men's Slim Fit Formal Shirt",
    brand: "Van Heusen",
    sku: "VH-SHIRT-BLU-M",
    price: 1299,
    currency: "INR",
    stock: 150,
    specs: {
      fabric: "100% Cotton",
      fit: "Slim Fit",
      collar: "Spread Collar",
      sleeve: "Full Sleeve",
      pattern: "Solid",
      care_instructions: ["Machine Wash Cold", "Do Not Bleach", "Tumble Dry Low"]
    },
    available_sizes: ["S", "M", "L", "XL", "XXL"],
    available_colors: [
      { color: "Blue",  hex: "#1E3A5F", stock: 60 },
      { color: "White", hex: "#FFFFFF", stock: 55 },
      { color: "Grey",  hex: "#808080", stock: 35 }
    ],
    ratings: { average: 4.2, count: 875 },
    tags: ["formal", "shirt", "cotton", "mens-wear"]
  },
  {
    _id: "prod_groc_001",
    category: "Groceries",
    name: "Daawat Extra Long Basmati Rice 5kg",
    brand: "Daawat",
    sku: "DW-RICE-BAS-5KG",
    price: 649,
    currency: "INR",
    stock: 320,
    specs: {
      weight_kg: 5,
      grain_type: "Basmati",
      grain_length_mm: 8.3,
      packaging: "Sealed Bag",
      country_of_origin: "India",
      organic: false,
      allergens: []
    },
    nutritional_info_per_100g: {
      calories_kcal: 349,
      carbohydrates_g: 77.5,
      protein_g: 7.5,
      fat_g: 0.6,
      fiber_g: 0.4,
      sodium_mg: 5
    },
    expiry_date: new Date("2025-12-31"),
    manufacture_date: new Date("2024-06-01"),
    certifications: ["FSSAI", "ISO 22000"],
    storage_instructions: "Store in a cool, dry place away from direct sunlight.",
    ratings: { average: 4.7, count: 2103 },
    tags: ["rice", "basmati", "staple", "gluten-free"]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find(
  { category: "Electronics", price: { $gt: 20000 } },
  { name: 1, brand: 1, price: 1, "specs.warranty_years": 1 }
);

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find(
  {
    category: "Groceries",
    expiry_date: { $lt: new Date("2025-01-01") }
  },
  { name: 1, brand: 1, expiry_date: 1, price: 1 }
);

// OP4: updateOne() — add a "discount_percent" field to a specific product
// Adding a 10% discount to the Samsung TV
db.products.updateOne(
  { _id: "prod_elec_001" },
  { $set: { discount_percent: 10 } }
);

// OP5: createIndex() — create an index on category field and explain why
// Reason: The most common query pattern is filtering by category (e.g., find all
// Electronics, all Groceries). Without an index, MongoDB performs a full collection
// scan (O(n)) on every such query. A single-field index on 'category' allows MongoDB
// to use a B-tree structure, reducing lookup time to O(log n) and dramatically
// improving performance as the catalog grows to millions of products.
db.products.createIndex(
  { category: 1 },
  { name: "idx_category", background: true }
);
