-- =====================================================================
--  Title       : Signed add/sub package sample
--
--  File Name   : CALC.vhd
--  Project     : 
--  Block       :
--  Tree        :
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2019/10/13
--  Copyright   : 2019 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- =====================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.PAC_CALC.all;

entity CALC is
    port(
    -- System --
        CLK                 : in    std_logic;                          --(p) Clock
        RESET_n             : in    std_logic;                          --(n) Reset

    -- Control --
        MODE                : in    std_logic;                          --(p) Mode select(H:add, L:sub)
        SINK_VALID          : in    std_logic;                          --(p) Data valid
        SINK_DATAA          : in    std_logic_vector(15 downto 0);      --(p) Data A
        SINK_DATAB          : in    std_logic_vector(15 downto 0);      --(p) Data B

        SOURCE_VALID        : out   std_logic;                          --(p) Data valid
        SOURCE_DATA         : out   std_logic_vector(15 downto 0)       --(p) Data
        );
end CALC;

architecture RTL of CALC is

-- Internal signal --
signal result_i         : std_logic_vector(SOURCE_DATA'length downto 0);
signal valid_i          : std_logic;

begin
-- ***********************************************************
--  Data type
-- ***********************************************************
-- fixe point Q16
--
-- 15   14-0
-- sign integer

-- ***********************************************************
--  Calculation
-- ***********************************************************
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        result_i <= (others => '0');
    elsif (CLK'event and CLK = '1') then
        if (SINK_VALID = '1') then
            if (MODE = '1') then
                result_i <= add_signed(SINK_DATAA, SINK_DATAB);
            else
                result_i <= sub_signed(SINK_DATAA, SINK_DATAB);
            end if;
        end if;
    end if;
end process;

SOURCE_DATA <= (result_i(result_i'left) & result_i(result_i'left-2 downto 0));


-- ***********************************************************
--  Valid assert
-- ***********************************************************
process (CLK, RESET_n) begin
    if (RESET_n = '0') then
        valid_i <= '0';
    elsif (CLK'event and CLK = '1') then
        valid_i <= SINK_VALID;
    end if;
end process;

SOURCE_VALID <= valid_i;


end RTL;    -- CALC
