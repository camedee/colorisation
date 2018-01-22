function varargout = afficher_carte(varargin)
% AFFICHER_CARTE MATLAB code for afficher_carte.fig
%      AFFICHER_CARTE, by itself, creates a new AFFICHER_CARTE or raises the existing
%      singleton*.
%
%      H = AFFICHER_CARTE returns the handle to a new AFFICHER_CARTE or the handle to
%      the existing singleton*.
%
%      AFFICHER_CARTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AFFICHER_CARTE.M with the given input arguments.
%
%      AFFICHER_CARTE('Property','Value',...) creates a new AFFICHER_CARTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before afficher_carte_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to afficher_carte_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help afficher_carte

% Last Modified by GUIDE v2.5 18-Jan-2016 15:43:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @afficher_carte_OpeningFcn, ...
    'gui_OutputFcn',  @afficher_carte_OutputFcn, ...
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


function ButtonDown(hObject, eventData)
global     main_hand2 UG UD map radius step


%set(c.text4, 'String', 'Please, select color.');
%drawnow

coordinates = get(main_hand2,'currentpoint');
coordinates = floor(coordinates(1,1:2));
y = coordinates(1) ; x = coordinates(2) ;
hIm= imagesc(uint8(image_totale(UG,UD)));
set(hIm,'ButtonDownFcn',@ButtonDown)



hold on
if y <= size(UG,2)
    if x <= size(UG,1)
        %disp gauche_haut
        
        
        %radius =2;
        
        for x_bis = -radius:step:radius
            for y_bis = -radius:step:radius
                
                I = find(map== ((x+x_bis)+size(UG,1)*(y+y_bis-1)));
                %map(X+size(map,1)*(Y-size(map,2)-1))
                if numel(I) > 0
                    [xg, yg] = ind2sub([size(UD,1), size(UD,2)], I);
                    
                    %(yg(1) - y+ size(UG,2)), (xg(1) - x+ size(UG,1))
                    quiver( (y+y_bis),(x+x_bis), (yg(1) - (y+y_bis)+ size(UG,2)), (xg(1) - (x+x_bis)),0,'b');
                end
                %plot(gca(), y, x, 'g.')
                
            end
        end
        
    else
        %disp gauche_bas
        
        %plot(gca(), y, x, 'r.')
        %disp gauche_bas
        
    end
else
    if x <= size(UD,1)
        %plot(gca(), y, x, 'y.')
        %disp droit_haut
        
        %radius =2;
        
        
        X= max(1,min(size(UD,1),x + [-radius:step:radius]));
        Y= max(size(UG,2)+1,min(size(UD,2)+size(UG,2),y + [-radius:step:radius]));
        [X,Y] = meshgrid(X,Y);
        
        %[xg, yg] = ind2sub([size(UG,1), size(UG,2)], map(x,y-size(UG,2)));
        % map(X+size(UG,1)*(Y-size(UG,2))+1)
        [xg, yg] = ind2sub([size(UG,1), size(UG,2)], map(X+size(map,1)*(Y-size(map,2)-1)));
        
        %quiver( y,x, (yg - y), (xg - x));
        quiver( Y, X, (yg - Y), (xg - X), 0, 'b');
    else
        %plot(gca(), y, x, 'b.')
        %disp droit_bas
        
    end
end








function A= image_totale(IG, ID)
hauteur_finale = max(size(IG,1), size(ID,1));
A= zeros(hauteur_finale, size(IG,2)+size(ID,2),3);
A(1:size(IG,1), 1:size(IG,2),:) = IG;
A(1:size(ID,1), size(IG,2)+1:size(IG,2)+size(ID,2),:) = ID;



% --- Executes just before afficher_carte is made visible.
function afficher_carte_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to afficher_carte (see VARARGIN)

% Choose default command line output for afficher_carte
handles.output = hObject;

global     main_hand2 UG UD map radius step

        
UG = varargin{1};
UD = varargin{2};
map = varargin{3};

if ndims(UG) == 2
    UG = repmat(UG,1,1,3);
end

if ndims(UD) == 2
    UD = repmat(UD,1,1,3);
end

H=max(size(UG,1), size(UG,1));

step = floor(H/150);
radius =floor(H/250);

axes(handles.axes1);
hIm= imagesc(uint8(image_totale(UG,UD)));

set(hIm,'ButtonDownFcn',@ButtonDown)


main_hand2 = handles.axes1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes afficher_carte wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = afficher_carte_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global radius UG step
radius =floor(size(UG,1)/250*get(hObject,'Value'));
step =floor(size(UG,1)/1000*get(hObject,'Value'));


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
