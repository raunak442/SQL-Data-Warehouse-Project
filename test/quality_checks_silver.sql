/*
=====================================================================
Quality Checks
=====================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy,
  and standardization across various tables of the 'silver' schema. It includes
  checks for:
    - Null or Duplicate primary keys
    - Unwanted spaces in string fields
    - Data standardization and consistency
    - Invalid date ranges and orders
    - Data consistency between related fields

Usage Notes:
    - Run these checks after loading 'silver' layer.
    - Investigate and resolve any discrepancies found during the checks.
======================================================================
*/

/*
===================================
Checking 'silver.crm_cust_info'
===================================
Check for Nulls or duplicates in primary key
*/
SELECT
	cst_id,
	COUNT(cst_id)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(cst_id) > 1 OR cst_id IS NULL;

SELECT
	cst_key,
	COUNT(cst_key)
FROM silver.crm_cust_info
GROUP BY cst_key
HAVING COUNT(cst_key) > 1 OR cst_key IS NULL;

-- Check for unwanted spaces
SELECT
	cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

SELECT
	cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT
	cst_marital_status
FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT
	cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- Data Standardization and Consistency
SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info;



/*
=========================================
Checking 'silver.crm_prd_info'
=========================================
Check for Nulls or Duplicates in Primary Key
*/
SELECT
	prd_id,
	COUNT(prd_id)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(prd_id) > 1 OR prd_id IS NULL;

SELECT
	prd_key,
	COUNT(prd_key)
FROM silver.crm_prd_info
GROUP BY prd_key
HAVING COUNT(prd_key) > 1 OR prd_key IS NULL;


-- Check for Unwanted spaces
SELECT
	cat_id
FROM silver.crm_prd_info
WHERE cat_id != TRIM(cat_id);

SELECT
	prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

SELECT
	prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line);

-- Data Standardization and Consistency
SELECT DISTINCT
	prd_line
FROM silver.crm_prd_info;

-- Check for invalid date orders ( start date > end date OR no start date)
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;
	
SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_start_dt IS NULL;



/*
=========================================
Checking 'silver.crm_sales_details'
=========================================
Check for Nulls or Duplicates in Primary Key
*/
SELECT
	sls_ord_num,
	COUNT(*)
FROM silver.crm_sales_details
GROUP BY sls_ord_num
HAVING COUNT(*) > 1 OR sls_ord_num IS NULL;

-- Check for Unwanted spaces
SELECT
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key != TRIM(sls_prd_key);

SELECT
	sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

-- Check for invalid entries
SELECT
	sls_prd_key
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info)

SELECT
	sls_cust_id
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info)

-- Check for Invalid date entries
SELECT
	sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt AND sls_ship_dt > sls_due_dt;

-- Data standardization and consistency
SELECT 
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;



/*
=========================================
Checking 'silver.erp_cust_az12'
=========================================
Check for Nulls or Duplicates in Primary Key
*/
SELECT
	cid,
	COUNT(*)
FROM silver.erp_cust_az12
GROUP BY cid
HAVING COUNT(*) > 1;

-- Check for invalid birth dates (which are in future)
SELECT 
	bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

-- Check for data standardization and consistency
SELECT DISTINCT
	gen 
FROM silver.erp_cust_az12;




/*
=========================================
Checking 'silver.erp_loc_a101'
=========================================
Check for Nulls or Duplicates in Primary Key
*/
SELECT
	cid,
	COUNT(*)
FROM silver.erp_loc_a101
GROUP BY cid
HAVING COUNT(*) > 1;

-- Check for data standardization and consistency
SELECT DISTINCT
	cntry
FROM silver.erp_loc_a101



/*
=========================================
Checking 'silver.erp_px_cat_g1v2'
=========================================
Check for Nulls or Duplicates in Primary Key
*/
SELECT
	id,
	COUNT(*)
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

-- Check for data standardization and consistency
SELECT DISTINCT
	cat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
	subcat
FROM silver.erp_px_cat_g1v2;

SELECT DISTINCT
	maintenance
FROM silver.erp_px_cat_g1v2;

-- Check for unwanted spaces
SELECT
	*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
OR subcat != TRIM(subcat)
OR maintenance != TRIM(maintenance);
