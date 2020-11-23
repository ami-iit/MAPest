
% Copyright (C) 2020 Istituto Italiano di Tecnologia (IIT)
% All rights reserved.
%
% This software may be modified and distributed under the terms of the
% GNU Lesser General Public License v2.1 or any later version.

%% Load and extract data from SPEXOR table
% % Generic raw info table (labels)
% EXO.tableLabels = {'torsoAngle'; % beta, [rad]
% 'beamHeight';                % L-deltax, [m]
% 'beamDeviation';             % delta_y, [m]
% 'beamLength';                % L, [m]
% 'beamDeflection';            % phi_L, [rad]
% 'force';                     % F, [N]
% 'beamBaseMoment'};           % mu,[Nm]
EXO.betaInRad = (0:0.001:0.899)';

tmp.numberOfBeams = 7;
tmp.beamLabels = {'beam28';
    'beam30';
    'beam32';
    'beam34';
    'beam36';
    'beam38';
    'beam40'};

% --- 28 lenght beam
tmp.beam28.filename = fullfile(bucket.datasetRoot, '/SPEXORmeas/beam_28cm.csv');
tmp.beam28.rawTable = readtable(tmp.beam28.filename);
tmp.beam28.newArray = table2array(tmp.beam28.rawTable(:,2:end));
tmp.beam28.newArray = [EXO.betaInRad, tmp.beam28.newArray];

for beamIdx = 1 : tmp.numberOfBeams
    EXO.extractedTable(beamIdx).labels = tmp.beamLabels{beamIdx};
    EXO.extractedTable(beamIdx).betaInRad = EXO.betaInRad;
    if beamIdx == 1
        EXO.extractedTable(beamIdx).beamHeight     = tmp.beam28.newArray(:,2);
        EXO.extractedTable(beamIdx).beamDeviation  = tmp.beam28.newArray(:,3);
        EXO.extractedTable(beamIdx).beamLength     = tmp.beam28.newArray(:,4);
        EXO.extractedTable(beamIdx).beamDeflection = tmp.beam28.newArray(:,5);
        EXO.extractedTable(beamIdx).force          = tmp.beam28.newArray(:,6);
        EXO.extractedTable(beamIdx).beamBaseMoment = tmp.beam28.newArray(:,7);
        % Definition of alpha angle in [rad] --> (90deg - beta)
        EXO.extractedTable(beamIdx).alpha          = 1.508 - EXO.betaInRad;
    end
end
