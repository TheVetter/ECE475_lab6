-- <Name> 
-- <Student ID> 

-- TODO: Do all of lab
Library IEEE;
use IEEE.std_logic_1164.all;

entity MULT is 
    -- resource: https://surf-vhdl.com/vhdl-syntax-web-course-surf-vhdl/vhdl-generics/
    generic ( X_Len, Y_Len: integer := 4 );
    port (x : in std_logic_vector(X_Len downto 0);
          Y : in std_logic_vector(Y_Len Downto 0);
          P : out std_logic_vector( X_Len + Y_Len downto 0));

end MULT;

entity AND2 is
	generic(width : positive := 3);
	port(A, B: in std_logic;
			Z: out std_logic);
end;
architecture behav of AND2 is
begin
	Z <= A and B;
end architecture;

entity NAND2 is	
	generic(width: positive := 3);
	port(A, B : in std_logic;
		Z: out std_logic);
end;
architecture behav of NAND2 is
begin
	Z <= not(AND2(A, B));

end;

entity XOR2 is 
	generic(width: positive := 3);
	port(A, B: in std_logic;
		Z: out std_logic);
end;
architecture behav of XOR2 is
begin
	Z <= A xor B;
end;

entity HA is
	generic(width : positive := 4);
	port(A, B: in std_logic;
		S, Co: out std_logic);
end;
architecture behav of HA is
	S <= XOR2(A, B);
	Co <= AND2(B, A);
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
	x1 <= XOR2(A, B);
	Sum <= XOR2(x1, Ci);
	n1 <= NAND2(A, B);
	n2 <= NAND2(x1, Cin);
	Co <= NAND2(n1, n2);
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
	
architecture struct of MULT is 

begin
	
end struct; 

