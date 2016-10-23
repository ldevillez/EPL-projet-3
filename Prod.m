function varargout = Prod(varargin)
% PROD MATLAB code for Prod.fig
%      PROD, by itself, creates a new PROD or raises the existing
%      singleton*.
%
%      H = PROD returns the handle to a new PROD or the handle to
%      the existing singleton*.
%
%      PROD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROD.M with the given input arguments.
%
%      PROD('Property','Value',...) creates a new PROD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Prod_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Prod_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
global slider3 slider7 TRef TWGS MMeth MEau edit3 edit4;
format bank
% Edit the above text to modify the response to help Prod

% Last Modified by GUIDE v2.5 23-Oct-2016 23:23:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Prod_OpeningFcn, ...
                   'gui_OutputFcn',  @Prod_OutputFcn, ...
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


% --- Executes just before Prod is made visible.
function Prod_OpeningFcn(hObject, eventdata, handles, varargin)
global slider3 slider7 TRef TWGS MMeth MEau edit3 edit4;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Prod (see VARARGIN)

% Choose default command line output for Prod
handles.output = hObject;
set(handles.text8,'String',num2str(get(slider3,'Value')));
set(handles.text7,'String',num2str(get(slider7,'Value')));
set(handles.edit3,'String',400);
set(handles.edit4,'String',1500);

TRef=get(slider7,'Value');
TWGS=get(slider3,'Value');
MMeth=400;
MEau=1500;
[tab1 tab2] = Gestion(MMeth, MEau,TRef,TWGS);
format bank
 set(handles.uitable1,'data',tab1);
 set(handles.uitable6,'data',tab2);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Prod wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Prod_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
global TRef TWGS MMeth MEau;
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.text8,'String',num2str(get(hObject,'Value')));
TWGS = get(hObject,'Value');
[tab1 tab2] = Gestion(MMeth, MEau,TRef,TWGS);
 set(handles.uitable1,'data',tab1);
 set(handles.uitable6,'data',tab2);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
global slider3;
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
slider3 = hObject;

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
global TRef TWGS MMeth MEau;
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.text7,'String',num2str(get(hObject,'Value')));
TRef = get(hObject,'Value');
[tab1 tab2] = Gestion(MMeth, MEau,TRef,TWGS);
 set(handles.uitable1,'data',tab1);
 set(handles.uitable6,'data',tab2);


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
global slider7;
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
slider7 = hObject;
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function text7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit3_Callback(hObject, eventdata, handles)
global TRef TWGS MMeth MEau;
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
MMeth = num2str(get(HObject,'String'));
[tab1 tab2] = Gestion(MMeth, MEau,TRef,TWGS);
 set(handles.uitable1,'data',tab1);
 set(handles.uitable6,'data',tab2);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
global edit3;
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit3 = hObject;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
global TRef TWGS MMeth MEau;
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
MEau = num2str(get(HObject,'String'));
[tab1 tab2] = Gestion(MMeth, MEau,TRef,TWGS);
 set(handles.uitable1,'data',tab1);
 set(handles.uitable6,'data',tab2);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
global edit4;
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
edit4 = hObject;
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
