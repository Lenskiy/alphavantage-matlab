function [types, fieldNames] = determineType(record)
    l = 1;
	fieldNames = fields(record(l));
            
	for k = 1:size(fieldNames,1)
        fld = string(getfield(record(l), fieldNames{k}));
        
        if(string(fieldNames{k}).lower.contains("date"))
            types{k} = 'datetime';
            continue;
        end
        
        if(fld.lower == "none")
            for l = 1:size(record,1)
                if(string(fld).lower ~= "none")
                    break;
                end
            end
            if(l == size(record,1))
                % If no values return and it is impossible to determine the
                % type, assume it is a double.
                types{k} = 'double'; 
                continue;
            end
        end
        try
            warning off;
            datenum(fld, 'dd-mmm-yyyy');
            warning on;
            types{k} = 'datetime';
        catch err
            if(isnan(fld.double))
                types{k} = 'string';
            else
                types{k} = 'double';
            end
        end
	end
end