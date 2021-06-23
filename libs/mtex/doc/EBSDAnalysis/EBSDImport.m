%% Importing EBSD Data
%
%%
% MTEX allows you to import EBSD data from a wide variety of file format.
% In the most simplest case import can be done by the command
% <EBSD.load.html EBSD.load>

ebsd = EBSD.load([mtexEBSDPath filesep 'twins.ctf'],'convertEuler2SpatialReferenceFrame')

%%
% This command automatically detects the file format and generates a
% variable of type <EBSD.EBSD.html EBSD> which contains all the
% information of the EBSD data set. Let us quickly do an orientation plot
% of the Magnesium phase

plot(ebsd('Magnesium'),ebsd('Magnesium').orientations)

%%
% The variable of type EBSD is the starting point for all further analysis,
% e.g., <GrainReconstruction.html grain reconstruction>, <EBSD2ODF.html ODF
% reconstruction>, <EBSDMisorientation misorientation analysis>, etc.
%
%% Importing EBSD data using the import wizard
%
% In many cases however, importing EBSD data is not that straight forward
% as suggested above. The reason is that during the measuring process
% different reference systems are involved and resulting coordinates, i.e.,
% the spatial coordinates and the Euler angles, are often not stored in a
% consistent way by comercials software. Please read
% <EBSDReferenceFrame.html EBSD Reference Systems> for more information
% about how to set up reference frames correctly.
%
% In order to help the user to import EBSD data consistently to fixed
% specimen reference frame, which the user should know, MTEX provide the
% <matlab:import_wizard('EBSD') import wizard> as a graphical user
% interface. The |import_wizard| can be started either by typing into the
% command line

import_wizard('EBSD')

%%
% EBSD Data files can be also imported via the <matlab:filebrowser file
% browser> by choosing _Import Data_ from the context menu of the selected
% file if its file extension was registered with
% <matlab:opentoline(fullfile(mtex_path,'mtex_settings.m'),25,1)
% |mtex_settings.m|>
%
% The import wizard guides through the correct setup of:
%
% * <CrystalSymmetries.html crystal symmetries> associated with phases 
% * specimen symmetry and plotting conventions
% 
% The import wizard allows you to either creates directly a workspace
% variable of type <EBSD.EBSD.html EBSD> or to generates an m-file which
% contains all the customizations and allows you to import the data in
% future sessions without the import wizzard. This last option is highly
% recommended as the created script is also a good starting point for
% further analysis and data processing.
%
%% The Import Script
%
% A script generated by the import wizard has approximately the following form:

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('6/mmm', [3.2 3.2 5.2], 'X||a*', 'Y||b', 'Z||c*',...
  'mineral', 'Magnesium', 'color', [0.53 0.81 0.98])};

% plotting convention
setMTEXpref('xAxisDirection','east');
setMTEXpref('zAxisDirection','outOfPlane');

% path to files
pname = mtexEBSDPath;

% which files to be imported
fname = [pname filesep 'twins.ctf'];

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ctf',...
  'convertEuler2SpatialReferenceFrame');

% Running this script imports the data into a variable named
% |ebsd|. From this point, the script can be extended to your needs, e.g:

plot(ebsd)


%% Supported Data Formats
%
% MTEX supports the following EBSD data formats:
%
% || <loadEBSD_ang.html     .ang> || EDAX ascii files.      || 
% || <loadEBSD_brukertxt.html .txt> || Bruker ascii files. || 
% || <loadEBSD_crc.html     .crc> || Oxford binary files.          || 
% || <loadEBSD_csv.html     .csv> || Oxford single orientation files.   || 
% || <loadEBSD_ctf.html     .ctf> || HKL single orientation files.      || 
% || <loadEBSD_dream3d.html .txt> || Dream 3d single orientation files. || 
% || <loadEBSD_ang.DRex     .DRex> || single orientation files.         || 
% || <loadEBSD_h5.html     .h5, .hdf5> || Bruker, EDAX, Dream 3d binary files. || 
% || <loadEBSD_osc.html     .osc> || EDAX binary files.          || 
% || <loadEBSD_Oxfordcsv.html .csv> || Oxford ascii files.        || 
% || <loadEBSD_generic.html .txt> || ASCII files with Euler angles as columns. || 
%
% If the data is recognized as an ASCII list of orientations, phase and spatial
% coordinates in the form 
%
%  alpha_1 beta_1 gamma_1 phase_1 x_1 y_1
%  alpha_2 beta_2 gamma_2 phase_2 x_2 y_2
%  alpha_3 beta_3 gamma_3 phase_3 x_3 y_3
%  .      .       .       .       .   .
%  .      .       .       .       .   .
%  .      .       .       .       .   .
%  alpha_M beta_M gamma_M phase_m x_m y_m
%
% an additional tool supports you to associated the columns with the
% corresponding properties.
%
%% Writing your own interface
%
% In case that the EBSD format is not supported, you can write an interface
% by your own to import the data. Once you have written such an interface
% that reads data from certain data files and generates an EBSD object you
% can integrate this method into MTEX by copying it into the folder
% |MTEX/qta/interfaces| and rename your function |loadEBSD_xxx|. Then it
% will be automatical recognized by the import wizard. Examples how to
% write such an interface can be found in the directory
% |MTEX/qta/interfaces|.
%
