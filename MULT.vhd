-- <Name> 
-- <Student ID> 

-- TODO: Do all of lab
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
----------- RCA Adder ---------
-- arbitrarily sized RCA
-- only works if X and Y are same length
-- "length" is the number of FA's (0 downto length-1)
entity RCA is 
	port(X, Y : in std_logic_vector(3 downto 0); --left bound should be "length-1", so hardcoded for a length of 4, it's a 3
		Cin: in std_logic;
		S: out std_logic_vector(4 downto 0));  --left bound was width, I changed it to length bc what is width? X and Y are the same length currently anyway
end;
architecture behav of RCA is
	signal c: std_logic_vector(4 downto 0);   --left bound was length, hardcoded to 4
begin
	c(0) <= Cin;
	RCA_gen: for i in 0 to 3 generate --was 0 to length-1, changed to 3
		FA_comp: FA
			port map (X(i), Y(i), c(i), S(i), c(i + 1));
	end generate;
	S(4) <= c(4); --both were indexed to length, changed to 4
end;
------- end RCA Adder ---------

Library IEEE;
use IEEE.std_logic_1164.all;
entity MULT is 
    -- resource: https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-generics/
    generic ( X_Len, Y_Len: integer := 4 );							--do we want to leave this set to 4?
    port (x : in std_logic_vector(X_Len downto 0);
          y : in std_logic_vector(Y_Len downto 0);
          P : out std_logic_vector( X_Len + Y_Len downto 0));

end MULT;
	
architecture struct of MULT is 
	component HA
	port(A, B: in std_logic;
		Sum, Co: out std_logic);
	end component;
	
	component FA
	port(A, B, Cin: in std_logic;
		Sum, Co: out std_logic); 
	end component;
	
	component RCA 
	port(X, Y : in std_logic_vector(length - 1 downto 0);
		Cin: in std_logic;
		S: out std_logic_vector(width downto 0)); --intermediate
	end component;
	
	--initializing arrays
	type PP is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
		signal PP := (others(others => '0'));		--Y rows, X columns
	type Sum_array is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
		signal inter_sum: Sum_array := (others(others => '0'));
	type Carry_array is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
		signal inter_carry: Carry_array:= (others(others => '0'));

begin
	--makes 2d array of partial products
	for i in 0 to Y_Len loop
		for j in 0 to X_Len loop
			intermediate(i , j) <= Y(i) and X(i);
		end loop;
	end loop;
	
	--generate Full Adders and Half Adders
	GEN_adders: for i in 0 to Y_Len - 1 generate
		GEN_adders2: for 0 to X_Len - 1 generate
			HA_generate: if i = 0 generate				-- P00 goes straight to S0 tho? 
				U0: HA
					port map(A(), B(), Sum(), Co());	-- what goes in the ()?
			end generate HA_generate;
			
			FA_generate: if i > 0 generate
				UX: FA
					port map(A(), B(), Cin(), Sum(), Co());
			end generate FA_generate;
		end generate GEN_adders2;
	end generate GEN_adders;
	
	
end struct; 
