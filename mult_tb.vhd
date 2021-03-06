library IEEE;
use IEEE.std_logic_1164.all;
use std.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;

entity Mult_tb is
end entity;

architecture TESTBENCH of Mult_tb is
    file output_manager: TEXT open write_mode is "SM_TEST.txt";
    constant top_line: string :=    "     X         Y    |  Result";
    constant middle_line: string := "-----------------------------";
    constant divider : string := "| ";

    component MULT
        generic ( X_Len : integer := 4	 ; Y_Len: integer := 4 );
        port (  X : in std_logic_vector(X_Len-1 downto 0);
                Y : in std_logic_vector(Y_Len-1 Downto 0);
                P : out std_logic_vector( X_Len + Y_Len -1 downto 0));
    end component;

    signal X_thing: Std_logic_vector(4 downto 0); -- length of 5
    signal Y_thing: Std_logic_vector(4 downto 0); -- length of 4
	signal z_thing: Std_logic_vector(5 downto 0); -- length of 5
    signal result1 : Std_logic_vector(X_thing'length+ Y_thing'length  -1 downto 0);
	
    signal result2 : Std_logic_vector(Z_thing'length+ Y_thing'length -1 downto 0);
begin

    U1: MULT
    generic map ( X_thing'length , Y_thing'length )
    port map (  x_thing,
                Y_thing,
                result1);

    U2: MULT
       generic map ( z_thing'length  , y_thing'length)
       port map (  z_thing,
                   Y_thing,
                   result2);

    DATA: process
        variable L: line;
        variable I, J: integer;
        variable w : unsigned(x_thing'high downto 0):= (others => '0');
        variable v : unsigned(Y_thing'high downto 0):= (others => '0');
        variable u : unsigned(z_thing'high downto 0):= (others => '0');
        
    begin
        -- write header
        write(L, top_line);
        writeline(output_manager,L);
        write(L, middle_line);
        writeline(output_manager,L);

        for I in 0 to 15 loop
            for J in 0 to 15 loop
                X_thing<= Std_logic_vector(w);
                Y_thing <= Std_logic_vector(v);

                write(L, X_thing, left, 10);
                write(L, Y_thing,       left, 10 );
                WRITE(L, divider, left, 3);
                write(L, Result1,    left, 15);
                writeline(output_manager,L);
                v := v + "1";
                wait for 10 ns;
            end loop;
            v:=(others => '0');
            w := w + "1";
        end loop;

        write(L, middle_line);
        writeline(output_manager,L);

       for I in 0 to 32 loop
           for J in 0 to 15 loop
               Z_thing <= Std_logic_vector(u);
               Y_thing <= Std_logic_vector(v);

               write(L, Z_thing,       left, 10);
               write(L, Y_thing,       left, 10);
               WRITE(L, divider, left, 5);
               write(L, result2,    left, 10);
               writeline(output_manager,L);
               v := v + "1";
               wait for 10 ns;
           end loop;
           v:=(others => '0');
           u := u + "1";
       end loop;
    end process;

end TESTBENCH;
