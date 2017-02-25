function varargout = canny_edge_detec(varargin)
% CANNY_EDGE_DETEC MATLAB code for canny_edge_detec.fig
%      CANNY_EDGE_DETEC, by itself, creates a new CANNY_EDGE_DETEC or raises the existing
%      singleton*.
%
%      H = CANNY_EDGE_DETEC returns the handle to a new CANNY_EDGE_DETEC or the handle to
%      the existing singleton*.
%
%      CANNY_EDGE_DETEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CANNY_EDGE_DETEC.M with the given input arguments.
%
%      CANNY_EDGE_DETEC('Property','Value',...) creates a new CANNY_EDGE_DETEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before canny_edge_detec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to canny_edge_detec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help canny_edge_detec

% Last Modified by GUIDE v2.5 29-Nov-2016 22:29:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @canny_edge_detec_OpeningFcn, ...
    'gui_OutputFcn',  @canny_edge_detec_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before canny_edge_detec is made visible.
function canny_edge_detec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to canny_edge_detec (see VARARGIN)

% Load handles
handles = guidata(hObject);
handles.ROI_valid = false; % Default value
% Save the change you made to the structure
guidata(hObject,handles);
% Choose default command line output for canny_edge_detec
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes canny_edge_detec wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = canny_edge_detec_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in detect_edges.
function detect_edges_Callback(hObject, eventdata, handles)
% hObject    handle to detect_edges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load handles
handles = guidata(hObject);

% Get configuration values to edge detection
thrL = str2double(get(handles.trhL,'String'));
thrH = str2double(get(handles.trhH,'String'));
sigma = str2double(get(handles.sigma,'String'));

% Verify if region was selected
if handles.ROI_valid % Region selected
    % Calculate limits for region
    xmin = handles.xmin_corr;
    ymin = handles.ymin_corr;
    xmax = handles.xmin_corr + handles.width_corr;
    ymax = handles.ymin_corr + handles.height_corr;
    % Call function to executes Canny algorithm
    ROI_edeg_fig = canny_edge(handles.figure(ymin:ymax,xmin:xmax),thrL,thrH,sigma);
    handles.edeg_fig = handles.figure; % Fill with orignal image
    % Change the region to the Canny edge result
    handles.edeg_fig(ymin:ymax,xmin:xmax) = uint8(ROI_edeg_fig)*255;
    axes(handles.edge_img); % Select axe to show result
    imshow(handles.edeg_fig); % Show result
else
    % Call function to executes Canny algorithm
    handles.edeg_fig = canny_edge(handles.figure,thrL,thrH,sigma);
    axes(handles.edge_img); % Select axe to show result
    imshow(handles.edeg_fig); % Show result
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in select_figure.
function select_figure_Callback(hObject, eventdata, handles)
% hObject    handle to select_figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load handles
handles = guidata(hObject);

% Open window to user select the image
[filename,pathname] = uigetfile({'*.jpg;*.tif;*.png;*.gif','All Image Files';...
    '*.*','All Files' },'mytitle',...
    'C:\Work\cameraman.tif');
handles.figure = imread(fullfile(pathname,filename)); % Read image selected
axes(handles.original_img); % Select axes to show image
tag = get(hObject,'Tag'); % Get properties of axe
hFigure = imshow(handles.figure); % Show figure
set(hObject,'Tag',tag); % Set properties of axe
% Config axes to keep working on mouse click, so user can select region
set(hFigure,'ButtonDownFcn', @original_img_ButtonDownFcn);

handles.ROI_valid = false; % Reset region selection

% Update handles structure
guidata(hObject, handles);

% --- Executes on mouse press over axes background.
function original_img_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to edge_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load handles
handles = guidata(hObject);

% Get value from are (rect) selected by user
rect = getrect;
xmin = rect(1);
ymin = rect(2);
width = rect(3);
height = rect(4);
% Get dimensional values from original picture
% [fig_height,fig_width] = size(eventdata.Source.CData);
[fig_height,fig_width] = size(handles.figure);

% Verify xmin from rect and round or correct it.
% If it is out of bounds select start point as 0
if xmin < 0 || xmin > fig_width;
    handles.xmin_corr = 1;
else
    handles.xmin_corr = round(xmin);
end
% Verify ymin from rect and round or correct it.
% If it is out of bounds select start point as 0
if ymin < 0 || ymin > fig_height;
    handles.ymin_corr = 1;
else
    handles.ymin_corr = round(ymin);
end

% Round width and height from rect
handles.width_corr = round(width);
handles.height_corr = round(height);

% If xmin + width is bigger than figure width, give the maximum value
if handles.xmin_corr + handles.width_corr > fig_width
    handles.width_corr = fig_width - handles.xmin_corr;
end

% If ymin + height is bigger than figure heigth, give the maximum value
if handles.ymin_corr + handles.height_corr > fig_height
    handles.height_corr = fig_height - handles.ymin_corr;
end

% Verify valid ROI
if (handles.height_corr >= 0 && handles.height_corr <= fig_height) && ...
        (handles.width_corr >= 0 && handles.width_corr <= fig_width)
    handles.ROI_valid = true;
else
    handles.ROI_valid = false;
end

% Update handles structure
guidata(hObject, handles);
