with MicroBit.IOs; use MicroBit.IOs;

package body motor is
   --bMotorLStrand : Boolean := False; -- Left MOSFET strand for the motor
   --bMotorRStrand : Boolean := False; -- Right MOSFET strand for the motor
   iMotorCounter : Integer := 0; -- Counter gets incremented as long the motor is running
   iMotorCounterLim : constant Integer := 6; -- Time duration which the motor runs (x50 ms)

   -- MOSFET pins
   pFetLT : constant Pin_Id := 8; -- MOSFET left top
   pFetRT : constant Pin_Id := 13; -- MOSFET right top
   pFetLB : constant Pin_Id := 15; -- MOSFET left bottom
   pFetRB : constant Pin_Id := 16; -- MOSFET right bottom


   procedure Run (bMotorLStrand : in out Boolean; bMotorRStrand : in out Boolean) is
   begin

      -- Let the motor run for the bMotorCounterLim amount of time
      if (bMotorLStrand or bMotorRStrand) -- If one motor strand is on
        and iMotorCounter < iMotorCounterLim then -- And counter is still running
         iMotorCounter := iMotorCounter + 1; -- Increment the motor counter

         if bMotorLStrand then
            -- Turn on the GPIO P8 and P15 (left strand)
            MicroBit.IOs.Set(pFetLT, True);
            MicroBit.IOs.Set(pFetLB, True);
            --Display_Left_Fault; -- Display left fault
         end if;

         if bMotorRStrand then
            --  Turn on the GPIO P9 and P16 (right strand)
            MicroBit.IOs.Set(pFetRT, True);
            MicroBit.IOs.Set(pFetRB, True);
            --Display_Right_Fault; -- Display right fault
         end if;
         --Display.Display('F'); -- Show 'F' on display
      else -- Turn off the motor
         bMotorLStrand := False;
         bMotorRStrand := False;
         iMotorCounter := 0; -- Reset counter
         -- Turn off all MOSFETS
         MicroBit.IOs.Set(pFetLT, False);
         MicroBit.IOs.Set(pFetRT, False);
         MicroBit.IOs.Set(pFetLB, False);
         MicroBit.IOs.Set(pFetRB, False);
      end if;
   end Run;



end motor;
