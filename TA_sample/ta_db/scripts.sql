CREATE TABLE branch_product_1(
product uuid NOT NULL,
branch uuid NOT NULL,
balance numeric NOT NULL,
reserve  numeric NOT NULL,
transit numeric NOT NULL,
FOREIGN KEY (product) REFERENCES products_1(product_id),
FOREIGN KEY (branch) REFERENCES stores_1(branch_id)
);

CREATE TABLE dc_product_1(
product uuid NOT NULL,
dc uuid NOT NULL,
balance numeric NOT NULL,
reserve  numeric NOT NULL,
transit numeric NOT NULL,
FOREIGN KEY (product) REFERENCES products_1(product_id)
);


CREATE TABLE tbl_logdays_1(
branch_id uuid NULL,
category_id uuid NULL,
logdays numeric NULL,
FOREIGN KEY (branch_id) REFERENCES stores_1(branch_id)
);

CREATE TABLE stores_1(
branch_id uuid UNIQUE NULL,
priority numeric NULL
);

CREATE TABLE needs_1(
branch_id uuid NULL,
product_id uuid NULL,
needs int NULL,
FOREIGN KEY (product_id) REFERENCES products_1(product_id),
FOREIGN KEY (branch_id) REFERENCES stores_1(branch_id)
);

CREATE TABLE products_1 (
product_id uuid UNIQUE NULL,
category_id uuid NULL,
FOREIGN KEY (category_id) REFERENCES categories_1 (category_id)
);

CREATE TABLE categories_1 (
category_id uuid UNIQUE
);

INSERT INTO tbl_logdays_1 (branch_id, category_id, logdays)
SELECT
  s.branch_id AS branch_id,
  c.category_id AS category_id,
  7 AS logdays
FROM categories_1 c
CROSS JOIN stores_1 s;

INSERT INTO needs_1 (branch_id, product_id, needs)
SELECT
  bp.branch as branch,
  pr.product_id as product,
  FLOOR(1 + RANDOM() * (LEAST(150, bp.balance) * tl.logdays))::int AS needs
FROM branch_product_1 bp
LEFT JOIN products_1 pr ON bp.product = pr.product_id
LEFT JOIN tbl_logdays_1 tl ON pr.category_id = tl.category_id AND tl.branch_id = bp.branch;
