function report = getEconomicIndicators(type, key, options)
    % getEconomicIndicators fetches various economic indicators from Alphavantage
    % INPUTS:
    % type is a report type: 
    %   'REAL_GDP'              - the annual and quarterly Real GDP of the United States.
    %   'REAL_GDP_PER_CAPITA'   - the quarterly Real GDP per Capita data of the United States.
    %   'TREASURY_YIELD'        - the daily, weekly, and monthly US treasury yield of a given maturity timeline (e.g., 5 year, 30 year, etc).
    %   'FEDERAL_FUNDS_RATE'    - the daily, weekly, and monthly federal funds rate (interest rate) of the United States.
    %   'CPI'                   - the monthly and semiannual consumer price index (CPI) of the United States.
    %   'INFLATION'             - the annual inflation rates (consumer prices) of the United States.
    %   'INFLATION_EXPECTATION' - the monthly inflation expectation data of the United States
    %   'CONSUMER_SENTIMENT'    - the monthly consumer sentiment and confidence data of the United States
    %   'RETAIL_SALES'          - the monthly Advance Retail Sales: Retail Trade data of the United States.
    %   'DURABLES'              - the monthly manufacturers' new orders of durable goods in the United States.
    %   'UNEMPLOYMENT'          - the monthly unemployment data of the United States.
    %   'NONFARM_PAYROLL'       - the monthly US All Employees
    % 
    %   'ALL' downloads all above reports
    % OUTPUT:
    % report is a table with requested economic indicator
    % EXAMPLE:
    % report = getEconomicIndicators("TREASURY_YIELD", key, struct("interval", "daily", "maturity", "3month"));
    
	switch upper(type)

        case {'REAL_GDP', 'REAL_GDP_PER_CAPITA', 'FEDERAL_FUNDS_RATE',...
                'CPI', 'INFLATION', 'INFLATION_EXPECTATION',...
                'CONSUMER_SENTIMENT', 'RETAIL_SALES', 'DURABLES',...
                'UNEMPLOYMENT', 'NONFARM_PAYROLL'}
            if(~exist('options','var'))
                options = struct("interval", "daily");
            elseif(~isfield(options, 'interval'))
                options.interval = "daily";
            end
            report = sendRequest(type, key, options);
            report.data = flip(response2table(report.data));  

        case {'TREASURY_YIELD'}
            % interval: strings daily, weekly, and monthly are accepted.
            % maturity: strings 3month, 5year, 10year, and 30year are accepted.
            if(~exist('options','var'))
                options = struct("interval", "daily", "maturity", "3month");
            elseif(~isfield(options, 'interval'))
                options.interval = "daily";
            elseif(~isfield(options, 'maturity'))
                options.maturity = "3month";
            end
            
            report = sendRequest(type, key, options);
            report.data = flip(response2table(report.data));    
            
        otherwise
            error(['Function ', type, ' is not known'])
	end
end

function r = sendRequest(type, key, options)

    url = "https://www.alphavantage.co/query?function=" + type + "&apikey=" + key;
    fnames = fieldnames(options);
    params = "";
    for k = 1:length(fnames)
        params = params + "&" + fnames{k} + "=" + getfield(options, fnames{k});
    end
	try
        r = webread(url + params, 'Timeout', 10);
	catch me 
        pause(1);
        r = webread(url + params, 'Timeout', 10);
    end
	if(isfield(r, 'ErrorMessage'))
        disp(r.ErrorMessage)
	end
end

