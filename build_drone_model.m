%% Auto-build Simulink model for drone altitude control
% Run this in MATLAB — builds and opens the model automatically

mdl = 'drone_altitude_control';
new_system(mdl);
open_system(mdl);

% Add blocks
add_block('simulink/Sources/Step',            [mdl '/Reference']);
add_block('simulink/Math Operations/Sum',     [mdl '/Sum_Error']);
add_block('simulink/Continuous/PID Controller',[mdl '/PID']);
add_block('simulink/Math Operations/Sum',     [mdl '/Sum_Dist']);
add_block('simulink/Sources/Step',            [mdl '/Disturbance']);
add_block('simulink/Continuous/Transfer Fcn', [mdl '/Plant']);
add_block('simulink/Sinks/Scope',             [mdl '/Scope']);

% Position blocks nicely
set_param([mdl '/Reference'],  'Position', [30,  130, 80,  150]);
set_param([mdl '/Sum_Error'],  'Position', [130, 125, 160, 155]);
set_param([mdl '/PID'],        'Position', [220, 115, 310, 165]);
set_param([mdl '/Sum_Dist'],   'Position', [380, 125, 410, 155]);
set_param([mdl '/Disturbance'],'Position', [380, 200, 430, 220]);
set_param([mdl '/Plant'],      'Position', [470, 120, 570, 160]);
set_param([mdl '/Scope'],      'Position', [640, 125, 680, 155]);

% Configure block parameters
set_param([mdl '/Reference'],   'Time',       '0');
set_param([mdl '/Reference'],   'After',      '1');
set_param([mdl '/Sum_Error'],   'Inputs',     '+-');
set_param([mdl '/PID'],         'P',          '15');
set_param([mdl '/PID'],         'I',          '10');
set_param([mdl '/PID'],         'D',          '3');
set_param([mdl '/Sum_Dist'],    'Inputs',     '++');
set_param([mdl '/Disturbance'], 'Time',       '5');
set_param([mdl '/Disturbance'], 'After',      '0.5');
set_param([mdl '/Plant'],       'Numerator',  '[1]');
set_param([mdl '/Plant'],       'Denominator','[1 2 5]');

% Connect blocks
add_line(mdl, 'Reference/1',   'Sum_Error/1');
add_line(mdl, 'Sum_Error/1',   'PID/1');
add_line(mdl, 'PID/1',         'Sum_Dist/1');
add_line(mdl, 'Disturbance/1', 'Sum_Dist/2');
add_line(mdl, 'Sum_Dist/1',    'Plant/1');
add_line(mdl, 'Plant/1',       'Scope/1');
add_line(mdl, 'Plant/1',       'Sum_Error/2', 'autorouting', 'on');

% Simulation settings
set_param(mdl, 'StopTime', '15');
set_param(mdl, 'Solver',   'ode45');

% Save and run
save_system(mdl);
sim(mdl);

disp('Simulink model built and simulated successfully!');