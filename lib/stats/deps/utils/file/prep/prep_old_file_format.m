function [fields] = prep_old_file_format(expName)
    rawFields = [expName, ' -> {time, tau_m, mean_int, red_mean}'];
    fields = {rawFields, 'alladj'};
end