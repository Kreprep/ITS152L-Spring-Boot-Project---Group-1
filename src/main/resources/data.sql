-- Seed demo data so the application looks populated on first run

INSERT INTO products (id, name, description, quantity, price, item_type, company, branch) VALUES
	(1, 'Delaware Sectional Sofa', 'Modular fabric sectional with chaise lounge', 0, 1299.00, 'furniture', 'HomeCo', 'Main Warehouse'),
	(2, 'Aero Ergonomic Chair', 'Adjustable lumbar mesh chair with headrest', 3, 349.00, 'furniture', 'SitRight', 'North Hub'),
	(3, 'Vortex Gaming Laptop', 'RTX 4070 powered 16" laptop with 240Hz display', 12, 2199.00, 'electronics', 'TechCore', 'Main Warehouse'),
	(4, 'Nimbus 27" Monitor', 'QHD IPS monitor with HDR and USB-C hub', 18, 399.00, 'electronics', 'VisionPro', 'Downtown Showroom'),
	(5, 'Barista Pro Espresso', 'Dual boiler espresso machine with PID control', 2, 899.00, 'appliances', 'BrewMaster', 'Uptown Boutique'),
	(6, 'Ascend Standing Desk', 'Dual-motor standing desk with memory presets', 9, 699.00, 'furniture', 'WorkSmart', 'Main Warehouse'),
	(7, 'Zen Noise-Cancel Headphones', 'Wireless ANC over-ear headphones', 5, 299.00, 'electronics', 'SoundSphere', 'Airport Kiosk'),
	(8, 'Swift Wireless Mouse', 'Low-latency ergonomic wireless mouse', 48, 79.00, 'electronics', 'TechCore', 'Online Fulfillment');

INSERT INTO sale_transactions (id, product_id, quantity, price, discount, discounted_price, brand, item_type, branch, total_price, timestamp) VALUES
	(1, 3, 4, 2199.00, 200.00, 1999.00, 'TechCore', 'electronics', 'Main Warehouse', 7996.00, '2025-10-28 10:15:00'),
	(2, 4, 6, 399.00, 20.00, 379.00, 'VisionPro', 'electronics', 'Downtown Showroom', 2274.00, '2025-10-29 16:45:00'),
	(3, 5, 3, 899.00, 50.00, 849.00, 'BrewMaster', 'appliances', 'Uptown Boutique', 2547.00, '2025-10-30 09:05:00'),
	(4, 7, 10, 299.00, 30.00, 269.00, 'SoundSphere', 'electronics', 'Airport Kiosk', 2690.00, '2025-10-31 12:30:00'),
	(5, 8, 25, 79.00, 5.00, 74.00, 'TechCore', 'electronics', 'Online Fulfillment', 1850.00, '2025-11-01 14:10:00'),
	(6, 2, 5, 349.00, 0.00, 349.00, 'SitRight', 'furniture', 'North Hub', 1745.00, '2025-11-02 11:40:00');

INSERT INTO purchase_orders (id, product_id, quantity, price, discount, discounted_price, brand, item_type, branch, supplier, status, order_date, received_date) VALUES
	(1, 1, 5, 1150.00, 100.00, 1050.00, 'HomeCo', 'furniture', 'Main Warehouse', 'Comfort Supply', 'RECEIVED', '2025-10-20 08:30:00', '2025-10-25 17:00:00'),
	(2, 3, 8, 2100.00, 150.00, 1950.00, 'TechCore', 'electronics', 'Main Warehouse', 'TechCore Distribution', 'PENDING', '2025-11-03 09:45:00', NULL),
	(3, 5, 6, 870.00, 0.00, 870.00, 'BrewMaster', 'appliances', 'Uptown Boutique', 'Cafe Supply Co.', 'RECEIVED', '2025-10-15 13:10:00', '2025-10-18 10:25:00'),
	(4, 7, 15, 260.00, 15.00, 245.00, 'SoundSphere', 'electronics', 'Airport Kiosk', 'SoundSphere Logistics', 'PENDING', '2025-11-01 10:15:00', NULL);

INSERT INTO transaction_history (id, action_type, reference_id, product_id, quantity, price, discount, discounted_price, brand, item_type, branch, total_price, timestamp, note) VALUES
	(1, 'SALE', 1, 3, 4, 2199.00, 200.00, 1999.00, 'TechCore', 'electronics', 'Main Warehouse', 7996.00, '2025-10-28 10:15:00', 'Recorded sale for Vortex Gaming Laptop'),
	(2, 'SALE', 2, 4, 6, 399.00, 20.00, 379.00, 'VisionPro', 'electronics', 'Downtown Showroom', 2274.00, '2025-10-29 16:45:00', 'Recorded sale for Nimbus monitors'),
	(3, 'SALE', 3, 5, 3, 899.00, 50.00, 849.00, 'BrewMaster', 'appliances', 'Uptown Boutique', 2547.00, '2025-10-30 09:05:00', 'Recorded sale for Barista Pro units'),
	(4, 'SALE', 4, 7, 10, 299.00, 30.00, 269.00, 'SoundSphere', 'electronics', 'Airport Kiosk', 2690.00, '2025-10-31 12:30:00', 'Headphones promo weekend sale'),
	(5, 'SALE', 5, 8, 25, 79.00, 5.00, 74.00, 'TechCore', 'electronics', 'Online Fulfillment', 1850.00, '2025-11-01 14:10:00', 'Online flash sale bundle'),
	(6, 'SALE', 6, 2, 5, 349.00, 0.00, 349.00, 'SitRight', 'furniture', 'North Hub', 1745.00, '2025-11-02 11:40:00', 'Corporate seating refresh order'),
	(7, 'ORDER', 1, 1, 5, 1150.00, 100.00, 1050.00, 'HomeCo', 'furniture', 'Main Warehouse', 5250.00, '2025-10-20 08:30:00', 'Purchase order received from Comfort Supply'),
	(8, 'ORDER', 2, 3, 8, 2100.00, 150.00, 1950.00, 'TechCore', 'electronics', 'Main Warehouse', 15600.00, '2025-11-03 09:45:00', 'Awaiting delivery from TechCore Distribution'),
	(9, 'ORDER', 3, 5, 6, 870.00, 0.00, 870.00, 'BrewMaster', 'appliances', 'Uptown Boutique', 5220.00, '2025-10-15 13:10:00', 'Restocked espresso machines from Cafe Supply Co.'),
	(10, 'ORDER', 4, 7, 15, 260.00, 15.00, 245.00, 'SoundSphere', 'electronics', 'Airport Kiosk', 3675.00, '2025-11-01 10:15:00', 'Bulk headphone order pending receipt');