function [armed, measure, wait, timerout] = FLIM_decode_test_state (display);

global state;

if nargin == 0
    display = 1;
end

status=0;
[out status]=calllib('spcm32','SPC_test_state',state.spc.acq.module,status);

a=dec2bin(double(status));

a = ['0000000000000000000', a];

if display
    b=a(end-0);
    disp(['Stopped on overflow  ', a(end-0)]);
    disp(['Overflow occured  ', a(end-1)]);
    disp(['Stopped on expiration of collection timer  ', a(end-2)]);
    disp(['collection timer expired  ', a(end-3)]);
    disp(['Stopped on user command  ', a(end-4)]);
    disp(['Repeat timer expired  ', a(end-5)]);
    disp(['SPC measure  ', a(end-6)]);
    disp(['Measurement in progress (current bank)  ', a(end-7)]);
    disp(['Second overflow of collection timer  ', a(end-8)]);
    disp(['Second overflow of repeat timer  ', a(end-9)]);
    disp(['Scan ready (data can be read)  ', a(end-10)]);
    disp(['Flow back of scan finished  ', a(end-11)]);
    disp(['Wait for external trigger  ', a(end-12)]);
    disp(['Hardware fill not finished  ', a(end-13)]);
    disp('--------');
end

armed = str2num(a(end-7));
measure = str2num(a(end-6));
wait = str2num(a(end-12));
timerout = str2num(a(end-2));