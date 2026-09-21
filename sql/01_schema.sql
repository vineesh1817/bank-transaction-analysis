-- bank transaction schema: customer - accounts - transactions - merchant
BEGIN;

CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(250) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE accounts (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type VARCHAR(20) NOT NULL
      check (account_type IN ('checking', 'savings', 'credit')),
    current_balance NUMERIC(15,2) NOT NULL DEFAULT 0,
    account_status VARCHAR(20) NOT NULL DEFAULT 'active'
      check (account_status IN ('active', 'frozen', 'closed')),
    opened_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_accounts_customer 
      FOREIGN KEY (customer_id)
      REFERENCES customers(customer_id)
      ON DELETE RESTRICT

);

CREATE TABLE merchants (
    merchant_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    merchant_name VARCHAR(150) NOT NULL,
    category VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'US',
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE transactions (
    transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id BIGINT NOT NULL,
    merchant_id BIGINT,
    reference_number VARCHAR(50) NOT NULL UNIQUE,
    transaction_timestamp TIMESTAMPTZ NOT NULL,
    transaction_type VARCHAR(20) NOT NULL
      check (transaction_type IN('deposit', 'withdrawal', 'purchase', 'transfer', 'refund' )),
    amount NUMERIC(15,2) NOT NULL
     CHECK (amount > 0),
    transaction_status varchar(20) NOT NULL
     CHECK (transaction_status IN('pending', 'completed', 'declined', 'reversed')),
    channel VARCHAR(20) NOT NULL
     CHECK (channel IN('online', 'mobile', 'atm', 'pos', 'branch')),
    description VARCHAR(255),
    balance_after_transaction NUMERIC(15,2),

    CONSTRAINT fk_transactions_account
     FOREIGN KEY (account_id)
     REFERENCES accounts(account_id)
     ON DELETE RESTRICT,

    CONSTRAINT fk_transactions_merchants
     FOREIGN KEY (merchant_id)
     REFERENCES merchants(merchant_id)
     ON DELETE SET NULL

      
);

COMMIT;