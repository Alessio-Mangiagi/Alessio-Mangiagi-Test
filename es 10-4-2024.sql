SELECT
   Productkey,
   productalternatekey,
   englishproductname,
   color,
   standardcost,
   FinishedGoodsFlag 
from dimproduct
where FinishedGoodsFlag = 1;



select
    ProductAlternateKey,
	ProductKey,
	ModelName,
    EnglishProductName,
	ListPrice,
	StandardCost,
    listprice - StandardCost as ricavo 
from dimproduct
where ProductAlternateKey like 'fr%' or 'bk%';


select
	ProductAlternateKey,
	ProductKey,
	ModelName,
    EnglishProductName,
    ListPrice,
    StandardCost,
    listprice - StandardCost as ricavo 
from dimproduct
-- WHERE ListPrice >= 1000 AND ListPrice <= 2000 ;
where ListPrice between 1000 and 2000;



select 
   EmployeeKey,
   Title,
   SalesPersonFlag,
   FirstName + LastName as CompleteName
FROM dimemployee
where SalesPersonFlag = 1 ;


select
SalesOrderNumber,
ProductKey,
OrderDate,
SalesAmount - TotalProductCost as profitto
from factresellersales
where ProductKey  in ('597' , '598' , '477' , '214' )
   
   

