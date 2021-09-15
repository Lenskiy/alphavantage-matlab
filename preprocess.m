function [records, ind]  = preprocess(records, options)
        ind = 1:size(records, 1);
        if(isfield(options, "extrapolate"))
            [types, fieldNames] = determineType(table2struct(records));

            for k = 1:size(records,2)
                if(strcmp(types{k}, 'double'))
                    records(:, fieldNames{k}) = fillmissing(records(:, fieldNames{k}), options.extrapolate);
                end
            end
        end
        
        
        if(isfield(options,"removeMissingBy"))
            switch(options.removeMissingBy)
                case {"row", "rows"}
                    [records, ind] = rmmissing(records, 1);
                    ind = 1-ind;
                case {"column", "columns"}
                    [records, ~] = rmmissing(records, 2);
                otherwise
            end
        end
        
        if(isfield(options, "toCategorical"))
            for k = 1:length(options.toCategorical)
                if(~isempty(options.toCategorical{k}))
                    records.(options.toCategorical{k}) = grp2idx(categorical(records.(options.toCategorical{k})));
                end
            end
        end

        if(isfield(options, "removeColumns"))
            for k = 1:length(options.removeColumns)
                if(sum(ismember(records.Properties.VariableNames, options.removeColumns{k})))
                    records.(options.removeColumns{k}) = [];
                end
            end
        end
end