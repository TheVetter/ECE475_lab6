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
	generic(width : positive := 2);
	port(A: in std_logic_vector(width-1 downto 0);
		Z: out std_logic);
end;
architecture behav of AND2 is
begin
	p1: process(A)
	variable temp: std_logic := '1';
	begin
		for i in A'length-1 downto 0 loop
			temp := temp and A(i);
		end loop;
		Z <= temp;
	end process;
end architecture;

entity NAND2 is	
	generic(width: positive := 2);
	port(A : in std_logic_vector(width-1 downto 0)
		Z: out std_logic);
end;

architecture behav of NAND2 is
begin
	p1: process(A)
	begin
		Z <= not(AND2(A));
	end process;
end;

entity HA is
	generic()
	port()
end;
architecture behav of HA is
begin

end;

entity FA is
	generic()
	port()
end;
architecture behav of FA is
begin

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

