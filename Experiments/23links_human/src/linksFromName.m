
% SPDX-FileCopyrightText: Fondazione Istituto Italiano di Tecnologia (IIT)
% SPDX-License-Identifier: BSD-3-Clause

function [linkStruct, found] = linksFromName(TotalLinksStruct, linkName)
% LINKSFROMNAME returns the struct related to the link string you
% are looking for.
%
% Inputs:
% - TotalLinkStruct : struct with the amount of links;
% - linkName        : string denoting the link you are looking for;
%
% Outputs:
% - linkStruct      : struct related to a link;
% - found           : true if link has been found, false otherwise.
%
% Author(s): Claudia Latella
% Dynamic Interaction Control, Istituto Italiano di Tecnologia

for indx = 1 : size(TotalLinksStruct,1)
    if  strcmp(TotalLinksStruct{indx,1}.label,linkName)
        linkStruct = TotalLinksStruct{indx,1};
        found = true;
        break;
    else 
        found = false;
    end   
end
if found == false
    error(sprintf('Something wrong in the acquisition! Link label <%s> not found.',linkName));
end
end