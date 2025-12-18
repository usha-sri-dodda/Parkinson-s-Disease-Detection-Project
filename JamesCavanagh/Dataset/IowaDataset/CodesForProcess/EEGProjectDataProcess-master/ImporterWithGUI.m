%% EEG File Importer by Fahim

%% Process CC Task
clear; 
close all;
clc;







%% GUI
   %  Create and then hide the UI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,650,285]);
   
   %  Construct the components.
   hsurf = uicontrol('Style','pushbutton','String','Select EEGlab File',...
           'Position',[415,220,200,25], 'Callback', @b1);
   hmesh = uicontrol('Style','pushbutton','String','Select EEG Header File',...
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

     I = imread('logo1.png');
 RI = imref2d(size(I));
RI.XWorldLimits = [0 3];
RI.YWorldLimits = [2 5];
imshow(I,RI);
%% 
  function b1(nn,mm)
% Get Locs: find this path from the install dir of eeglab
global locpath


[~,locpath] = uigetfile('*.elp',...
                        'Select standard-10-5-cap385.elp From EEGLab Installation ');
locpath=[locpath,'standard-10-5-cap385.elp'];  
end







                    
  function b2(nn,mm)         

global files
global path 

% get Raw File location from user
[files,path] = uigetfile('*.vhdr',...
   'Select One or More EEG Header Files', ...
   'MultiSelect', 'on'); 
  end


  function b3(nn,mm)   
% Get save location from user
global path 
global savelocation
[savelocation]=uigetdir(path,'Select the Folder to save Data');

  end






function b4(nn,mm)
global locpath
global files
global path 
global savelocation


% starting_location=pwd; 
% Data are here
datalocation=path; 
cd(datalocation);

Total_files=size(files,2);
% CTLsx=[8070,8060,890:914];

%% ##########################   TRN = training; TST = testing; FB = Reward and punishment
for subj=1:Total_files
    for session=1         
        if 1 %(subj>850 && session==1) || subj<850  % If not ctl, do session 2
            if 1 %exist([num2str(subj),'_Session_',num2str(session),'_PDDys_CC.mat'])~=2;
                
                disp(['Do CC --- Subno: ',num2str(subj),'      Session: ',num2str(session)]); disp(' ');
                                
                TRN_STIM={'S111','S112','S113','S114','S121','S122','S123','S124','S211','S212','S213','S214','S221','S222','S223','S224'};
                TRN_RESP={'S101','S102','S103','S104'};
                TRN_FB={'S  8','S  9'};
                TST_STIM={'S 12','S 13','S 14','S 21','S 23','S 24','S 31','S 32','S 34','S 41','S 42','S 43'};
                TST_RESP={'S  1','S  2','S  3','S  4'};
                All_STIM={'S111','S112','S113','S114','S121','S122','S123','S124','S211','S212','S213','S214','S221','S222','S223','S224','S  8','S  9'...
                    'S 12','S 13','S 14','S 21','S 23','S 24','S 31','S 32','S 34','S 41','S 42','S 43'};
                
                % Data are 68 chans: 1=63 is EEG, 64 is VEOG, 66-68 is XYZ.  Ref'd to CPz - - will want to retrieve that during re-referencing
                eeglab;
                % Load BrainVision data
                EEG = pop_loadbv(datalocation,files{subj});
                
                
                EEG = pop_chanedit(EEG,    'lookup', locpath);
                EEG = eeg_checkset( EEG );  %% get the epoch information from EEG.event
                Filename=erase(files{subj},'.vhdr');
                disp('EEG data created------------')
                %save file
                current_location=pwd;
                %cd ../;
                cd(savelocation);
                save([erase(files{subj},'.vhdr'),'.mat'],'EEG','Filename')
                disp('Data saved ----------------')
                cd(current_location);
                
     
            end
        end
    end
end

disp('Task Completed---------------------------------------------------------------')
mf = msgbox('Operation Completed !');
end