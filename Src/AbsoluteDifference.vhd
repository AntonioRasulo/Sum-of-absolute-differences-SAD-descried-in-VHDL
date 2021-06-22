library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	--standard package where signed is defined

entity AbsoluteDifference is

	generic (
			N : positive
	);
	
	port(
		X: in std_logic_vector(N-1 downto 0);	--input
		Y: in std_logic_vector(N-1 downto 0);	--input
		Z: out std_logic_vector(N-1 downto 0);	--output
		clk: in std_logic;
		rst: in std_logic
	);

end entity;

architecture rtl of AbsoluteDifference is

	signal z_tmp: std_logic_vector(N-1 downto 0);

begin

	AbsoluteDifference_p: process(clk, rst)
	begin
		if(rst = '1') then
			z_tmp <= (others=>'0');
		elsif(clk'event and clk='1') then 
			z_tmp <= std_logic_vector(abs(signed(X)-signed(Y)));
		else
			z_tmp <= z_tmp;
		end if;
		
		Z <= z_tmp; 
		
	end process AbsoluteDifference_p;

end rtl;