function records = extractFields(reports, fieldPath)
    % INPUTS:
    % reports   is an array of reports extracted by getFundamentals
    % fieldPath is an array with subfields that are extracted from all
    %           reports and concatenated
    % OUTPUT:
    % records contains concatenated recrods from all reports
    for k = 1:length(reports)
        symbols(k) = string(reports(k).Symbol);
    end
    % determine the number of rows per record
	tempStruct = reports(1).(fieldPath(1));
	for l = 2:length(fieldPath)
        tempStruct = tempStruct.(fieldPath(l));
    end
    
    if(~istable(tempStruct))
        error('The specified field is not a table');
    end
	if(~ismember('Symbol', tempStruct.Properties.VariableNames))       
            tempStruct = [table(repmat(symbols(1), [size(tempStruct,1),1]), 'VariableName', {'Symbol'}), tempStruct];
    end
    
    records = tempStruct;
     
    for k = 2:length(reports)
        tempStruct = reports(k).(fieldPath(1));
        for l = 2:length(fieldPath)
            tempStruct = tempStruct.(fieldPath(l));
        end
        
        if(~ismember('Symbol', tempStruct.Properties.VariableNames))       
            tempStruct = [table(repmat(symbols(k), [size(tempStruct,1),1]), 'VariableName', {'Symbol'}), tempStruct];
        end
        records = [records; tempStruct];
    end
end