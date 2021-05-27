function varargout = Control_RVM1_a(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Control_RVM1_a_OpeningFcn, ...
                   'gui_OutputFcn',  @Control_RVM1_a_OutputFcn, ...
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


% --- Executes just before Control_RVM1_a is made visible.
function Control_RVM1_a_OpeningFcn(hObject, eventdata, handles, varargin)
global MundoVirtual angBodyY  angForearmZ angUpperarmZ angWristZ angMunecaX portrvm1;
global angBodyY_temp angUpperarmZ_temp angForearmZ_temp angWristZ_temp angMunecaX_temp;
global RVM1 puertos 

%MundoVirtual = vrworld('r.WRL');   % Definir Entorno Virtual
MundoVirtual = vrworld('rvm1.WRL');   % Definir Entorno Virtual
open(MundoVirtual);                % Abrir Entorno Virtual
view(MundoVirtual);                % Arrancar MundoVirtual

warning off; %#ok<WNOFF>
serialinfo = instrhwinfo('serial');
puertos = serialinfo.AvailableSerialPorts;
[f, v] = size(puertos);

RVM1 = class_RVM1;

% Asignación inicial de puerto a RVM1
set(handles.serialList_RVM1,'String', puertos);
if f > 1
    set(handles.serialList_RVM1,'Value', f-1);
    RVM1.setCOM(puertos{f-1,1})
else
    set(handles.serialList_RVM1,'Value', f);
    RVM1.setCOM(puertos{f,1})
end
% ------------------------------------

% Parametros de inicio realidad virtual
MundoVirtual.Body.rotation      = [0 1 0 0];
MundoVirtual.Upperarm.rotation  = [0 0 1 0];
MundoVirtual.Forearm.rotation   = [0 0 1 0];
MundoVirtual.Wrist.rotation     = [0 0 1 0];
MundoVirtual.Muneca.rotation    = [1 0 0 0];
% ------------------------------------


axes(handles.escudo);
imshow('UdeSantiago.jpg')

handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Control_RVM1_a_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on selection change in serialList_RVM1.
function serialList_RVM1_Callback(hObject, eventdata, handles)
global RVM1 puertos;
seleccion = get(handles.serialList_RVM1,'Value');
RVM1.setCOM(puertos{seleccion,1});
assignin('base','com_RVM1', RVM1.PortName);
function serialList_RVM1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Conectar_RVM1.
function Conectar_RVM1_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Connect();
set(handles.Led_Conexion,'BackGroundColor', [1,0,0]);
updateCinematicaDirecta(handles);


% --- Executes on button press in Desconectar_RVM1.
function Desconectar_RVM1_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Disconnect();
set(handles.Led_Conexion, 'BackgroundColor', [0.941 0.941 0.941]);


function Led_Conexion_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Led_Conexion_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Reset_RVM1.
function Reset_RVM1_Callback(hObject, eventdata, handles)
global  angBodyY  angBodyY_temp MundoVirtual;
global angUpperarmZ_temp angUpperarmZ;
global angForearmZ angForearmZ_temp;
global angWristZ angWristZ_temp;
global angMunecaX angMunecaX_temp;
global RVM1 ;
RVM1.RS();
RVM1.OG();

angBodyY = 0; 
set(handles.Theta1,'Value',0);
angBodyY_temp = 0;
MundoVirtual.Body.rotation = [0 1 0 0];

angUpperarmZ = 0; 
set(handles.Theta2,'Value',0);
angUpperarmZ_temp = 0;
MundoVirtual.Upperarm.rotation = [0 0 1 0];

angForearmZ = 0; 
set(handles.Theta3,'Value',0);
angForearmZ_temp = 0;
MundoVirtual.Forearm.rotation = [0 0 1 0];

angWristZ = 0; 
set(handles.Theta4,'Value',0);
angWristZ_temp = 0;
MundoVirtual.Wrist.rotation = [0 0 1 0];

angMunecaX = 0; 
set(handles.Theta5,'Value',0);
angMunecaX_temp = 0;
MundoVirtual.Muneca.rotation = [1 0 0 0];

set(handles.th1,'String',angBodyY);
set(handles.th2,'String',angUpperarmZ);
set(handles.th3,'String',angForearmZ);
set(handles.th4,'String',angWristZ);
set(handles.th5,'String',angMunecaX);
updateCinematicaDirecta(handles);

function  updateCinematicaDirecta(handles)
global RVM1 
[x, y, z, p, r] = RVM1.xyzpr();
set(handles.valor_x,'String',x)
set(handles.valor_y,'String',y);
set(handles.valor_z,'String',z);
set(handles.valor_pitch,'String',p);
set(handles.valor_roll,'String',r);


% --- Executes on slider movement.
function Theta1_Callback(hObject, eventdata, handles)
global RVM1 MundoVirtual;
th1 = RVM1.ReadRVM1('th1');
angBodyY = get(handles.Theta1,'Value');
if angBodyY < -150; angBodyY = -150; end
if angBodyY > 150; angBodyY = 150; end
angBodyY_Inc = round(angBodyY - th1);
RVM1.AngleTh1(angBodyY_Inc);
MundoVirtual.Body.rotation = [0 -1 0 angBodyY*(pi/180)];
set(handles.th1,'String',angBodyY);
updateCinematicaDirecta(handles);

function Theta1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta2_Callback(hObject, eventdata, handles)
global RVM1 MundoVirtual ;
th2 = RVM1.ReadRVM1('th2');
angUpperarmZ = get(handles.Theta2,'Value');
if angUpperarmZ > 100; angUpperarmZ = 100; end
if angUpperarmZ < -30; angUpperarmZ = -30; end
angUpperarmZ_Inc = round(angUpperarmZ - th2);
RVM1.AngleTh2(angUpperarmZ_Inc);
MundoVirtual.Upperarm.rotation = [0 0 1 angUpperarmZ*(pi/180)];
 set(handles.th2,'String',angUpperarmZ)
updateCinematicaDirecta(handles);

function Theta2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta3_Callback(hObject, eventdata, handles)
global RVM1 MundoVirtual ;
th3 = RVM1.ReadRVM1('th3');
angForearmZ =  get(handles.Theta3,'Value');
if angForearmZ > 0;    angForearmZ = 0;    end
if angForearmZ < -100; angForearmZ = -100; end
angForearmZ_Inc = round(angForearmZ - th3);
RVM1.AngleTh3(angForearmZ_Inc);
MundoVirtual.Forearm.rotation = [0 0 1 angForearmZ*(pi/180)];

set(handles.th3,'String',angForearmZ);
updateCinematicaDirecta(handles);

function Theta3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta4_Callback(hObject, eventdata, handles)
global RVM1 MundoVirtual;
th4 = RVM1.ReadRVM1('th4');
angWristZ = get(handles.Theta4,'Value');
if angWristZ > 90;  angWristZ =  90; end
if angWristZ < -90; angWristZ = -90; end
angWristZ_Inc = round(angWristZ - th4);
RVM1.AngleTh4(angWristZ_Inc);
MundoVirtual.Wrist.rotation = [0 0 1 angWristZ*(pi/180)];
set(handles.th4,'String',angWristZ);
updateCinematicaDirecta(handles);

function Theta4_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function Theta5_Callback(hObject, eventdata, handles)
global RVM1 MundoVirtual;
th5 = RVM1.ReadRVM1('th5');
angMunecaX =  get(handles.Theta5,'Value');
if angMunecaX > 180;  angMunecaX = 180; end
if angMunecaX < -180; angMunecaX = -180; end
angMunecaX_Inc = round(angMunecaX-th5);
RVM1.AngleTh5(angMunecaX_Inc);
MundoVirtual.Muneca.rotation = [1 0 0 angMunecaX*(pi/180)];
 set(handles.th5,'String',angMunecaX);
updateCinematicaDirecta(handles);

function Theta5_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in Origen_Mecanico.
function Origen_Mecanico_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.NT();


% --- Executes on button press in Origen_XYZ.
function Origen_XYZ_Callback(hObject, eventdata, handles)
Reset_RVM1_Callback(hObject, eventdata, handles);
pause(1);
updateCinematicaDirecta(handles);

%set(handles.Theta1,'Value',0);


% --- Executes on button press in Abrir_Mano.
function Abrir_Mano_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.GO();
pause(1);

% --- Executes on button press in Cerrar_Mano.
function Cerrar_Mano_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.GC();
pause(1);


% --- Executes on button press in tool.
function tool_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.TOOL();
TOOL = get(handles.editTool, 'String');
pause(1);
RVM1.Bip(1);

% --- Executes on button press in Lee_Posiciones.
function Lee_Posiciones_Callback(hObject, eventdata, handles)
global portrvm1;
Posiciones = cell(629,1);
bip(2);

for i=1:629
    fprintf(portrvm1, ['PR ' num2str(i)]);
    pause(0.04);
    [tline,count,msg] = fgetl(portrvm1);
    Posiciones(i,1) = {tline};
    disp(['Posicion ' num2str(i) ' de 629 leida']);
end
assignin('base','Posicion',Posiciones);
bip(1);



% --- Executes on button press in Leer_Coordenadas.
function Leer_Coordenadas_Callback(hObject, eventdata, handles)
global portrvm1 x y z p r th1 th2 th3 th4 th5;
pause(0.5);
fprintf(portrvm1, 'WH');
pause(0.04);
[tline,count,msg] = fgetl(portrvm1);
assignin('base','Coordenadas',tline);
[x, y, z, p, r] = strread(tline, '%f %f %f %f %f', 'delimiter', ',');
[th1, th2, th3, th4, th5] = cine_inv5(x,y,z,p,r);

pause(0.04);



% --- Executes on button press in Leer_Linea_Prog.
function Leer_Linea_Prog_Callback(hObject, eventdata, handles)
global portrvm1;
LinProgram = cell(2048,1);
bip(2);

for i=1:2048
    fprintf(portrvm1, ['LR ' num2str(i)]);
    pause(0.04);
    [tline,count,msg] = fgetl(portrvm1);
    LinProgram(i,1) = {tline};
    disp(['Posicion ' num2str(i) ' de 2048 leida']);
end
assignin('base','Posicion',LinProgram);
bip(1);


% --- Executes on button press in Salir.
function Salir_Callback(hObject, eventdata, handles)
global RVM1 rvm1 MundoVirtual ;
RVM1.Disconnect();
pause(1);
delete(rvm1);
close(MundoVirtual);
delete(MundoVirtual);
pause(1);
close();



function Th1_Callback(hObject, eventdata, handles)
global MundoVirtual angMunecaX portrvm1 angMunecaX_temp;
global x y z p r th1;
Leer_Coordenadas_Callback()
th1;
pause(0.04);


function Th1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Th2_Callback(hObject, eventdata, handles)



function Th2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Th3_Callback(hObject, eventdata, handles)


function Th3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Th4_Callback(hObject, eventdata, handles)




function Th4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Th5_Callback(hObject, eventdata, handles)

function Th5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function X_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function X_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Y_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function Y_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Z_Callback(hObject, eventdata, handles)

function Z_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Pitch_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Pitch_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Roll_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function Roll_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function editTool_Callback(hObject, eventdata, handles)
function editTool_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in programas.
function programas_Callback(hObject, eventdata, handles)
global RVM1 

str = get(hObject, 'String');
val = get(hObject,'Value');
switch str{val};

    case 'CUADRADO'
RVM1.OG();   
RVM1.waitPortFree();
th_1 = 90;
th_2 = 78.7;
th_3 = -87;
th_4 = -41.7;
th_5 = 0;

RVM1.AngleTh12345(th_1,th_2,th_3,th_4,th_5);
RVM1.waitPortFree();
th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1=90;
th_2 = 53.5;
th_3 = -45.9;
th_4 = -57.6;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();
th_1 = 102.5;
th_2 = 49.8;
th_3 = -38.6;
th_4 = -61.2;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1 = 105.9;
th_2 = 75.5;
th_3 = -82.7;
th_4 = -42.8;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

RVM1.waitPortFree();

th_1 = 90;
th_2 = 78.7;
th_3 = -87;
th_4 = -41.7;
th_5=0;

th1 = RVM1.ReadRVM1('th1');
if th1 < -150; th1 = -150; end
if th1 > 150; th1 = 150; end
th1_Inc = round(th_1 - th1);

th2 = RVM1.ReadRVM1('th2');
if th2 > 100; th2 = 100; end
if th2 < -30; th2 = -30; end
th2_Inc = round(th_2 - th2);

th3 = RVM1.ReadRVM1('th3');
if th3 > 0;    th3 = 0;    end
if th3 < -100; th3 = -100; end
th3_Inc = round(th_3 - th3);

th4 = RVM1.ReadRVM1('th4');
if th4 > 90;  th4 =  90; end
if th4 < -90; th4 = -90; end
th4_Inc = round(th_4 - th4);

th5 = RVM1.ReadRVM1('th5');
if th5 > 180;  th5 = 180; end
if th5 < -180; th5 = -180; end
th5_Inc = round(th_5-th5);

RVM1.AngleTh12345(th1_Inc,th2_Inc,th3_Inc,th4_Inc,th5_Inc);

    case 'HEXAGONO'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;
RVM1.AngleTh12345(th1,th2,th3,th4,th5);

%{
RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);   
  
%}

    case 'ROMBO'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles); 


    case 'COOPERACION_1'
        
th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);   
end


% --- Executes during object creation, after setting all properties.
function programas_CreateFcn(hObject, eventdata, handles)
% hObject    handle to programas (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rvm1Slow.
function rvm1Slow_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Slow();

% --- Executes on button press in rvm1Fast.
function rvm1Fast_Callback(hObject, eventdata, handles)
global RVM1;
RVM1.Fast();


function valor_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Test_Programa.
function Test_Programa_Callback(hObject, eventdata, handles)
global RVM1 

th1 = 45;
th2 = 45;
th3 = -30;
th4 = 25;
th5 = 180;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta2, 'Value',th2);
Theta2_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta3, 'Value',th3);
Theta3_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

RVM1.waitPortFree();
set(handles.Theta5, 'Value',th5);
Theta5_Callback(hObject, eventdata, handles);

th1 = 0;
th4 = -45;

RVM1.waitPortFree();
set(handles.Theta1, 'Value',th1);
Theta1_Callback(hObject, eventdata, handles);
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 45;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);

th4 = 0;
RVM1.waitPortFree();
set(handles.Theta4, 'Value',th4);
Theta4_Callback(hObject, eventdata, handles);
