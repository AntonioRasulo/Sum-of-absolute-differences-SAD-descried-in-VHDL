--Comparator

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Comparator is

	generic(N: positive);
	port(
		eq: out std_logic;
		input1: in std_logic_vector (N-1 downto 0);
		input2: in std_logic_vector(N-1 downto 0)
	);

end Comparator;

architecture foo of Comparator is

begin
--	Comparator_p: process(input1, input2)
--	begin
	--	if input1 = input2 then
		--	eq = '1';
		--else
		--	eq = '0';
		--end if;
		eq <= '1' when input1 = input2 else '0';	
	
--	end process;
end foo;