%% EEG File Importer by Fahim

%% Process CC Task
clear ; 
close all;
clc;







%% GUI
   %  Create and then hide the UI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,650,285]);

%    I = imread('pout.tif');
%  RI = imref2d(size(I));
% RI.XWorldLimits = [0 3];
% RI.YWorldLimits = [2 5];
% imshow(I,RI);


%  Construct the components.
   hsurf = uicontrol('Style','pushbutton','String','Select Control EEG File',...
           'Position',[415,220,200,25], 'Callback', @b1);
   hmesh = uicontrol('Style','pushbutton','String','Select PD EEG File',...
           'Position',[315,180,200,25], 'Callback', @b2);
   hcontour = uicontrol('Style','pushbutton',...
           'String','Select Save Location',...
           'Position',[315,135,200,25], 'Callback', @b3); 
   htext = uicontrol('Style','pushbutton','String','Start !',...
           'Position',[315,35,200,25], 'Callback', @b4);
%    hpopup = uicontrol('Style','popupmenu',...
%            'String',{'Peaks','Membrane','Sinc'},...
%            'Position',[300,50,100,25]);
   ha = axes('Units','Pixels','Position',[60,70,200,185]); 
   align([hsurf,hmesh,hcontour,htext],'Center','None');

   % Make the UI visible.
   f.Visible = 'on';
     I = imread('logo2.png');
 RI = imref2d(size(I));
RI.XWorldLimits = [0 3];
RI.YWorldLimits = [2 5];
imshow(I,RI);
%% 
  function b1(nn,mm)         

global filesCRTL
global pathCRTL 

% get Raw File location from user
[filesCRTL,pathCRTL] = uigetfile('*.mat',...
   'Select Control Files', ...
   'MultiSelect', 'on'); 
  end







                    
  function b2(nn,mm)         

global filesPD
global pathPD 

% get Raw File location from user
[filesPD,pathPD] = uigetfile('*.mat',...
   'Select PD Files', ...
   'MultiSelect', 'on'); 
  end


  function b3(nn,mm)   
% Get save location from user
global path 
global savelocation
global saveFileName
[savelocation]=uigetdir(path,'Select the Folder to save Data');
dims = [1 35];
saveFileName = inputdlg('Enter The Name For the New File','File Name:',dims);
  end






function b4(nn,mm)

global filesPD
global pathPD 

global filesCRTL
global pathCRTL 

global path 
global savelocation
global saveFileName
clear EEGData;
channels=[];

current_location=pwd;

condition=1; % PD
PDFilenames=cell(size(filesPD,2),1) ;
cd(pathPD)
for subj=1:size(filesPD,2)
        PDFilenames{subj}=erase(filesPD{subj},'.mat');
        %load file
        filename=filesPD{subj};
        load(filename) ;
        disp(['Working on ....' , filename]); 
        Data=EEG.data;
        total_channels=size(Data,1);
        for channel=1:total_channels
            EEGData{channel}{condition}{subj}=(Data(channel,:))';
            
            if size(channels,1)==0
                channels{1}=EEG.chanlocs(channel).labels;
            elseif size(channels,2) < total_channels 
                channels{size(channels,2)+1}=EEG.chanlocs(channel).labels;
            end
        end
end



condition=2; % CRTL 
CrFilenames=cell(size(filesCRTL,2),1) ;
cd(pathCRTL)
for subj=1:size(filesCRTL,2)
        CrFilenames{subj}=erase(filesCRTL{subj},'.mat');
        %load file
        filename=filesCRTL{subj};
        load(filename) ;
        disp(['Working on ....' , filename]); 
        Data=EEG.data;
        total_channels=size(Data,1);
        for channel=1:total_channels
            EEGData{channel}{condition}{subj}=(Data(channel,:))';
            
            if size(channels,1)==0
                channels{1}=EEG.chanlocs(channel).labels;
            elseif size(channels,2) < total_channels 
                channels{size(channels,2)+1}=EEG.chanlocs(channel).labels;
            end
        end
end



disp('Data Created');
Channel_location=channels;
clear EEG;
EEG=EEGData;

Filenames=cell(1,2);
Filenames{1}=PDFilenames;
Filenames{2}=CrFilenames;

cd(savelocation);
disp('Data Saving......')
save([saveFileName{1},'.mat'],'EEG','Channel_location','Filenames','-v7.3');
disp('Data saved !');
cd(current_location);
disp('Task Completed---------------------------------------------------------------')
mf = msgbox('Operation Completed !');
end