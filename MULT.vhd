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

architecture struct of MULT is 
begin

end struct; 

