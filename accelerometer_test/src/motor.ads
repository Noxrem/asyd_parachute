with MicroBit.IOs;
use MicroBit.IOs;
package motor is

      -- MOSFET pins
   pFetLT : constant Pin_Id := 8; -- MOSFET left top
   pFetRT : constant Pin_Id := 13; -- MOSFET right top
   pFetLB : constant Pin_Id := 15; -- MOSFET left bottom
   pFetRB : constant Pin_Id := 16; -- MOSFET right bottom
   
   -- Runs the respective strand for the motor
   -- bMotorLStrand: Left MOSFET strand for the motor
   -- bMotorRStrand: Right MOSFET strand for the motor
   procedure Run (bMotorRStrand : in out Boolean; bMotorLStrand : in out Boolean);

end motor;
