--------------------------------------------------------------------------------------
--Simple math calculator
--by Ewerton Souto, 2017

--------------------------------------------------------------------------------------
-------------------------------------------
--Variaveis
-------------------------------------------
--Nossa String inicializada
local displayStr = "0";

--limite de digitos a serem mostrados na tela
local maxDigits = 19;

--Tipo do ultimo botão apertado. 
--Aceita "none", "equal", "num" ou "math"
local lastInput = "none"; 


-------------------------------------------
--flags
-------------------------------------------
--pode iniciar a captura do novo numero
--quando é digitado ou pressionado?
local startNewNumber = true;

--O ultimo botão pressionado foi "-"?
local negPressedLast = false;

--O decimal foi pressionado?
local decimalPressed = false;


-------------------------------------------
--require da classe calculator controller
------------------------------------------
local cc = require "calcController";

-------------------------------------------
--utilidades da função
-------------------------------------------
local function cleanLeftZeros(str)
	--remove qualquer '0's no lado esquerdo da sting
	--quando o comptrimento da string for tão grande quanto 1
	--também deixa o 0 se o numero está entre -1 e 1 (como "0.1 ou 0.2")
	
	--checa se é numero negativo?
	local isNegative = false;
	if string.sub(str, 1, 1) == "-" then
		--se é negativo
		isNegative = true;
		--temporariamente remove o '-' da string
		str = string.sub(str,2);
	end
	
	--torna a string temporarily em um number
	str = tonumber(str);
	--se é menor que 0, diciona o "0" à esquerda
	--por que quero o formato "0.4", not ".4"
	if str and str<0 then
		str = "0"..tostring(str);
	end
	
	-- se issi foi negativo, restaura o sinal '-'
	if isNegative then str = "-" .. str; end
	
	return str;
end

local function clear()
	cc.reset();
	decimalPressed = false;
	displayStr = "0";
	lastInput = "none"
	startNewNumber = true;
end

-------------------------------------------
--O display da calculador
-------------------------------------------
--requer a classe externa 'calcScreen' que foi criada
local calcScreen = require "calcScreen";

--cria uma nova instancia da classe calcScreen
local calcScr = calcScreen.new();

--Posiciona a tela da calculadora
calcScr.anchorX = 0;
calcScr.anchorY = 0;

-------------------------------------------
--mANIPULAR BOTÕES
-------------------------------------------
local function invertNegBtnTapped(event)
--manipula os eventos +/- 
	local num = tonumber(displayStr);
	--se o numero não é nil e é menor que zero
	if num and num<0 then
		--remove o "-" (primeiro char da string)
		displayStr = string.sub(displayStr,2);
	--se o numero não é nil e é maior que 0
	elseif num and num>0 then
		--adiciona "-"
		displayStr = "-"..displayStr;
	end
	--mostra o numero modificado na tela
	if num then calcScr.setTxt(displayStr); end
	return true;
end

local function mathBtnTapped(event)
--manipula botões matemáticos ("/","*","+,"-" etc)
	local targetID = event.target.id;
	
	if targetID == "-" and startNewNumber then
		negPressedLast = true;
	else
		negPressedLast = false;
	end
	
	
	--se não é a primeira vez que mostra na linha '='
	--com o botão pressionado, não altera op2
	--Examplo: O usuario entra "3+5 = = =" resultado é 18
	if lastInput ~= "equal" then
		cc.setOp2(tonumber(displayStr));
	end
	
	if targetID ~= "=" and lastInput=="equal" then
		--trata o ulyimo resultado conforme o numero digitado pelo usuario
		cc.setOp1(tonumber(displayStr));
		cc.setOp2(0);
	else  
		cc.performOperation();
	end
	
	
	displayStr = cc.getOp1();
	
    if targetID == "=" then
    	lastInput = "equal"
    else
    	lastInput = "math"
    end
    
    --seta os dados digitados na função matematica (X, /, -, +) como o ultimo operador
    cc.setOperator(targetID);
    
    --checa por erros encontrados no calculator controller
    --como dividir por zero, por exemplo
    if cc.foundError then displayStr = "ERROR"; end
    
    --quando clicar no botão clear
    if targetID =="Clear" then
		clear();
	end
	
    --mostra operand1 na tela
    calcScr.setTxt(displayStr);
	return true
end

local function numBtnTapped(event)
--manipula botoes numericos ('0'-'9')
	local targetID = event.target.id;
	print("You pressed "..targetID);
	calcScr.setTxt(displayStr);

	--Reseta a string na tela de saida, se é uma sequencia de digitos para entrada
	--se a ultima entrada foi "equal" iniciaremos completamente
	--a nova sequencia de calculos, então chamamos clear()
	if lastInput == "equal" then
		clear();
	elseif lastInput ~= "num" then 
		displayStr = "0"; 
		decimalPressed = false; 
	end
	
	--não permite sequencia de digitos maior que 'maxDigits'
	if (string.len(displayStr) < maxDigits) then
		displayStr = displayStr .. targetID;
	end
	
	--chaca se o botao "-"  antes deste numero
	if negPressedLast then
		displayStr = "-"..displayStr;
		negPressedLast = false;
	end
	
	--estampa que o ultimos digitados eram numeros
	lastInput = "num";
	
	--limpa '0' à esquerda da string
	displayStr = cleanLeftZeros(displayStr);
	
	calcScr.setTxt(displayStr);
	startNewNumber = false;
	return true
end

local function decimalBtnTapped(event)
--manipula o numeros decimais ('.')
	local targetID = event.target.id;
	print("You pressed "..targetID);
	
	--atualiza a string na tela, se for um nova sequencia de digitos
	--se a ultima saida for "equal" nos estaremos iniciando completamente uma nova sequencia
	--de calculos, então chama clear()
	if lastInput == "equal" then
		clear();
	elseif lastInput ~= "num" then 
		displayStr = "0"; 
		decimalPressed = false; 
	end
	
	if not decimalPressed and (string.len(displayStr) < maxDigits) then
		displayStr = displayStr..".";
		decimalPressed = true;
		lastInput = "num";
	end
	calcScr.setTxt(displayStr);
	return true;
end



-------------------------------------------
--painel de botões
-------------------------------------------
--requer a classe buttons
local btnClass = require "buttons";

--cria o painel de botões
local buttonPanel = display.newGroup();
local bg = display.newRect(0,0,display.contentWidth,display.contentHeight);
bg:setFillColor(0,0,0);
bg:setStrokeColor(1,1,1);
bg.strokeWidth = 0;
bg.x , bg.y = 0,50;
buttonPanel:insert(bg);

--psiciona o painel de botões 
buttonPanel.x = display.contentWidth/2 - 100;
buttonPanel.y = display.contentHeight/2 + 100;

--array para manter todos os botões
local btns = {};
-------------------------------------------
--os botões numericos
-------------------------------------------
--variaveis de posicionamento
local padding = 15;
local rowSpacing = 100;
local colSpacing = 100;
local cols = 3; -- especifica numero de colunas

local currentRow , currentCol = 0 , 4; --ajuda a posicionar os botões numericos
for i=0 , 10 do
	local btnParams = {};
	if i==10 then
		btnParams.labelTxt = ".";
	else
		btnParams.labelTxt = i;
	end
	
	if i==0 then
	--faz o botão numerico '0' maior que os outros
		btnParams.width = 180;
	end
	
	--cria o botão e o coloca no array
	btns[#btns + 1] = btnClass.newNumBtn(btnParams);
	
	
	--identifica cada botão, então cria cada identificador para cada botão;
	if i==10 then
		--se botão '.'
		btns[#btns].id = ".";
		btns[#btns]:addEventListener("tap",decimalBtnTapped);
	else
		btns[#btns].id = i;
		--adiciona listener para o botão
		btns[#btns]:addEventListener("tap",numBtnTapped);
	end
	
	
	--posiciona os botões
	if i==0 then -- se botão'0' 
		btns[#btns].x, btns[#btns].y = - 90 , 150;
	elseif i==10 then --se botão decimal
		btns[#btns].x, btns[#btns].y = (cols-1) * colSpacing - 90 , 150;
	else --qualquer outros botão numerico (1-9);
		btns[#btns].x, btns[#btns].y =  currentCol * colSpacing - 90, currentRow * rowSpacing + 150;
	end

	--insere um novo botão no painel
	buttonPanel:insert(btns[#btns]);
	
	currentCol = currentCol + 1;
	if currentCol>= cols then currentCol = 0; end
	
	if (currentCol % 3 == 0) then currentRow = currentRow - 1; end
end

-------------------------------------------
--the math function buttons
-------------------------------------------

for i = 1, 7 do
	--cria o botão o o coloca num array
	local btnParams = {};
	local id;
	local col , row , x , y;
	
	--configure button parameters and position
	if i==1 then
		btnParams.labelTxt = "/";
		id = "/";
		col , row = 2 , 4;	
	elseif i==2 then
		btnParams.labelTxt = "X";
		id = "X";
		col , row = 3 , 4;
	elseif i==3 then
		btnParams.labelTxt = "+";
		id = "+";
		col , row = 3 , 2;
	elseif i==4 then
		btnParams.labelTxt = "-";
		id = "-";
		col , row = 3 , 3;
	elseif i==5 then
		btnParams.labelTxt = "C";
		id = "Clear";
		col , row = 0 , 4;
	elseif i==6 then
		btnParams.labelTxt = "+/-";
		id = "invertNegative";
		col , row = 1 , 4;
	else
		btnParams.labelTxt = "=";
		id = "=";
		btnParams.bgColor = {1,0.5,0};
		--o botão '=' é maior que os outros botões numericos
		btnParams.height = 180;
	end
	if id == "=" then
		x , y = 3 * colSpacing - 90, -rowSpacing + 155;
	else --outros botões numericos
		x , y = col * colSpacing - 90, -row * rowSpacing + 150;
	end
	--cria os botões matemáticos
	btns[#btns + 1] = btnClass.newMathFuncBtn(btnParams);
	
	--adiciona o event listener para o botão
	if id=="invertNegative" then
		btns[#btns]:addEventListener("tap",invertNegBtnTapped);
	else
		btns[#btns]:addEventListener("tap",mathBtnTapped);
	end
	
	--insere o novo botão no painel
	buttonPanel:insert(btns[#btns]);
	
	--posiciona o botão
	btns[#btns].x, btns[#btns].y  = x , y;
	
	--adiciona um ID ao novo botão
	btns[#btns].id = id;
end



