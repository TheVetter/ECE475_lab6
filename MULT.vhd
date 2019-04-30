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

entity NXOR is 
	generic()
	port()
end;

architecture behav of NXOR is
begin

end;

entity HA is
	generic(width : positive := 4);
	port(A, B: in std_logic;
		S, Co: out std_logic);
end;
architecture behav of HA is
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
	x1 <= NXOR(A, B);
	Sum <= NXOR(x1, Ci);
	n1 <= NAND2(A, B);
	n2 <= NAND2(x1, Cin);
	Co <= NAND2(n1, n2);
end;

entity RCA is 
	generic()
	port()
end;

architecture behav of RCA is
begin

end;
	
architecture struct of MULT is 

begin

end struct; 

