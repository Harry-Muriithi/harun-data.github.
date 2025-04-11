-- Task 1: Top 5 Customers by Total Purchase Amount
SELECT 
    c.CustomerId,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    ROUND(SUM(i.Total), 2) AS TotalSpent
FROM 
    Customer c
JOIN 
    Invoice i ON c.CustomerId = i.CustomerId
GROUP BY 
    c.CustomerId
ORDER BY 
    TotalSpent DESC
LIMIT 5;


-- Task 2: Most Popular Genre by Total Tracks Sold
SELECT 
    g.Name AS Genre,
    COUNT(il.TrackId) AS TracksSold
FROM 
    InvoiceLine il
JOIN 
    Track t ON il.TrackId = t.TrackId
JOIN 
    Genre g ON t.GenreId = g.GenreId
GROUP BY 
    g.GenreId
ORDER BY 
    TracksSold DESC
LIMIT 1;


-- Task 3: Managers and Their Subordinates
SELECT 
    m.EmployeeId AS ManagerId,
    m.FirstName || ' ' || m.LastName AS ManagerName,
    e.EmployeeId AS SubordinateId,
    e.FirstName || ' ' || e.LastName AS SubordinateName
FROM 
    Employee e
JOIN 
    Employee m ON e.ReportsTo = m.EmployeeId
ORDER BY 
    ManagerName;

-- Task 4: Most Sold Album Per Artist
WITH AlbumSales AS (
    SELECT 
        ar.ArtistId,
        ar.Name AS ArtistName,
        al.AlbumId,
        al.Title AS AlbumTitle,
        COUNT(il.InvoiceLineId) AS TracksSold
    FROM 
        InvoiceLine il
    JOIN 
        Track t ON il.TrackId = t.TrackId
    JOIN 
        Album al ON t.AlbumId = al.AlbumId
    JOIN 
        Artist ar ON al.ArtistId = ar.ArtistId
    GROUP BY 
        ar.ArtistId, al.AlbumId
),
MaxSalesPerArtist AS (
    SELECT 
        ArtistId,
        MAX(TracksSold) AS MaxSold
    FROM 
        AlbumSales
    GROUP BY 
        ArtistId
)
SELECT 
    a.ArtistName,
    a.AlbumTitle,
    a.TracksSold
FROM 
    AlbumSales a
JOIN 
    MaxSalesPerArtist m ON a.ArtistId = m.ArtistId AND a.TracksSold = m.MaxSold
ORDER BY 
    a.ArtistName;
    
    -- Task 5: Monthly Sales Trends in 2013
SELECT 
    STRFTIME('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Total), 2) AS MonthlySales
FROM 
    Invoice
WHERE 
    STRFTIME('%Y', InvoiceDate) = '2013'
GROUP BY 
    STRFTIME('%Y-%m', InvoiceDate)
ORDER BY 
    Month;

    

