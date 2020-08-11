function ss_setPara(h,Data)

try
    handles = guihandles(h);
    
    names = fieldnames(Data);
    
    for i = 1:length(names)
        if isfield(handles, names{i})
            ptynames = fieldnames(eval(['Data.',names{i}]));
            handlename = ['handles.',names{i}];
            
            for j = 1:length(ptynames)
%                 try
                    varname = ['Data.',names{i},'.',ptynames{j}];
                    set(eval(handlename),ptynames{j},eval(varname));
%                 end
            end
        end
    end
end