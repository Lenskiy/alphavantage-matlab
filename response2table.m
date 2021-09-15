function records = response2table(structRecords)
	[types, fieldNames] =  determineType(structRecords);
            
	records = table('Size',[size(structRecords,1), size(fieldNames, 1)],...
                'VariableNames',fieldNames,...
                'VariableTypes', types);
            
	for k = 1:size(structRecords,1)
        for l = 1:size(fieldNames,1)
            val = string(getfield(structRecords(k), fieldNames{l}));
            switch types{l}
                case 'datetime'
                    if(lower(val) == "none")
                        continue;
                    end                    
                    records(k,fieldNames{l}).Variables = datetime(val);
                case 'string'
                    if(lower(val) == "none")
                        continue;
                    end
                    records(k,fieldNames{l}).Variables = val;
                case 'double'
                    if(lower(val) == "none")
                        val = nan;
                    end                    
                    records(k,fieldNames{l}).Variables = str2double(val);
            end
        end
	end
end