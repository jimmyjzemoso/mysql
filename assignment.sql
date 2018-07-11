SELECT CUSTOMERNAME, MAX(TP1) AS TOPPRODUCT1, MAX(TP2) AS TOPPRODUCT2
FROM (
	SELECT T.CUSTOMERNAME,
		CASE WHEN T.ROWNO = 1 THEN T.PRODUCTID END AS TP1,
        CASE WHEN T.ROWNO = 2 THEN T.PRODUCTID END AS TP2
	FROM(
  		SELECT ROW_NUMBER() OVER(PARTITION BY CUSTOMERNAME ORDER BY SUMQUANTITY DESC, REVENUE DESC) AS ROWNO,
  		CUSTOMERNAME,
  		PRODUCTID,
  		SUMQUANTITY,
  		REVENUE 
  		FROM (
  			SELECT V1.CUSTOMERNAME,
  			V1.PRODUCTID,
  			SUM(V1.QTY) AS SUMQUANTITY,
  			SUM(V1.QTY*P.PRICEPERPRODUCT) AS REVENUE 
  			FROM (
  				SELECT C.CUSTOMERNAME,
  				O.PRODUCTID,
  				O.QTY 
  				FROM CUSTOMER C INNER JOIN
  				ORDERTAB O 
  				ON C.CUSTOMERID = O.CUSTOMERID) V1 
  			INNER JOIN PRODUCTTAB P 
  			ON V1.PRODUCTID = P.PRODUCTID 
  			GROUP BY V1.CUSTOMERNAME, V1.PRODUCTID) T1
	) T
) A GROUP BY CUSTOMERNAME