library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Main is

PORT (

clck : IN std_logic; 
reset : IN std_logic;
inputMoney : IN std_logic_vector (1 downto 0);
pringlesCan : out std_logic;
change : OUT std_logic_vector (1 downto 0)

);

end Main;



architecture Behavioral of Main is

type state_type is (idle,
	wait_input_coin,
	one_dollarInput, three_dollarInput, five_dollarInput, six_dollarInput,
	one_dollarChange,
	dispensePringlesState
	);
	
	
signal currentState, nextState: state_type;

begin


process (clck, reset)
begin
	if(reset = '0')then
	currentState <= idle;
	elsif (clck'event and clck ='1') then
		currentState <= nextState;
		end if;
end process;

---------------------------------------------------

process (currentState, inputMoney)
begin
case currentState is
	when idle =>
		pringlesCan <= '0';
		change <= "00";
		nextState <= wait_input_coin;
		
------------------------------------------------

when wait_input_coin=>
	if(inputMoney = "00") then -- idle
	pringlesCan <= '0';
	change <= "00";
	nextState <= wait_input_coin;
	
	elsif(inputMoney = "01") then -- 1 dollar is inputted
		pringlesCan <= '0';
		change <= "00";
		nextState <= one_dollarInput;
		
	elsif (inputMoney = "10") then -- 2 dollars are inputted (single 2 dollar bill)
		pringlesCan <= '0';
		change <= "00";
		nextState <= dispensePringlesState;
		
	elsif (inputMoney = "11")then --5 dollars bill is inputted
		pringlesCan <= '0';
		change <= "00";
		nextState <= five_dollarInput;
end if;

-----------------------------------------------------

when one_dollarInput=>  
	if(inputMoney = "00") then
	pringlesCan <= '0';
	change <= "00";
	nextState <= one_dollarInput;
	
	elsif (inputMoney = "01") then -- 1 dollar is inserted second time after first input.
	pringlesCan <= '0';
	change <= "00";
	nextState <= dispensePringlesState;
	
	elsif (inputMoney <= "10") then -- 2 dollar is inserted second time after 1 dollar
	pringlesCan <= '0';
	change <= "00";
	nextState <= three_dollarInput;
	
	elsif (inputMoney <= "11") then -- 5 dollar is inserted after 1 dollar
	pringlesCan <= '0';
	change <= "10";
	nextState <= six_dollarInput;
	end if;
	
-------------------------------------------------------

when three_dollarInput=>
	pringlesCan <= '0';
	change <="01";
	nextState <= dispensePringlesState;
	
-------------------------------------------------------

when six_dollarInput=>
	pringlesCan <= '0';
	change <= "01";
	nextState <= five_dollarInput;
	
	
--------------------------------------------------------


when five_dollarInput=>
	pringlesCan <='0';
	change <="01";
	nextState <= dispensePringlesState;
	
---------------------------------------------------

when one_dollarChange =>
	pringlesCan <= '0';
	change <= "01";
	nextState <= dispensePringlesState;
	
-------------------------------------------------------

when dispensePringlesState=>
	pringlesCan <= '1';
	change <= "00";
	nextState <= wait_input_coin;
	
end case;
end process;



end Behavioral;