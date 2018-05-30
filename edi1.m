function varargout = edi1(varargin)
% EDI1 MATLAB code for edi1.fig
%      EDI1, by itself, creates a new EDI1 or raises the existing
%      singleton*.
%
%      H = EDI1 returns the handle to a new EDI1 or the handle to
%      the existing singleton*.
%
%      EDI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDI1.M with the given input arguments.
%
%      EDI1('Property','Value',...) creates a new EDI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edi1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edi1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edi1

% Last Modified by GUIDE v2.5 30-May-2018 18:26:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edi1_OpeningFcn, ...
                   'gui_OutputFcn',  @edi1_OutputFcn, ...
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


% --- Executes just before edi1 is made visible.
function edi1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edi1 (see VARARGIN)

% Choose default command line output for edi1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(handles.axes1,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.axes3,'Visible','off');
set(handles.text5,'Visible','off');
set(handles.text6,'Visible','off');
set(handles.pushbutton1,'Visible','off');
set(handles.pushbutton2,'Visible','off');
set(handles.pushbutton3,'Visible','off');
set(handles.popupmenu3,'Visible','off');
set(handles.popupmenu4,'Visible','off');
% UIWAIT makes edi1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edi1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)
% hObject    handle to m_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function file_open_Callback(hObject, eventdata, handles)
% hObject    handle to file_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.text2,'String','Open');
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes3);  
imshow(src_pic);  
title(filename,'color','r'); 

% --------------------------------------------------------------------
function file_save_Callback(hObject, eventdata, handles)
% hObject    handle to file_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uiputfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Save an Image','Undefined.jpg');
fpath=fullfile(pathname,filename);
set(gcf,'CurrentAxes',handles.axes3);           %设置想要保存的axes
final_pic=getimage(gca); 
imwrite(final_pic,fpath);

% --------------------------------------------------------------------
function fea_exc_Callback(hObject, eventdata, handles)
% hObject    handle to fea_exc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.pushbutton3,'Visible','on');
set(handles.text2,'String','feature exchange');
cla;

axes(handles.axes3);
cla;
title('');

[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the source file');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes1);  
imshow(src_pic);  
title(filename,'color','r');

[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the target file');
fpath=[pathname filename];
dst_pic = imread(fpath);  
axes(handles.axes2);  
imshow(dst_pic);  
title(filename,'color','r'); 

while 1
    src_pic=getimage(handles.axes1);
    final_pic=Function_of_feature_exchange(src_pic,dst_pic,handles);
    imshow(final_pic);
    dst_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
end

% --------------------------------------------------------------------
function mon_tra_Callback(hObject, eventdata, handles)
% hObject    handle to mon_tra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.pushbutton3,'Visible','on');
set(handles.text2,'String','monochrome transfer');
cla;
axes(handles.axes3);
cla;
title('');
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the source file');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes1);  
imshow(src_pic);  
title(filename,'color','r');  
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the target file');
fpath=[pathname filename];
dst_pic = imread(fpath);  
axes(handles.axes2);  
imshow(dst_pic);  
title(filename,'color','r'); 

while 1
    src_pic=getimage(handles.axes1);
    final_pic=Function_of_monochrome_transfer(src_pic,dst_pic,handles);
    imshow(final_pic);
    dst_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
end

% --------------------------------------------------------------------
function mix_clo_Callback(hObject, eventdata, handles)
% hObject    handle to mix_clo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.pushbutton3,'Visible','on');
set(handles.text2,'String','mixed cloning');
cla;
axes(handles.axes3);
title('');
cla;
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the source file');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes1);  
imshow(src_pic);  
title(filename,'color','r');  
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the target file');
fpath=[pathname filename];
dst_pic = imread(fpath);  
axes(handles.axes2);  
imshow(dst_pic);  
title(filename,'color','r'); 

while 1
    src_pic=getimage(handles.axes1);
    final_pic=Function_of_mixed_cloning(src_pic,dst_pic,handles);
    imshow(final_pic);
    dst_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
end

% --------------------------------------------------------------------
function tex_fla_Callback(hObject, eventdata, handles)
% hObject    handle to tex_fla (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.text2,'String','texture flattening');
cla;
axes(handles.axes3);
title('');
cla;
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes3);  
imshow(src_pic);  
title(filename,'color','r');  

while 1
    final_pic=Function_of_texture_flattening(src_pic);
    imshow(final_pic);
    src_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
    if handles.axes3.Title.String == 'result'
        break
    end
end

% --------------------------------------------------------------------
function illu_chan_Callback(hObject, eventdata, handles)
% hObject    handle to illu_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.text2,'String','local illumination change');
cla;
axes(handles.axes3);
title('');
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes3);  
imshow(src_pic);  
title(filename,'color','r'); 
% h = imfreehand;
% for a=2.1:0.1:4.0
%     for b = 0.15:0.1:0.45
%         final_pic=Function_of_local_illumination_change(src_pic,a,b, h);
%         fpath=fullfile(pathname,['1.',num2str(a),'_',num2str(b),'.bmp']);
%         imwrite(final_pic,fpath);
%     end
% end

while 1
    final_pic=Function_of_local_illumination_change(src_pic);
    imshow(final_pic);
    title(' ');
    src_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
    if handles.axes3.Title.String == 'result'
        break
    end
end

% --------------------------------------------------------------------
function color_chan_Callback(hObject, eventdata, handles)
% hObject    handle to color_chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'Visible','on');
set(handles.pushbutton2,'Visible','on');
set(handles.text2,'String','local illumination change');
cla;
axes(handles.axes3);
title('');
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes3);  
imshow(src_pic);  
title(filename,'color','r'); 

while 1
    final_pic=Function_of_local_color_change(src_pic);
    imshow(final_pic);
    title(' ');
    src_pic = final_pic;
    k = waitforbuttonpress;
    pause(0.3);
    if handles.axes3.Title.String == 'result'
        break
    end
end

% --------------------------------------------------------------------
function sea_til_Callback(hObject, eventdata, handles)
% hObject    handle to sea_til (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text5,'Visible','on');
set(handles.text6,'Visible','on');
set(handles.pushbutton1,'Visible','on');
set(handles.popupmenu3,'Visible','on');
set(handles.popupmenu4,'Visible','on');
set(handles.text2,'Visible','on');
set(handles.text2,'String','seamless tiling');
cla;
axes(handles.axes3);
title('');
cla;
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick an Image');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes3);  
imshow(src_pic);  
title(filename,'color','r');  

% --------------------------------------------------------------------
function m_exit_Callback(hObject, eventdata, handles)
% hObject    handle to m_exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;   
clear all;
delete(gcf);

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'CurrentAxes',handles.axes3);           %设置想要保存的axes
src_pic=getimage(gca);
rowlist=get(handles.popupmenu3,'String');
rowval=get(handles.popupmenu3,'Value');
row=str2num(rowlist{rowval});
collist=get(handles.popupmenu4,'String');
colval=get(handles.popupmenu4,'Value');
col=str2num(collist{colval});
final_pic=Function_of_seamless_tiling(src_pic,row,col);
set(handles.text5,'Visible','off');
set(handles.text6,'Visible','off');
set(handles.popupmenu3,'Visible','off');
set(handles.popupmenu4,'Visible','off');
set(handles.pushbutton1,'Visible','off');
axes(handles.axes3); 
imshow(final_pic);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(gcf,'CurrentAxes',handles.axes2);           %设置想要保存的axes
set(handles.pushbutton3,'Visible','off');

[final_pic,flag]=getimage(gca);
if flag == 0
    [final_pic,flag] = getimage(handles.axes3);
end

axes(handles.axes2);
title('');
cla;
axes(handles.axes1);
title('');
cla;

axes(handles.axes3); 
imshow(final_pic);
title('result');


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile(...
    {'*.bmp;*.jpg;*.jpeg;*.png','Image Files(*.bmp,*.jpg,*.png,*.jpeg)';...
    '*.*','All Files(*.*)'},...
    'Pick the source file');
fpath=[pathname filename];
src_pic = imread(fpath);  
axes(handles.axes1);  
imshow(src_pic);
title(filename,'color','r');
