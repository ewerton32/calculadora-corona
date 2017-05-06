
local class = {};
function class.newBtn(params)
--esta function um novo botão generico
	--get parameters or set defaults
	local width = params.width or 80;
	local height = params.height or 80
	local labelTxt = params.labelTxt or "";
	local bgColor = params.bgColor or {0,0,0};
	local txtColor = params.txtColor or {1,1,1};
	
	--Nosso display de botões
	local btn = display.newGroup();
	
	--button background
	local bg = display.newRoundedRect(0,0,width,height,6);
	bg:setFillColor(bgColor[1],bgColor[2],bgColor[3]);
	
	--posicionando o bg
	bg.anchorX , bg.anchorY = 0,0;
	--inser o background dos botões com group:insert
	btn:insert(bg);
	
	--cria o button's label
	local label = display.newText(labelTxt,0,0,native.systemFont, 70)
	label:setTextColor(txtColor[1],txtColor[2],txtColor[3]);
	
	--posiciona a label
	label.anchorX , label.anchorY = 0 , 0;
	
	--Insere a label no grupo de botões
	btn:insert(label);
	return btn;
end

------------------------------------------------------------------------------------
--As funções seguintes mostram como usar herança com lua
--estas funções extendem as funções mais genericas de newBtn definidas antes
------------------------------------------------------------------------------------

function class.newNumBtn(params)
	local numBtnParams = params or {};
	numBtnParams.bgColor = params.bgColor or {0,0,1};
	return class.newBtn(numBtnParams);
end

function class.newMathFuncBtn(params)
	local numBtnParams = params or {};
	numBtnParams.bgColor = params.bgColor or {1,0,0};
	return class.newBtn(numBtnParams);
end

return class;
