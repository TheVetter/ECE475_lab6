-- <Name> 
-- <Student ID> 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
package arrayTypes is
	type arrayType is array(natural range <>, natural range <>) of std_logic;
end package arrayTypes; 
------ end package ------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- AND ---------
entity myAND is
	port(A, B: in std_logic;
		ANDout: out std_logic);
end;
architecture behav of myAND is
begin
	ANDout <= A and B;
end;
------- end AND ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- NAND ---------
entity myNAND is
	port(A, B: in std_logic;
		NANDout: out std_logic);
end;
architecture behav of myNAND is
begin
	NANDout <= A nand B;
end;
------- end NAND ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- XOR ---------
entity myXOR is
	port(A, B: in std_logic;
		XORout: out std_logic);
end;
architecture behav of myXOR is
begin
	XORout <= A xor B;
end;
------- end XOR ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- NOT ---------
entity myNOT is
port(A: in std_logic;
		NOTout: out std_logic);
end;
architecture behav of myNOT is
begin
    NOTout <= not A;
end;
------- end NOT ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- Half Adder ---------
entity HA is
	port(A, B: in std_logic;
		Sum, Co: out std_logic);
end;
architecture behav of HA is
begin
	Sum <= A xor B;
	Co <= B and A;
end;
------- end Half Adder ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- Full Adder ---------
entity FA is
	port(A, B, Cin: in std_logic;
		Sum, Co: out std_logic); 
end;
architecture behav of FA is
	signal x1 : std_logic;
	signal x2 : std_logic;
	signal n1 : std_logic;
	signal n2 : std_logic;
begin
	x1 <= A xor B;
	Sum <= x1 xor Cin;
	n1 <= not(A and B);
	n2 <= not(x1 and Cin);
	Co <= not(n1 and n2);
end;
------- end Full Adder ---------

Library IEEE;
use IEEE.std_logic_1164.all;
library work; 
use work.arrayTypes.all;
----------- hockeystick ---------
entity hockeystick is
	generic ( X_Len, Y_Len: integer := 4 ); --do we want to leave this set to 4?
	
	port(A, B: in arrayType;
		result: out std_logic_vector(X_Len+Y_Len downto 0));
end hockeystick;
architecture behav of hockeystick is
	signal temp : std_logic_vector(X_Len+Y_Len downto 0) := (others => '0');
begin
	colonprocess : process
	begin
		for i in 0 to Y_Len-1 loop	--column 0
			temp(i) <= A(i,0);  -- (Y row, X col)
		end loop; 
		for j in 1 to X_Len-1 loop
			temp(j+(Y_Len-1)) <= A(Y_Len-1,j);
		end loop; 
		temp(X_Len+Y_Len-1) <= B(Y_Len-1, X_Len-1);
		wait for 10 ns;
	end process;
	result <= temp;
end;
------- end hockeystick (Result grabber) ---------

Library IEEE;
use IEEE.std_logic_1164.all;
library work; 
use work.arrayTypes.all;
entity MULT is 
    -- resource: https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-generics/
    generic ( X_Len, Y_Len: integer := 4 );							--do we want to leave this set to 4?
    port (x : in std_logic_vector(X_Len-1 downto 0);
          y : in std_logic_vector(Y_Len-1 downto 0);
          P : out std_logic_vector( X_Len + Y_Len-1 downto 0));

end MULT;
	
architecture struct of MULT is 
	component myAND 
		port(A, B: in std_logic;
			ANDout: out std_logic);
	end component;
	
	component myNAND
		port(A, B: in std_logic;
			NANDout: out std_logic);
	end component;
	
	component myXOR 
	port(A, B: in std_logic;
		XORout: out std_logic);
	end component;

	component myNOT
	port(A: in std_logic;
			NOTout: out std_logic);
	end component;

	component HA
	port(A, B: in std_logic;
		Sum, Co: out std_logic);
	end component;
	
	component FA
	port(A, B, Cin: in std_logic;
		Sum, Co: out std_logic); 
	end component;
	
	component hockeystick is
		port(A, B: in arrayType;
			result: out std_logic_vector(X_Len+Y_Len-1 downto 0));
	end component;
	
	constant xTop : integer := X'length -1;
	constant yTop : integer := Y'length -1;

	--initializing arrays
	type PP is array(0 to yTop, 0 to xTop) of std_logic;
		signal inter_product : PP; 									--Y rows, X columns
	type Sum_array is array(0 to Y_Len, 0 to xTop) of std_logic;
		signal inter_sum: Sum_array;   
	type Carry_array is array(0 to Y_Len, 0 to xTop) of std_logic;
		signal inter_carry: Carry_array;

	signal tempInterSum : arrayType(0 to Y_Len, 0 to xTop);
	signal tempInterCarry : arrayType(0 to Y_Len, 0 to xTop);

	signal result : std_logic_vector(X_Len+Y_Len-1 downto 0) := (others => '0');
	signal carryo : std_logic;
		
begin
 			
	--generate 2d array of partial products
	ppgen1: for i in 0 to yTop generate
		ppgen2: for j in 0 to xTop generate
		
			PP_AND: if not(i /= yTop xor j /= xTop) generate
				bob: myAND port map(Y(i),X(j),inter_product(i,j));
			end generate;
			
			PP_NAND: if (i /= yTop xor j /= xTop) generate
				banana: myNAND port map(Y(i),X(j),inter_product(i,j));
			end generate;
			
		end generate;
	end generate;
	
	inter_sum(0,0) <= inter_product(0,0);
	
	--Half adder for loop
	hagen1: for j in 1 to xTop generate
		pineapple: HA port map(inter_product(0, j), inter_product(1, j-1), inter_sum(1, j-1), inter_carry(1, j));
	end generate;

	--Middle rows for loop
		--inside FA loop
	mgen1: for i in 2 to yTop generate
		mgen2: for j in 0 to xTop-2 generate
			mango: FA port map(inter_product(i, j), inter_sum(i-1, j+1), inter_carry(i-1,j+1), inter_sum(i,j), inter_carry(i,j+1)) ;
		end generate;
		
		apple: FA port map(inter_product(i, xTop-1), inter_product(i-1, xTop), inter_carry(i-1, xTop), inter_sum(i, xTop-1), inter_carry(i, xTop)) ;
	end generate;


	--last row for loop
		-- lonely full adder (half adder whose carry-in is always 1)
	durian: FA port map (inter_sum(yTop, 0), inter_carry(yTop, 1), '1', inter_sum(Y_Len, 0), inter_carry(Y_Len, 1));
		--inside FA loop
	finalgen: for i in 1 to xTop-1 generate
		grape: FA port map (inter_sum(yTop, i), inter_carry(yTop, i+1),inter_carry(Y_Len, i), inter_sum(Y_Len, i), inter_carry(Y_Len, i+1));
	end generate;

	-- lonely full adder (whose carry-out is special (bottom left most FA))
	cherry: FA port map (inter_product(yTop, xTop), inter_carry(yTop, xTop), inter_carry(Y_Len, xTop-1) , inter_sum(Y_Len, xTop-1), inter_sum(Y_Len, xTop)); --the last term is the carry out which gets put into the sum array
	
	--------------------------------------
	
	-- tempInterSum <= arrayType(inter_sum);
	-- tempInterCarry <= arrayType(inter_carry);
	-- --get the result
	-- hspuck : hockeystick --generic map(X_Len, Y_Len)
				-- port map(tempInterSum, tempInterCarry, result);

	-- addOnes: for i in Y_Len to X_Len+Y_Len generate
		-- papple: if (i = Y_Len) generate
			-- snapple : HA port map (result(i), '1', carryo, result(i));
		-- end generate;
		-- chris: if (i /= Y_Len and i /= X_Len+Y_Len) generate
			-- theBestStuffOnEarth: HA port map (result(i), carryo, carryo, result(i));
		-- end generate;
		-- sidney: if (i = X_Len+Y_Len) generate
			-- lastGuy: FA port map (result(i), '1', carryo, carryo, result(i));
		-- end generate;
	-- end generate;

	P <= inter_sum(Y_Len,4)&inter_sum(Y_Len,3)&inter_sum(Y_Len,2)&inter_sum(Y_Len,1)&inter_sum(Y_Len,0)&inter_sum(yTop,0)&inter_sum(yTop-1,0)&inter_sum(yTop-2,0)&inter_sum(yTop-3,0)&inter_sum(yTop-4,0);
--inter_product(2, xTop-1)& inter_product(2-1, xTop)& inter_carry(2-1, xTop)& "0000000";--
	
	end struct;
