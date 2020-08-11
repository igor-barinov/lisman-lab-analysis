function yphys_nowincell;

global state;

nowincell = state.spc.yphys;
if ~exist([state.files.savePath, '\spc'])
    cd (state.files.savePath);
    mkdir('\spc');
end
cd ([state.files.savePath, '\spc']);
save('nowincell', 'nowincell');
    