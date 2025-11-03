-- Drop and recreate tables so schema.sql always results in the expected schema.
-- WARNING: This will remove existing data in these tables. Back up your data if needed.
DROP TABLE IF EXISTS transaction_history;
DROP TABLE IF EXISTS purchase_orders;
DROP TABLE IF EXISTS sale_transactions;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  description VARCHAR(1024),
  quantity INT,
  price DECIMAL(19,2),
  item_type VARCHAR(255),
  company VARCHAR(255),
  branch VARCHAR(255)
);

CREATE TABLE sale_transactions (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT,
  quantity INT,
  price DECIMAL(19,2),
  discount DECIMAL(19,2),
  discounted_price DECIMAL(19,2),
  brand VARCHAR(255),
  item_type VARCHAR(255),
  branch VARCHAR(255),
  total_price DECIMAL(19,2),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_sale_product FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE purchase_orders (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  product_id BIGINT,
  quantity INT,
  price DECIMAL(19,2),
  discount DECIMAL(19,2),
  discounted_price DECIMAL(19,2),
  brand VARCHAR(255),
  item_type VARCHAR(255),
  branch VARCHAR(255),
  supplier VARCHAR(255),
  status VARCHAR(32) DEFAULT 'PENDING',
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  received_date TIMESTAMP NULL,
  CONSTRAINT fk_purchase_product FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE transaction_history (
  id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  action_type VARCHAR(32),
  reference_id BIGINT,
  product_id BIGINT,
  quantity INT,
  price DECIMAL(19,2),
  discount DECIMAL(19,2),
  discounted_price DECIMAL(19,2),
  brand VARCHAR(255),
  item_type VARCHAR(255),
  branch VARCHAR(255),
  total_price DECIMAL(19,2),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  note VARCHAR(1024)
);