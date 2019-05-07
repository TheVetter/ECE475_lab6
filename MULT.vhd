-- <Name> 
-- <Student ID> 

library IEEE;
use IEEE.STD_LOGIC_1164.all;
package arrayTypes is
	--generic ( X_Len, Y_Len: integer := 4 );							--do we want to leave this set to 4?
	
	-- type PP is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
	type arrayType is array(natural range <>, natural range <>) of std_logic;
		-- signal inter_product : PP; 									--Y rows, X columns
	-- type Sum_array is array(Y_Len downto 0, X_Len downto 0) of std_logic;
		-- signal inter_sum: Sum_array;   
	-- type Carry_array is array(Y_Len downto 0, X_Len - 1 downto 0) of std_logic;
		-- signal inter_carry: Carry_array; 
end package arrayTypes; 


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
	
	-- type Sum_array is array(Y_Len downto 0, X_Len downto 0) of std_logic;
		-- signal inter_sum: Sum_array;   

	port(A, B: in arrayType;
		result: out std_logic_vector(X_Len+Y_Len-1 downto 0));
end hockeystick;
architecture behav of hockeystick is
	signal temp : std_logic_vector(X_Len+Y_Len-1 downto 0);
begin
	colonprocess : process
	begin
		for i in 0 to Y_Len-1 loop	--column 0
			temp(i) <= A(i,0);-- & temp; -- (Y row, X col)
		end loop; 
		for j in 1 to X_Len-1 loop
			temp(j+(Y_Len-1)) <= A(Y_Len-1,j);-- & temp;
		end loop; 
		temp(X_Len+Y_Len-1) <= B(Y_Len-1, X_Len-1);-- & temp;
	end process; 
end;
------- end hockeystick (Result grabber) ---------

Library IEEE;
use IEEE.std_logic_1164.all;
----------- RCA Adder ---------
-- arbitrarily sized RCA
-- only works if X and Y are same length
-- "length" is the number of FA's (0 to length-1)
entity RCA is 
	port(X, Y : in std_logic_vector(3 downto 0); --left bound should be "length-1", so hardcoded for a length of 4, it's a 3
		Cin: in std_logic;
		S: out std_logic_vector(4 downto 0));  --left bound was width, I changed it to length bc what is width? X and Y are the same length currently anyway
end;

architecture behav of RCA is
 	component HA
	port(A, B: in std_logic;
		Sum, Co: out std_logic);
	end component;
	
	component FA
	port(A, B, Cin: in std_logic;
		Sum, Co: out std_logic); 
	end component;
  
	signal c: std_logic_vector(4 downto 0);   --left bound was length, hardcoded to 4
begin
	c(0) <= Cin;
	RCA_gen: for i in 0 to 3 generate  --was 0 to length-1, changed to 3
		FA_comp: 
		FA port map (X(i), Y(i), c(i), S(i), c(i + 1));
	end generate;
	S(4) <= c(4); --both were indexed to length, changed to 4
	
	--TODO: still needs HA?
end;
------- end RCA Adder ---------

Library IEEE;
use IEEE.std_logic_1164.all;
library work; 
use work.arrayTypes.all;
entity MULT is 
    -- resource: https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-generics/
    generic ( X_Len, Y_Len: integer := 4 );							--do we want to leave this set to 4?
    port (x : in std_logic_vector(X_Len downto 0);
          y : in std_logic_vector(Y_Len downto 0);
          P : out std_logic_vector( X_Len + Y_Len downto 0));

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
		port(A: in arrayType;
			result: out std_logic_vector(X_Len+Y_Len-1 downto 0)); 
	end component;

	
	--initializing arrays
	type PP is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
		signal inter_product : PP; 									--Y rows, X columns
	type Sum_array is array(Y_Len downto 0, X_Len downto 0) of std_logic;
		signal inter_sum: Sum_array;   
	type Carry_array is array(Y_Len downto 0, X_Len - 1 downto 0) of std_logic;
		signal inter_carry: Carry_array; 
		
	signal result std_logic_vector(X_Len+Y_Len-1 downto 0); 
	signal carryo std_logic;
		
begin
		
	--generate 2d array of partial products
	ppgen1: for i in Y_Len-1 downto 0 generate
		ppgen2: for j in X_Len-1 downto 0 generate
		
			PP_AND: if (i /= Y_Len-1 xor j /= X_Len-1) generate
				bob: myAND port map(Y(i),X(j),inter_product(i,j));
			end generate;
			
			PP_NAND: if not(i /= Y_Len-1 xor j /= X_Len-1) generate
				banana: myNAND port map(Y(i),X(j),inter_product(i,j));
			end generate;
			
		end generate;
	end generate;
	
	--Half adder for loop
	hagen1: for j in 1 to X_Len-1 generate
		pineapple: HA port map(inter_product(0, j), inter_product(1, j-1), inter_sum(1, j), inter_carry(1, j));
	end generate;

	--Middle rows for loop
		--inside FA loop
	mgen1: for i in 2 to Y_Len-1 generate
		mgen2: for j in 0 to X_Len-2 generate
			mango: FA port map(inter_product(i, j), inter_sum(i-1, j+1), inter_carry(i-1,j+1), inter_sum(i,j), inter_carry(i,j+1)) ;
		end generate;
		
		apple: FA port map(inter_product(i, X_Len-2), inter_product(i-1, X_Len-1), inter_carry(i-1, X_Len-1), inter_sum(i, X_Len-1), inter_carry(i, X_Len-1)) ;
	end generate;
	

	--last row for loop
		-- lonely full adder (half adder whose carry-in is always 1)
	durian: FA port map (inter_sum(y_len-1, 1), inter_carry(Y_Len-1, 1), '1' , inter_sum(Y_Len, 0), inter_carry(Y_Len, 0));
		--inside FA loop
	finalgen: for i in 1 to X_Len-2 generate
		grape: FA port map (inter_sum(y_len-1, i), inter_carry(Y_Len-1, i),inter_carry(Y_Len, i), inter_sum(Y_Len, i), inter_carry(Y_Len, i+1));
	end generate;

	-- lonely full adder (whose carry-out is special (bottom left most FA))
	cherry: FA port map (inter_product(y_len-1, x_len-1), inter_carry(Y_Len-1, 1), inter_carry(Y_Len, x_len-1) , inter_sum(Y_Len, X_Len-1), inter_carry(Y_Len, x_len-1	));
	
	--get the result
	hspuck : hockeystick port map(inter_sum, inter_carry, result); 
	
	addOnes: for i in Y_Len to result'length generate
		if (i = Y_Len) generate
			snapple : HA port map (result(i), '1', carryo, result(i)); 
		end generate;
		if (i /= Y_Len and i /= X_Len+Y_Len) generate
			theBestStuffOnEarth: HA port map (result(i), carryo, carryo, result(i));
		end generate;
		if (i = X_Len+Y_Len) generate
			lastGuy: FA port map (result(i), '1', carryo, carryo, result(i));
		end generate;
	end generate;

	return result;
	
	end struct; 
