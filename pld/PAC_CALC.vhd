-- =====================================================================
--  Title       : Signed add/sub function
--
--  File Name   : PAC_CALC.vhd
--  Project     : Package
--  Block       : 
--  Tree        : 
--  Designer    : toms74209200 <https://github.com/toms74209200>
--  Created     : 2017/03/03
--  Copyright   : 2017 toms74209200
--  License     : MIT License.
--                http://opensource.org/licenses/mit-license.php
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package PAC_CALC is
    function add_signed
        (
            a1      : std_logic_vector;
            b1      : std_logic_vector
        )   return    std_logic_vector;

    function sub_signed
        (
            a1      : std_logic_vector;
            b1      : std_logic_vector
        )   return    std_logic_vector;
end PAC_CALC;

package body PAC_CALC is

-- ***********************************************************
--  Signed add
-- ***********************************************************
function add_signed
    (
        a1      : std_logic_vector;
        b1      : std_logic_vector
    )
return std_logic_vector is
variable s : std_logic_vector((a1'length) downto 0);

-- Internal variables --
variable a : std_logic_vector(a1'range);
variable b : std_logic_vector(b1'range);

begin

a := a1;
b := b1;

-- a + b
    if (a(a'left) = '0' and b(b'left) = '0') then
        s := ('0' & a) + ('0' & b);
-- -a + (-b)
    elsif (a(a'left) = '1' and b(b'left) = '1') then
        s(s'left) := '1';
        s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) + ('0' & b(b'left-1 downto 0));
    else
        -- |a| > |b|
        if (a(a'left-1 downto 0) > b(b'left-1 downto 0)) then
            s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) - ('0' & b(b'left-1 downto 0));
            -- -a + b
            if (a(a'left) = '1' and b(b'left) = '0') then
                s(s'left) := '1';
            -- a + (-b)
            else
                s(s'left) := '0';
            end if;
        -- |a| < |b|
        else
            s(s'left-1 downto 0) := ('0' & b(b'left-1 downto 0)) - ('0' & a(a'left-1 downto 0));
            -- -a + b
            if (a(a'left) = '1' and b(b'left) = '0') then
                s(s'left) := '0';
            -- a + (-b)
            else
                s(s'left) := '1';
            end if;
        end if;
    end if;

return s;

end;    -- add_signed

-- ***********************************************************
--  Signed sub
-- ***********************************************************
function sub_signed
    (
        a1      : std_logic_vector;
        b1      : std_logic_vector
    )
return std_logic_vector is
variable s : std_logic_vector((a1'length) downto 0);

-- Internal variables --
variable a : std_logic_vector(a1'range);
variable b : std_logic_vector(b1'range);

begin 


a := a1;
b := b1;

-- a - b
    if (a(a'left) = '0' and b(b'left) = '0') then
        if (a(a'left-1 downto 0) > b(b'left-1 downto 0)) then
            s(s'left) := '0';
            s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) - ('0' & b(b'left-1 downto 0));
        else
            s(s'left) := '1';
            s(s'left-1 downto 0) := ('0' & b(b'left-1 downto 0)) - ('0' & a(a'left-1 downto 0));
        end if;
-- -a - (-b)
    elsif (a(a'left) = '1' and b(b'left) = '1') then
        if (a(a'left-1 downto 0) > b(b'left-1 downto 0)) then
            s(s'left) := '1';
            s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) - ('0' & b(b'left-1 downto 0));
        else
            s := ('0' & b) - ('0' & a);
        end if;
-- -a - b
    elsif (a(a'left) = '1' and b(b'left) = '0') then
        s(s'left) := '1';
        s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) + ('0' & b(b'left-1 downto 0));
-- a - (-b)
    elsif (a(a'left) = '0' and b(b'left) = '1') then   
        s(s'left) := '0';
        s(s'left-1 downto 0) := ('0' & a(a'left-1 downto 0)) + ('0' & b(b'left-1 downto 0));
    end if;

return s;

end;    -- sub_signed

end PAC_CALC;
