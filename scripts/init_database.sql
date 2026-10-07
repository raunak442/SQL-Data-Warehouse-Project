/*
=================================================
CREATE DATABASE AND SCHEMAS
=================================================
Script Purpose: 
    This script creates a new Database named 'DataWarehouse' after checking if it already exists.
    If the Database exists, it is dropped and recreated. Additionaly, the three scripts set up three schemas
    within the database 'bronze' , 'silver' and 'gold'.
Warning:
    Running this script will drop entire 'DataWarehouse' Database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' Database
IF EXISTS(SELECT 1 FROM sys.database WHERE name = 'DataWarehouse')
BEGIN
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' Database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
