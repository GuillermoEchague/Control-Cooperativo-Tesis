function varargout = SCARA(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SCARA_OpeningFcn, ...
                   'gui_OutputFcn',  @SCARA_OutputFcn, ...
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


% --- Executes just before SCARA is made visible.
function SCARA_OpeningFcn(hObject, eventdata, handles, varargin)

% global MundoVirtual angBodyY  angForearmZ angUpperarmZ angWristZ angMunecaX portrvm1;
% global angBodyY_temp angUpperarmZ_temp angForearmZ_temp angWristZ_temp angMunecaX_temp;
global puertos puerto %MundoVirtual
global Servo_1 Servo_2 Servo_3 Servo_4 Servo_5 Servo_6 

%   MundoVirtual = vrworld('brazo.WRL');   % Definir Entorno Virtual
%   open(MundoVirtual);                    % Abrir Entorno Virtual
%   view(MundoVirtual);                    % Arrancar MundoVirtual

warning off; %#ok<WNOFF>
serialinfo = instrhwinfo('serial');
puertos = serialinfo.AvailableSerialPorts;
[f, v] = size(puertos);

% Asignación inicial de puerto a RVM1
set(handles.serialList_SCARA,'String', puertos);
if f > 1
    set(handles.serialList_SCARA,'Value', f-1);
    puerto = puertos{f-1,1};
else
    set(handles.serialList_SCARA,'Value', f);
    puerto = puertos{f,1};
end

Servo_1 = 3;
Servo_2 = 5;
Servo_3 = 6;
Servo_4 = 9;
Servo_5 = 10;
Servo_6 = 11;

axes(handles.escudo);
imshow('UdeSantiago.jpg')

handles.output = hObject;
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = SCARA_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;

function Led_Conexion_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function Led_Conexion_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Conectar_SCARA.
function Conectar_SCARA_Callback(hObject, eventdata, handles)
global SCARA puerto;

 SCARA = arduino(puerto);

set(handles.Led_Conexion,'BackGroundColor', [1,0,0]);
Bip(1);


% --- Executes on button press in Desconectar_SCARA.
function Desconectar_SCARA_Callback(hObject, eventdata, handles)
global SCARA;
delete(SCARA);
Bip(2);
set(handles.Led_Conexion, 'BackgroundColor', [0.941 0.941 0.941]);


% --- Executes on slider movement.
function Theta1_Callback(hObject, eventdata, handles)
global x y z phi roll SCARA Servo_1 myworlds th01;
servoAttach(SCARA,Servo_1);
th01 = round(get(handles.Theta1,'Value'));
set(handles.edit_th1, 'String',num2str(th01));
servoWrite(SCARA,Servo_1,th01+90);
myworlds.base_2_2.rotation = [0 1 0 th01*(pi/180)];
pause(0.3);
if th01 >= 90
servoDetach(SCARA,Servo_1);
end
if th01 <= -90
    servoDetach(SCARA,Servo_1);
end
[ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);
actualiza_valores(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function Theta1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta2_Callback(hObject, eventdata, handles)
global SCARA Servo_2 MundoVirtual ;

th2 = round(get(handles.Theta2,'Value'));
set(handles.edit_th2,'String', num2str(th2));
servoAttach(SCARA,Servo_2);
servoWrite(SCARA,Servo_2,th2+90);
% MundoVirtual.base_2_7.rotation = [0 1 0 th2*(pi/180)];
pause(0.3);
if th2 >= 90
servoDetach(SCARA,Servo_2);
end
if th2 <= -90
    servoDetach(SCARA,Servo_2);
end
% [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);

% --- Executes during object creation, after setting all properties.
function Theta2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta3_Callback(hObject, eventdata, handles)
global SCARA Servo_3 MundoVirtual;
servoAttach(SCARA,Servo_3);
th3 = round(get(handles.Theta3,'Value'));
set(handles.edit_th3,'String', num2str(th3));
servoWrite(SCARA,Servo_3,th3+90);
% MundoVirtual.base_3_5.rotation = [0 1 0 th3*(pi/180)];
pause(0.3);
if th3 >= 90
servoDetach(SCARA,Servo_3);
end
if th3 <= -90
    servoDetach(SCARA,Servo_3);
end
% [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);

% --- Executes during object creation, after setting all properties.
function Theta3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Theta4_Callback(hObject, eventdata, handles)
global SCARA Servo_4 MundoVirtual th4;
servoAttach(SCARA,Servo_4);
th4 = round(get(handles.Theta4,'Value'));
set(handles.edit_th4,'String', num2str(th4));
servoWrite(SCARA,Servo_4,th4);
% MundoVirtual.cremallera.translation = [0 -th4*(pi/180)*10 0 ];
pause(0.5);
if th4 == 180
servoDetach(SCARA,Servo_4);
end
if th4 == 0
    servoDetach(SCARA,Servo_4);
end
% [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);

% --- Executes during object creation, after setting all properties.
function Theta4_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Theta5_Callback(hObject, eventdata, handles)
global SCARA Servo_5 MundoVirtual th5;
servoAttach(SCARA,Servo_5);
th5 = round(get(handles.Theta5,'Value'));
set(handles.edit_th5,'String', num2str(th5));
servoWrite(SCARA,Servo_5,th5+90);
% MundoVirtual.mano_1.rotation = [0 1 0 th5*(pi/180)];
pause(0.3);
if th5 >= 90
servoDetach(SCARA,Servo_5);
end
if th5 <= -90
    servoDetach(SCARA,Servo_5);
end
% [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);

% --- Executes during object creation, after setting all properties.
function Theta5_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta6_Callback(hObject, eventdata, handles)
global SCARA Servo_6 MundoVirtual;
servoAttach(SCARA,Servo_6);
th6 = round(get(handles.Theta6,'Value'));
set(handles.edit_th6,'String', num2str(th6));
servoWrite(SCARA,Servo_6,th6);
% MundoVirtual.dedo_1.translation = [-th6*(pi/180)*5 0 0 ];
% MundoVirtual.dedo_2.translation = [th6*(pi/180)*5 0 0 ];
pause(0.3);
if th6 >= 180
servoDetach(SCARA,Servo_6);
end
if th6 <= 0
    servoDetach(SCARA,Servo_6);
end
% [ x, y, z, phi, roll] = cine_dir_scara( th1,th2,th3,th4,th5,th6);

% --- Executes during object creation, after setting all properties.
function Theta6_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on selection change in serialList_SCARA.
function serialList_SCARA_Callback(hObject, eventdata, handles)
global SCARA puertos;
seleccion = get(handles.serialList_SCARA,'Value');
SCARA.setCOM(puertos{seleccion,1});
assignin('base','com_SCARA', SCARA.PortName);
function serialList_SCARA_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Salir.
function Salir_Callback(hObject, eventdata, handles)
global SCARA MundoVirtual;
delete(SCARA);
% close(MundoVirtual);
% delete(MundoVirtual);

Bip(2);
close();

function Bip(n)
for i = 1:n
    cf = 2000;                  % carrier frequency (Hz)
    sf = 22050;                 % sample frequency (Hz)
    d = 0.1;                    % duration (s)
    n = sf * d;                 % number of samples
    s = (1:n) / sf;             % sound data preparation
    s = sin(2 * pi * cf * s);   % sinusoidal modulation
    sound(s, sf);               % sound presentation
    pause(d);                   % waiting for sound end
end


function edit_th1_Callback(hObject, eventdata, handles)
global SCARA Servo_1  MundoVirtual th1;

th1 = str2double( get(handles.edit_th1, 'String'));
set(handles.Theta1, 'Value', th1);
servoWrite(SCARA,Servo_1,th1);
% MundoVirtual.base_2_2.rotation = [0 1 0 th1*(pi/180)];


% --- Executes during object creation, after setting all properties.
function edit_th1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_th2_Callback(hObject, eventdata, handles)
global SCARA Servo_2  MundoVirtual;

th2 = str2double( get(handles.edit_th2, 'String'));
set(handles.Theta2, 'Value', th2);
servoWrite(SCARA,Servo_2,th2);
% MundoVirtual.base_2_7.rotation = [0 1 0 th2*(pi/180)];



% --- Executes during object creation, after setting all properties.
function edit_th2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_th3_Callback(hObject, eventdata, handles)
global SCARA Servo_3 MundoVirtual;

th3 = str2double( get(handles.edit_th3, 'String'));
set(handles.Theta3, 'Value', th3);
servoWrite(SCARA,Servo_3,th3);
% MundoVirtual.base_3_5.rotation = [0 1 0 th3*(pi/180)];

% --- Executes during object creation, after setting all properties.
function edit_th3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_th4_Callback(hObject, eventdata, handles)
global SCARA Servo_4 MundoVirtual th4;

th4 = str2double( get(handles.edit_th4, 'String'));
set(handles.Theta4, 'Value', th4);
servoWrite(SCARA,Servo_4,th4);
% MundoVirtual.cremallera.translation = [0 -th4*(pi/180)*8 0 ];


% --- Executes during object creation, after setting all properties.
function edit_th4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_th5_Callback(hObject, eventdata, handles)
global SCARA Servo_5 MundoVirtual;

th5 = str2double( get(handles.edit_th5, 'String'));
set(handles.Theta5, 'Value', th5);
servoWrite(SCARA,Servo_5,th5);
% MundoVirtual.mano_1.rotation = [0 1 0 th5*(pi/180)];


% --- Executes during object creation, after setting all properties.
function edit_th5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_th6_Callback(~, eventdata, handles)
global SCARA Servo_6 MundoVirtual;

th6 = str2double( get(handles.edit_th6, 'String'));
set(handles.Theta6, 'Value', th6);
servoWrite(SCARA,Servo_6,th6);
% MundoVirtual.dedo_1.translation = [-th6*(pi/180)*10 0 0 ];
% MundoVirtual.dedo_2.translation = [th6*(pi/180)*10 0 0 ];


% --- Executes during object creation, after setting all properties.
function edit_th6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset_SCARA.
function Reset_SCARA_Callback(hObject, eventdata, handles)
global SCARA Servo_1  Servo_2 Servo_3;
global  Servo_4 Servo_5 Servo_6 MundoVirtual; 

servoAttach(SCARA,Servo_1);
servoAttach(SCARA,Servo_2);
servoAttach(SCARA,Servo_3);
servoAttach(SCARA,Servo_4);
servoAttach(SCARA,Servo_5);
servoAttach(SCARA,Servo_6);

th1 = 0;
th2 = 0;
th3 = 0;
th4 = 0;
th5 = 0;
th6 = 0;

set(handles.Theta1, 'Value', th1);
set(handles.Theta2, 'Value', th1);
set(handles.Theta3, 'Value', th3);
set(handles.Theta4, 'Value', th4);
set(handles.Theta5, 'Value', th5);
set(handles.Theta6, 'Value', th6);

set(handles.edit_th1, 'String',num2str(th1));
servoWrite(SCARA,Servo_1,90);
set(handles.edit_th2,'String', num2str(th2));
servoWrite(SCARA,Servo_2,90);
set(handles.edit_th3,'String', num2str(th3));
servoWrite(SCARA,Servo_3,90);
set(handles.edit_th4,'String', num2str(th4));
servoWrite(SCARA,Servo_4,0);
set(handles.edit_th5,'String', num2str(th5));
servoWrite(SCARA,Servo_5,0);
set(handles.edit_th6,'String', num2str(th6));
servoWrite(SCARA,Servo_6,0);

% MundoVirtual.base_2_2.rotation = [0 1 0 th1*(pi/180)];
% MundoVirtual.base_2_7.rotation = [0 1 0 th2*(pi/180)];
% MundoVirtual.base_3_5.rotation = [0 1 0 th3*(pi/180)];
% MundoVirtual.cremallera.translation = [0 th4*(pi/180)*30 0 ];
% MundoVirtual.mano_1.rotation = [0 1 0 th5*(pi/180)];
% MundoVirtual.dedo_1.translation = [th6*(pi/180)*5 0 0 ];
% MundoVirtual.dedo_2.translation = [th6*(pi/180)*5 0 0 ];
pause(0.3);

if th1 == 90
servoDetach(SCARA,Servo_1);
end
if th2 == 90
servoDetach(SCARA,Servo_2);
end
if th3 == 90
servoDetach(SCARA,Servo_3);
end
if th4 == 0
servoDetach(SCARA,Servo_4);
end
if th5 == 0
servoDetach(SCARA,Servo_5);
end
if th6 == 0
servoDetach(SCARA,Servo_6);
end

% set(handles.valor_y,'String',y);
% set(handles.valor_z,'String',z);
% set(handles.valor_phi,'String',phi);

function valor_y_Callback(hObject, eventdata, handles)
global th1 th2 th3 th4 th5 th6 th7 th8 x y z phi roll a3 a5
th1 = str2double( get(handles.edit_th1, 'String'));
th2 = str2double( get(handles.edit_th2, 'String'));
th3 = str2double( get(handles.edit_th3, 'String'));
th4 = str2double( get(handles.edit_th4, 'String'));
th5 = str2double( get(handles.edit_th5, 'String'));
th6 = str2double( get(handles.edit_th6, 'String'));
[x,y,z,phi,roll,a3,a5]=cine_dir_scara( th1,th2,th3,th4,th5,th6,th7,th8);
 set(handles.valor_y,'String',y);

function valor_x_Callback(hObject, eventdata, handles)
global x y z phi roll a3 th1 th2 th3 th4 th5 th6 
th1 = round(get(handles.Theta1,'Value'));
th2 = round(get(handles.Theta2,'Value'));
th3 = round(get(handles.Theta3,'Value'));
th4 = round(get(handles.Theta4,'Value'));
th5 = round(get(handles.Theta5,'Value'));
th6 = round(get(handles.Theta6,'Value'));
[x,y,z,phi,roll,a3,a5]=cine_dir_scara( th1,th2,th3,th4,th5,th6);
 set(handles.valor_x,'String',x);

% --- Executes on selection change in cuadro_trayectoria.
function cuadro_trayectoria_Callback(hObject, eventdata, handles)

str = get(hObject, 'String'); 
val = get(hObject,'Value');
switch str{val};
case 'CUADRADO'
  th1 = 45;
  th2 = -30;
  th3 = 90;
  
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
pause (1);
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);
pause (1);
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);
pause (1);
case 'RECTANGULO'
case 'COOPERACION_1'
case 'COOPERACION_2'
case 'COOPERACION_3'  
    
end

% --- Executes during object creation, after setting all properties.
function cuadro_trayectoria_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cuadro_trayectoria (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in programa.
function programa_Callback(hObject, eventdata, handles)
% hObject    handle to programa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function actualiza_valores(hObject, eventdata, handles)
global x y z phi roll;
handles.valor_x('String', x);
handles.valor_y('String', y);
handles.valor_z('String', z);
handles.valor_phi('String', phi);
handles.valor_Roll('String', roll);


% --- Executes during object creation, after setting all properties.
function valor_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function valor_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_z_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function valor_z_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function valor_phi_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function valor_phi_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function valor_Roll_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function valor_Roll_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
