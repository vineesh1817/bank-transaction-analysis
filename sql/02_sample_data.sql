-- Sample Data 

BEGIN;

INSERT INTO customers (first_name, last_name, email, phone, date_of_birth, city, state)
VALUES 
    ('Maya', 'Patel', 'maya.patel@example.com', '214-555-0101', '1998-04-12', 'Dallas', 'Texas'),
    ('Ethan', 'Williams', 'ethan.williams@example.com', '512-555-0102', '1995-09-23', 'Austin', 'Texas'),
    ('Sofia', 'Martinez', 'sofia.martinez@example.com', '713-555-0103', '2000-01-17', 'Houston', 'Texas'),
    ('Noah', 'Johnson', 'noah.johnson@example.com', '303-555-0104', '1992-07-08', 'Denver', 'Colorado'),
    ('Ava', 'Thompson', 'ava.thompson@example.com', '206-555-0105', '1999-11-30', 'Seattle', 'Washington'),
    ('Liam', 'Brown', 'liam.brown@example.com', '312-555-0106', '1988-06-14', 'Chicago', 'Illinois'),
    ('Emma', 'Davis', 'emma.davis@example.com', '617-555-0107', '1997-03-21', 'Boston', 'Massachusetts'),
    ('Lucas', 'Wilson', 'lucas.wilson@example.com', '602-555-0108', '1994-12-05', 'Phoenix', 'Arizona'),
    ('Olivia', 'Anderson', 'olivia.anderson@example.com', '404-555-0109', '2001-08-19', 'Atlanta', 'Georgia'),
    ('Arjun', 'Reddy', 'arjun.reddy@example.com', '940-555-0110', '1999-10-26', 'Denton', 'Texas');

INSERT INTO accounts(customer_id, account_number, account_type, current_balance, account_status, opened_date)
VALUES 
    (1,  'CHK100001', 'checking',  4250.75,  'active', '2022-01-15'),
    (1,  'SAV100001', 'savings',  15200.00,  'active', '2022-01-15'),
    (2,  'CHK100002', 'checking',  3180.25,  'active', '2021-06-10'),
    (3,  'CHK100003', 'checking',  2740.40,  'active', '2023-03-05'),
    (3,  'CRD100003', 'credit',    -620.30,  'active', '2023-08-21'),
    (4,  'SAV100004', 'savings',  23450.00,  'active', '2020-11-12'),
    (5,  'CHK100005', 'checking',  5100.15,  'active', '2022-09-03'),
    (6,  'CHK100006', 'checking',  1850.65,  'active', '2019-04-18'),
    (6,  'SAV100006', 'savings',   8900.00,  'active', '2019-04-18'),
    (7,  'CHK100007', 'checking',  3975.00,  'active', '2024-01-22'),
    (8,  'CRD100008', 'credit',   -1450.75,  'frozen', '2021-10-09'),
    (8,  'CHK100008', 'checking',     0.00,  'closed', '2020-05-14'),
    (9,  'SAV100009', 'savings',   7200.00,  'active', '2023-12-01'),
    (10, 'CHK100010', 'checking',  2800.00,  'active', '2022-07-19'),
    (10, 'SAV100010', 'savings',  10300.00,  'active', '2022-07-19');

INSERT INTO merchants(merchant_name, category, city, state, is_active)
VALUES
    ('FreshMart Grocery',      'groceries',       'Dallas',        'Texas',         TRUE),
    ('TechZone Electronics',   'electronics',     'Austin',        'Texas',         TRUE),
    ('Green Leaf Cafe',        'dining',           'Houston',       'Texas',         TRUE),
    ('Metro Fuel',             'fuel',             'Denver',        'Colorado',      TRUE),
    ('StreamFlix',             'entertainment',    'Los Angeles',   'California',    TRUE),
    ('FitLife Gym',            'fitness',          'Seattle',       'Washington',    TRUE),
    ('City Pharmacy',          'healthcare',       'Chicago',       'Illinois',      TRUE),
    ('Book Haven',             'books',            'Boston',        'Massachusetts', TRUE),
    ('SkyJet Airlines',        'travel',           'Atlanta',       'Georgia',       TRUE),
    ('StyleHub',               'clothing',         'Phoenix',       'Arizona',       TRUE),
    ('QuickBite Restaurant',   'dining',           'Denton',        'Texas',         TRUE),
    ('HomeWorks',              'home_improvement', 'Dallas',        'Texas',         TRUE),
    ('RideNow Transport',      'transportation',   'San Francisco', 'California',    TRUE),
    ('CloudSoft Services',     'software',         'Austin',        'Texas',         TRUE),
    ('Sunshine Hotel',         'travel',           'Orlando',       'Florida',       FALSE);

INSERT INTO transactions(account_id, merchant_id, reference_number, transaction_timestamp, transaction_type, amount, transaction_status, channel, description, balance_after_transaction)
VALUES 
    (1, NULL, 'TXN202601001', '2026-01-05 09:15:00+00',
     'deposit', 3000.00, 'completed', 'branch',
     'Payroll deposit', 5300.00),

    (1, 1, 'TXN202601002', '2026-01-07 18:30:00+00',
     'purchase', 120.45, 'completed', 'pos',
     'Weekly groceries', 5179.55),

    (1, 2, 'TXN202601003', '2026-01-12 14:10:00+00',
     'purchase', 899.99, 'completed', 'online',
     'Laptop purchase', 4279.56),

    (1, 2, 'TXN202601004', '2026-01-25 11:45:00+00',
     'refund', 200.00, 'completed', 'online',
     'Partial laptop refund', 4479.56),

    (1, 3, 'TXN202602005', '2026-02-03 13:20:00+00',
     'purchase', 28.81, 'completed', 'pos',
     'Lunch purchase', 4450.75),

    (1, NULL, 'TXN202604006', '2026-04-10 16:00:00+00',
     'transfer', 200.00, 'completed', 'mobile',
     'Transfer to savings', 4250.75),

    -- Maya's savings account
    (2, NULL, 'TXN202602007', '2026-02-01 10:00:00+00',
     'deposit', 1000.00, 'completed', 'mobile',
     'Monthly savings deposit', 14500.00),

    (2, NULL, 'TXN202604008', '2026-04-01 10:00:00+00',
     'deposit', 700.00, 'completed', 'online',
     'Additional savings deposit', 15200.00),

    -- Ethan's checking account
    (3, NULL, 'TXN202601009', '2026-01-03 08:45:00+00',
     'deposit', 2800.00, 'completed', 'branch',
     'Payroll deposit', 3600.00),

    (3, 1, 'TXN202601010', '2026-01-08 17:40:00+00',
     'purchase', 95.20, 'completed', 'pos',
     'Grocery purchase', 3504.80),

    (3, 4, 'TXN202602011', '2026-02-20 19:15:00+00',
     'purchase', 64.55, 'completed', 'pos',
     'Fuel purchase', 3440.25),

    (3, NULL, 'TXN202603012', '2026-03-10 12:30:00+00',
     'withdrawal', 260.00, 'completed', 'atm',
     'ATM cash withdrawal', 3180.25),

    -- Sofia's checking account
    (4, NULL, 'TXN202601013', '2026-01-15 09:05:00+00',
     'deposit', 2500.00, 'completed', 'branch',
     'Payroll deposit', 3000.00),

    (4, 3, 'TXN202601014', '2026-01-18 20:20:00+00',
     'purchase', 45.60, 'completed', 'pos',
     'Dinner purchase', 2954.40),

    (4, 1, 'TXN202602015', '2026-02-07 15:10:00+00',
     'purchase', 134.00, 'completed', 'pos',
     'Grocery purchase', 2820.40),

    (4, 13, 'TXN202603016', '2026-03-02 18:45:00+00',
     'purchase', 80.00, 'completed', 'mobile',
     'Transportation expense', 2740.40),

    (4, 9, 'TXN202603017', '2026-03-15 07:30:00+00',
     'purchase', 320.00, 'reversed', 'online',
     'Reversed airline booking', 2740.40),

    -- Sofia's credit account
    (5, 2, 'TXN202601018', '2026-01-20 14:35:00+00',
     'purchase', 500.00, 'completed', 'online',
     'Electronics purchase', -500.00),

    (5, 10, 'TXN202602019', '2026-02-11 16:50:00+00',
     'purchase', 170.30, 'completed', 'pos',
     'Clothing purchase', -670.30),

    (5, 10, 'TXN202603020', '2026-03-05 11:25:00+00',
     'refund', 50.00, 'completed', 'pos',
     'Clothing return', -620.30),

    -- Noah's savings account
    (6, NULL, 'TXN202601021', '2026-01-06 09:00:00+00',
     'deposit', 2000.00, 'completed', 'online',
     'Savings deposit', 22000.00),

    (6, NULL, 'TXN202602022', '2026-02-06 09:00:00+00',
     'deposit', 1500.00, 'completed', 'mobile',
     'Savings deposit', 23500.00),

    (6, NULL, 'TXN202604023', '2026-04-06 13:10:00+00',
     'withdrawal', 50.00, 'completed', 'atm',
     'ATM withdrawal', 23450.00);

-- BATCH 2 (ACCOUNTS 7-15)

INSERT INTO transactions (
    account_id,
    merchant_id,
    reference_number,
    transaction_timestamp,
    transaction_type,
    amount,
    transaction_status,
    channel,
    description,
    balance_after_transaction
)
VALUES
    -- Ava's checking account
    (7, NULL, 'TXN202601024', '2026-01-10 09:10:00+00',
     'deposit', 4500.00, 'completed', 'branch',
     'Payroll deposit', 5500.00),

    (7, 6, 'TXN202602025', '2026-02-10 08:00:00+00',
     'purchase', 99.85, 'completed', 'online',
     'Gym membership', 5400.15),

    (7, 1, 'TXN202603026', '2026-03-10 17:25:00+00',
     'purchase', 200.00, 'completed', 'pos',
     'Grocery purchase', 5200.15),

    (7, NULL, 'TXN202604027', '2026-04-10 15:00:00+00',
     'transfer', 100.00, 'completed', 'mobile',
     'Transfer to another account', 5100.15),

    -- Liam's checking account
    (8, NULL, 'TXN202601028', '2026-01-05 08:30:00+00',
     'deposit', 2000.00, 'completed', 'branch',
     'Payroll deposit', 2200.00),

    (8, 7, 'TXN202601029', '2026-01-20 13:15:00+00',
     'purchase', 149.35, 'completed', 'pos',
     'Pharmacy purchase', 2050.65),

    (8, 8, 'TXN202602030', '2026-02-15 19:40:00+00',
     'purchase', 50.00, 'completed', 'online',
     'Book purchase', 2000.65),

    (8, NULL, 'TXN202603031', '2026-03-01 10:20:00+00',
     'withdrawal', 150.00, 'completed', 'atm',
     'ATM cash withdrawal', 1850.65),

    -- Liam's savings account
    (9, NULL, 'TXN202604032', '2026-04-01 09:30:00+00',
     'deposit', 900.00, 'completed', 'mobile',
     'Monthly savings deposit', 8900.00),

    -- Emma's checking account
    (10, NULL, 'TXN202601033', '2026-01-04 08:00:00+00',
     'deposit', 3500.00, 'completed', 'branch',
     'Payroll deposit', 4500.00),

    (10, 9, 'TXN202601034', '2026-01-30 06:45:00+00',
     'purchase', 400.00, 'completed', 'online',
     'Airline ticket', 4100.00),

    (10, 5, 'TXN202602035', '2026-02-28 20:00:00+00',
     'purchase', 25.00, 'completed', 'online',
     'Monthly streaming subscription', 4075.00),

    (10, 11, 'TXN202604036', '2026-04-05 18:35:00+00',
     'purchase', 100.00, 'completed', 'pos',
     'Restaurant purchase', 3975.00),

    -- Lucas's credit account
    (11, 9, 'TXN202601037', '2026-01-15 07:00:00+00',
     'purchase', 1200.00, 'completed', 'online',
     'Airline ticket', -1200.00),

    (11, 10, 'TXN202602038', '2026-02-17 16:10:00+00',
     'purchase', 250.75, 'completed', 'online',
     'Clothing purchase', -1450.75),

    (11, 2, 'TXN202603039', '2026-03-20 14:20:00+00',
     'purchase', 999.00, 'declined', 'online',
     'Declined electronics purchase', NULL),

    -- Lucas's closed checking account
    (12, NULL, 'TXN202601040', '2026-01-01 09:00:00+00',
     'deposit', 500.00, 'completed', 'branch',
     'Initial deposit', 500.00),

    (12, NULL, 'TXN202601041', '2026-01-28 11:00:00+00',
     'withdrawal', 500.00, 'completed', 'branch',
     'Account closing withdrawal', 0.00),

    -- Olivia's savings account
    (13, NULL, 'TXN202603042', '2026-03-01 09:45:00+00',
     'deposit', 1000.00, 'completed', 'mobile',
     'Savings deposit', 7200.00),

    -- Arjun's checking account
    (14, NULL, 'TXN202601043', '2026-01-07 08:15:00+00',
     'deposit', 2500.00, 'completed', 'branch',
     'Payroll deposit', 3200.00),

    (14, 1, 'TXN202601044', '2026-01-15 18:05:00+00',
     'purchase', 140.00, 'completed', 'pos',
     'Grocery purchase', 3060.00),

    (14, 11, 'TXN202602045', '2026-02-12 19:30:00+00',
     'purchase', 60.00, 'completed', 'pos',
     'Restaurant purchase', 3000.00),

    (14, NULL, 'TXN202603046', '2026-03-12 12:00:00+00',
     'withdrawal', 200.00, 'completed', 'atm',
     'ATM cash withdrawal', 2800.00),

    (14, 14, 'TXN202604047', '2026-04-15 10:10:00+00',
     'purchase', 19.99, 'pending', 'online',
     'Pending software subscription', NULL),

    -- Arjun's savings account
    (15, NULL, 'TXN202604048', '2026-04-02 09:20:00+00',
     'deposit', 300.00, 'completed', 'mobile',
     'Monthly savings deposit', 10300.00);

COMMIT;