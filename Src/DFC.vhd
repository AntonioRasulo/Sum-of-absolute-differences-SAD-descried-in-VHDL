-- One bit DFC
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity DFC is

	generic(N: positive);
	port(
		clk: in std_logic;
		reset: in std_logic;
		d: in std_logic_vector (N-1 downto 0);
		q: out std_logic_vector(N-1 downto 0):= (others => '0')
	);

end DFC;


architecture rtl of DFC is

begin

	DFC_p: process(reset, clk)
	begin
		if reset = '1' then
			q<=(others=>'0');
		elsif(clk'event and clk = '1') then
			q<=d;
		end if;

	end process DFC_p;

end rtl;