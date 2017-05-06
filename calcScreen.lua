local class = {};
--esta classe cria o calc. display

	function class.new()
	--construtor da classe para criar um novo calc display
		--define algumas variáveis
		local width, height, textSize;
		width = display.contentWidth-20;
		height = 100;
		textSize = 70;
		
		--um diplay group mantem nosso calc display
		local screenGroup = display.newGroup();
		
		--desenha o background
		local bg = display.newRect(10, 40, width, height);
		bg:setFillColor(0.5,0.5,0.5,0);
		bg.strokeWidth = 0;
		--posiciona isto
		bg.anchorX, bg.anchorY = 0, 0;
		
		--cria o objeto texto
		local txt = display.newText("0", 20, 100, native.systemFont, textSize)
		txt:setTextColor(1,1,1);
		
		--posiciona o label (nos definimos isto na função 
		--desde que nos temos posicionado o texto a cada momento
		--é alterado)
		local function positionLabel()
			local padding = 5;
			
			txt.anchorX = 0.5--(bg.contentWidth - txt.contentWidth) *.5 - padding;
			txt.anchorY = 0.5;
		end
		positionLabel();
	
		--inesre os components no grupo display do main
		screenGroup:insert(bg);
		screenGroup:insert(txt);
		
		
		--public class functions
		function screenGroup.setTxt(str)
			txt.text = str;
			print(str);
			positionLabel();
		end
		
		--retorna um handle para o objeto display 
		return screenGroup;
	end
return class;
