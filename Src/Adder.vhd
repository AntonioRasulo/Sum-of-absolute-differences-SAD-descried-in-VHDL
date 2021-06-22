--Adder
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Adder is

	generic(N: positive);
	port(
		input1: in std_logic_vector(N-1 downto 0);
		input2: in std_logic_vector(N-1 downto 0);
		output: out std_logic_vector(N-1 downto 0)
	);

end entity;

architecture rtl of Adder is

begin

	output <= input1 + input2;

end rtl;