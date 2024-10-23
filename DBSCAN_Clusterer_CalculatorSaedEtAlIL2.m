%% Neal Ramseier 10.29.23
%This code uses some inspiration from an unpublished program written by Jesse Anderson to create a struct to store cluster information. 
%This code inputs the X and Y coordinates from ThunderSTORM reconstruction and clusters the data using DBSCAN, then calculates the maximum diameter of the clusters. 

%% Close all and Import Data
tic;
clear variables; close all; clc; close all hidden;
disp("Previous Data Cleared; Program Initializing"); 
if not(isfolder('MATLABData'))
    mkdir('MATLABData')
end
currentFolder = string(pwd)+'\MATLABData\';
[fname,directory] = uigetfile('*.csv','Please choose a .csv file'); %the user selects a file
fileName = fullfile(directory, fname); %takes directory/filename.txt and stores to fullname var
Data = readmatrix(fileName);%reads in file to Data var
RawXData = Data(:,3); %separate X data
RawYData = Data(:,4); %separate Y data
RawXYData = [RawXData,RawYData];
Xmin = min(RawXData); Xmax = max(RawXData); Ymin = min(RawYData); Ymax = max(RawYData);
figure();
scatter(RawXData, RawYData,6,'filled');
axis equal;
xlim([Xmin-1000 Xmax+1000]);
ylim([Ymin-1000 Ymax+1000]);
disp("Data Loaded");
%% Cluser using DBSCAN
%This section of code clusters the data using DBSCAN. The clustered data is
%then denoised (remove any points determined as noise). The clustered data
%is then organized into a struct for goruping. 

%Change these two values below to tweak the clustering of the data.
minPTS = 7; %Set to the minimum nuber of points you want in a single cluster
Epsilon = 10; %Set the search radius to find those minimum number of points

Clusters = struct; clusterLabel = [];
disp("Begin Clustering");
ClusterID = dbscan(RawXYData,Epsilon,minPTS); %perform the DBSCAN clustering of the X and Y data
CleanData=[RawXData,RawYData,ClusterID]; %set up for removing noise points
[ClusterID2,val]=find(CleanData==-1); %find noise points  
CleanData(ClusterID2,:)=[]; % remove noise points
X = CleanData(:,1); Y = CleanData(:,2); ID = CleanData(:,3); q=1;
for n = 1:max(ClusterID)
    temp = ID(CleanData(:,3)==n);
    for iii =  1:length(temp)
        clusterLabel(iii,1) = q;
    end
    holdData = horzcat(X(CleanData(:,3)==n), Y(CleanData(:,3)==n),clusterLabel); %find clusters of 1:X and sort into XY
    j=strcat('Cluster ',num2str(q)); 
    q = q+1; 
    Clusters.(j) = holdData;
    clear clusterLabel
end
figure()
gscatter(X,Y,ID);
TheLegend = legend({' '}); 
set(TheLegend,'visible','off'); 
xlabel("X"); ylabel("Y"); title("Denoised Clusters");
axis equal; xlim([Xmin-1000 Xmax+1000]); ylim([Ymin-1000 Ymax+1000]);
%% Attribute Calculation of Clusters
%This section of code calculates the max diameter of each cluster. 
disp("Calculating");
nameCluster = 'Cluster'; MDHold = []; numberOfClusters = q-1; clusterIDHold = [];
for i =1:numberOfClusters %create convex hull and store areas, perimeter, and circularity in Clusters struct
    holdTheCluster = Clusters.(['Cluster',num2str(i)]);
    X = holdTheCluster(:,1);
    Y = holdTheCluster(:,2);
    C = holdTheCluster(:,3);
    if length(X) < 4 %leave out clusters with less than 4 
        continue
    end
    %Maximum Diameter of Cluster
    xydistances = pdist2([X,Y],[X,Y]);
    maxDiameter = max(xydistances(:));
    MDHold = [MDHold;maxDiameter];
    clusterIDHold = [clusterIDHold;C];
    f =strcat(nameCluster,num2str(i),'MaxDiameter'); 
    Clusters.(f) = maxDiameter; 
end
%% Values
% This section calculates the average max diameter for the clusters in the
% whole ROI. We also calculate the percent of clusters there are with a
% max diameter over ___. 
totalAverageMD = sum(MDHold)/length(MDHold);
disp("Average Maximum Diameter for ROI: " + totalAverageMD);
g = 0;
MDThresh = 140;    %max diameter threshold
for i=1:length(MDHold)
    if MDHold(i) > MDThresh
        g = g + 1;
    end
end
percentMD = 100 * (g / length(MDHold));
disp("Percent of Clusters with Maximum Diameter > " + MDThresh + ": " + percentMD+"%");
%% Import csv and write into it
disp('Prepare for Export');disp(' ');
%Create Matricies of the sorted data to prep for export
exportSortedData = [clusterIDHold,MDHold];
writematrix(exportSortedData,currentFolder+"MVClustersTotal.csv",'WriteMode','append');
disp('All Done.');
toc;
