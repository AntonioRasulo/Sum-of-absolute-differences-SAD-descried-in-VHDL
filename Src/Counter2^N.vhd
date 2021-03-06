--Counter 2^N
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Counter2N is

	generic(N: positive);
	port(
		clk: in std_logic;
		reset: in std_logic;
		input_cnt: in std_logic_vector(N-1 downto 0);
		y: out std_logic_vector(N-1 downto 0)
	);

end entity;


architecture Struct of Counter2N is

	signal tmp_out: std_logic_vector(N-1 downto 0);
	signal d_s: std_logic_vector(N-1 downto 0);

component DFC
	generic (N :positive);
	port(
		clk: in std_logic;
		resetn: in std_logic;
		d: in std_logic_vector (N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0)
	);
end component DFC;

component Adder
generic(N: positive);
	port(
		input1: in std_logic_vector(N-1 downto 0);
		input2: in std_logic_vector(N-1 downto 0);
		output: out std_logic_vector(N-1 downto 0)
	);
end component Adder;

begin

	i_Adder:Adder
	generic map(N=>N)
		port map(
			input1 => tmp_out,
			input2 => input_cnt,
			output => d_s
		);

	i_DFC:DFC
	generic map(N=>N)
		port map(
			clk => clk,
			resetn => reset,
			d => d_s,
			q => tmp_out
		);
		
	y <= tmp_out;

end Struct;