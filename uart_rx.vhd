-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Adam Nieslanik (xniesl00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;

signal cnt: in std_logic_vector(4 downto 0);
signal bit_cnt: in std_logic_vector(3 downto 0);
signal read_en: std_logic;
signal cnt_en: in std_logic;

-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
begin

    -- Instance of RX FSM
    fsm: entity work.UART_RX_FSM
    port map (
        CLK => CLK,
        RST => RST,
        CNT => cnt,
        BIT_CNT => bit_cnt,
        READ_EN => read_en,
        CNT_EN => cnt_en,
        VLD => vld    
    );

    DOUT <= (others => '0');
    DOUT_VLD <= '0';

process(CLK) begin
    if cnt_en = '1' then
        cnt <= cnt + 1;
    else
        cnt <= (others => '0');
    end if;

    if read_en = '1' then
        if cnt = '1000' then
            cnt <= (others => '0');
            DOUT(to_integer(cnt_bit)) <= DIN;
            bit_cnt <= bit_cnt + 1;
        else if cnt = '10000' then
            cnt <= (others => '0');
            DOUT(to_integer(cnt_bit)) <= DIN;
            bit_cnt <= bit_cnt + 1;
        end if;
    end if;

    if vld = '1' then
        DOUT_VLD <= '1';
    end if;
    end if;

    end process;
end architecture;
