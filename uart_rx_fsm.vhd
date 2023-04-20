-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Adam Nieslanik (xniesl00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



entity UART_RX_FSM is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       VLD : in std_logic
    );
end entity;

CNT    :  in std_logic_vector(4 downto 0);
BIT_CNT     :  in std_logic_vector(3 downto 0); 
READ_EN: in std_logic;
CNT_EN: in std_logic;


architecture behavioral of UART_RX_FSM is
    type state is (
        INIT,
        START,
        READ_IN,
        END_STATE,
        VALID_STATE
    );
    signal present_state, next_state: state;
begin
    if (RST = '1') then
        present_state <= INIT;
    
    elsif (CLK'event and CLK = '1')
        present_state <= next_state;
    end if;

fsm: process (present_state, CLK, RST, cnt, readable,VLD) is
    begin
    CLK <= '0';
    RST <= '0';
    READ_EN <= '0';

    case state is
        when INIT =>
            next_state <= START;

        when START =>
            CNT_EN <= '1';
            next_state <= READ_IN;

        when READ_IN =>
            READ_EN <= '1';
            CNT_EN <= '1';
            if cnt_bit = '100' then
                next_state <= END_STATE;
            else
                next_state <= READ_IN;
            end if;

        when END_STATE =>
            CNT_EN <= '1';
            next_state <= VALID_STATE;

        when VALID_STATE =>
                CNT_EN <= '0';
                VLD <= '1';
                
    end case;
    end process;
        
end architecture;
