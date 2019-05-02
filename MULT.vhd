-- <Name> 
-- <Student ID> 

-- TODO: Do all of lab
Library IEEE;
use IEEE.std_logic_1164.all;

entity HA is
	generic(width : positive := 4);
	port(A, B: in std_logic;
		Sum, Co: out std_logic);
end;
architecture behav of HA is
	Sum <= A xor B;
	Co <= B and A;
begin

end;

entity FA is
	generic(width : positive := 5);
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
	Sum <= x1 xor Ci;
	n1 <= not(A and B);
	n2 <= not(x1 and Cin);
	Co <= not(n1 and n2);
end;

entity RCA is 
	generic(length : postive := 4);
	port(X, Y : in std_logic_vector(length - 1 downto 0);
		Cin: in std_logic;
		S: out std_logic_vector(width downto 0));
end;
architecture behav of RCA is
	signal c: std_logic_vector(length downto 0);
begin
	c(0) <= Cin;
	RCA_gen: for i in 0 to length - 1 generate
		FA_comp: FA
			port map (X(i), Y(i), c(i), S(i), c(i + 1));
	end generate;
	S(length)
end;

entity MULT is 
    -- resource: https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-generics/
    generic ( X_Len, Y_Len: integer := 4 );
    port (x : in std_logic_vector(X_Len downto 0);
          Y : in std_logic_vector(Y_Len Downto 0);
          P : out std_logic_vector( X_Len + Y_Len downto 0));

end MULT;
	
architecture struct of MULT is 
	type PP is array(Y_Len - 1 downto 0, X_Len - 1 downto 0) of std_logic;
		signal intermediate: PP := (others(others => '0'));		--Y rows, X columns
	type HA_array is array() of std_logic;
	type FA_array is array() of std_logic;
begin
	--makes 2d array of partial products
	for i in 0 to Y_Len loop
		for j in 0 to X_Len loop
			intermediate(i , j) <= Y(i) and X(i);
		end loop;
	end loop;
	
	--generate Half Adders: #X bits - 1
	HA_generate: for i in 0 to X_Len - 2 generate
		HA_comp: HA
			port map(A(), B(), Sum(), Co());
	end generate;
	
	FA_generate: for 
		FA_comp: FA
			port map(A(), B(), Cin(), Sum(), Co());
	end generate;
	
	
	
end struct; 

