function reports = getFundamentals(symbols, type, key)
    % getFundamentals fetches company fundamentals from Alphavantage
    % INPUTS:
    % symbols is an array of tickers
    % type is a report type: 
    %   'OVERVIEW', 
    %   'EARNINGS'
    %   'INCOME_STATEMENT'
    %   'BALANCE_SHEET'
    %   'CASH_FLOW'
    %   'ALL' downloads all above reports
    % OUTPUT:
    % reports contains an array of reports
    % EXAMPLE:
    % reports = getFundamentals(["TSLA","XPEV", "NIO"], "ALL", key);
    
    
    if(iscell(symbols)) %% conver a cell array to a string array
        for k = 1:length(symbols)
            symbolstmp(k) = string(symbols{k});
        end
        symbols = symbolstmp;
    end
    
    for k = 1:length(symbols)
        reports(k) = struct('Symbol', strrep(symbols{k},'.', '-'));
    end
    
    for k = 1:length(symbols)
        if(length(symbols) ~= 1)
            disp([k + " out of " + length(symbols) + " : " +  symbols(k)]);
        end
        

        switch upper(type)
            case {'OVERVIEW'}
                r = sendRequest(type, symbols{k}, key);
                if(lower(string(r.LastSplitFactor)) == "none")
                    r.LastSplitFactor = string(1);
                    r.LastSplitDate = NaT;
                else
                    values = split(string(r.LastSplitFactor), ':').double;
                    r.LastSplitFactor = string(values(1)/values(2));
                end
                reports(k).(type) = response2table(r);

            case {'EARNINGS'}
                r = sendRequest(type, symbols{k}, key);
                reports(k).(type).quarterlyEarnings = flip(response2table(r.quarterlyEarnings));
                reports(k).(type).annualEarnings = flip(response2table(r.annualEarnings));   

            case {'INCOME_STATEMENT', 'BALANCE_SHEET', 'CASH_FLOW'}
                r = sendRequest(type, symbols{k}, key);
                reports(k).(type).quarterlyReport = flip(response2table(r.quarterlyReports));
                reports(k).(type).annualReport = flip(response2table(r.annualReports));   

            case {'ALL'}     
                
                reports(k).('OVERVIEW') = getFundamentals(symbols(k), 'OVERVIEW', key).('OVERVIEW');
                reports(k).('EARNINGS') = getFundamentals(symbols(k), 'EARNINGS', key).('EARNINGS');
                reports(k).('INCOME_STATEMENT') = getFundamentals(symbols(k), 'INCOME_STATEMENT', key).('INCOME_STATEMENT');
                reports(k).('BALANCE_SHEET') = getFundamentals(symbols(k), 'BALANCE_SHEET', key).('BALANCE_SHEET');
                reports(k).('CASH_FLOW') = getFundamentals(symbols(k), 'CASH_FLOW', key).('CASH_FLOW');

                reports(k).quarterlyReport = outerjoin(reports(k).('INCOME_STATEMENT').quarterlyReport, reports(k).('BALANCE_SHEET').quarterlyReport, 'Type', 'Left', 'MergeKeys', true);
                reports(k).quarterlyReport = outerjoin(reports(k).quarterlyReport, reports(k).('CASH_FLOW').quarterlyReport, 'Type', 'Left', 'MergeKeys', true);

                reports(k).annualReport = outerjoin(reports(k).('INCOME_STATEMENT').annualReport, reports(k).('BALANCE_SHEET').annualReport, 'Type', 'Left', 'MergeKeys', true);
                reports(k).annualReport = outerjoin(reports(k).annualReport, reports(k).('CASH_FLOW').annualReport, 'Type', 'Left', 'MergeKeys', true);


            otherwise
                error(['Function ', type, ' is not known'])
        end
    end
end

function r = sendRequest(type, symbol, key)
	try
        r = webread('https://www.alphavantage.co/query', 'function', type,'symbol',strrep(symbol,'.', '-'),'apikey',key, 'Timeout', 10);
	catch me 
        pause(1);
        r = webread('https://www.alphavantage.co/query', 'function', type,'symbol',strrep(symbol,'.', '-'),'apikey',key, 'Timeout', 10);
    end
	if(isfield(r, 'ErrorMessage'))
        disp(r.ErrorMessage)
	end
end

