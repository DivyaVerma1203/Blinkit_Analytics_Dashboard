select * from blinkit_data;

select count(*) from blinkit_data;

select distinct(Item_Fat_Content) from blinkit_data;

--Data Cleaning
update blinkit_data
set Item_Fat_Content =
case
when Item_Fat_Content IN ('LF', 'low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end;

--KPIs
select concat(CAST(SUM(Total_Sales)/1000000 as decimal(10,2)), 'M') as Total_Sales_Millions from blinkit_data;

select CAST(avg(Total_Sales) AS decimal(10,0)) as Avg_Sales from blinkit_data;

select COUNT(*) as No_Of_Items from blinkit_data;

select cast(avg(Rating) as decimal(10,2)) as Avg_Rating from blinkit_data;

--Total Sales by Fat Content
select Item_Fat_Content, CAST(SUM(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Item_Fat_Content;

--Total Sales by Item Type
select Item_Type, CAST(SUM(Total_Sales) as decimal(10,2)) as Total_Sales
from blinkit_data
group by Item_Type
order by Total_Sales desc;

--Fat Content by Outlet for Total Sales
select Outlet_Location_Type, 
       isnull([Low Fat], 0) as Low_Fat, 
       isnull([Regular], 0) as Regular
from
(
    select Outlet_Location_Type, Item_Fat_Content, 
           cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales
    from blinkit_data
    group by Outlet_Location_Type, Item_Fat_Content
) as SourceTable
pivot 
(
    sum(Total_Sales) 
    for Item_Fat_Content in ([Low Fat], [Regular])
) as PivotTable
order by Outlet_Location_Type;

--Total Sales by Outlet Establishment
SELECT Outlet_Establishment_Year, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year;

--Percentage of Sales by Outlet Size
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

--Sales by Outlet Location
SELECT Outlet_Location_Type, CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

--All Metrics by Outlet Type
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;