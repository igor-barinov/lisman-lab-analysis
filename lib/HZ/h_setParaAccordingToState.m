function h_setParaAccordingToState(menuName)

global h_img;

if isfield(h_img.state,menuName)
    Data = eval(['h_img.state.',menuName]);
    handles = h_img.currentHandles;
    
    names = fieldnames(Data);
    
    for i = 1:length(names)
        try
            ptynames = fieldnames(eval(['Data.',names{i}]));
            handlename = ['handles.',names{i}];
            for j = 1:length(ptynames)
                varname = ['Data.',names{i},'.',ptynames{j}];
                set(eval(handlename),ptynames{j},eval(varname));
            end
        end
    end
end
