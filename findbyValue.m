function records = findbyValue(tbl, key, value)
    % getFundamentals fetches company fundamentals from Alphavantage
    % INPUTS:
    % tbl is a table
    % type is a report type: 
    % key is column name in tbl 
    % value is a searched value
    % OUTPUT:
    % records is a table with all records containing the value
    
    records = tbl(tbl.(key) == value, :);
end