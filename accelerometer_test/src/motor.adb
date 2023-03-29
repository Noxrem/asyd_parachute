with MicroBit;
with fault_detection; use fault_detection;

package body motor is
   --bMotorLStrand : Boolean := False; -- Left MOSFET strand for the motor
   --bMotorRStrand : Boolean := False; -- Right MOSFET strand for the motor
   iMotorCounter : Integer := 0; -- Counter gets incremented as long the motor is running
   iMotorCounterLim : constant Integer := 6; -- Time duration which the motor runs (x50 ms)

   procedure Run (bMotorRStrand : in out Boolean; bMotorLStrand : in out Boolean) is
   begin

      -- Let the motor run for the bMotorCounterLim amount of time
      if (bMotorLStrand or bMotorRStrand) -- If one motor strand is on
        and iMotorCounter < iMotorCounterLim then -- And counter is still running
         iMotorCounter := iMotorCounter + 1; -- Increment the motor counter

         if bMotorLStrand then
            -- Turn on the GPIO P8 and P15 (left strand)
            MicroBit.IOs.Set(pFetLT, True);
            MicroBit.IOs.Set(pFetLB, True);
            Display_Left_Strand; -- Show that the left strand is active on the LED matrix
         end if;

         if bMotorRStrand then
            --  Turn on the GPIO P9 and P16 (right strand)
            MicroBit.IOs.Set(pFetRT, True);
            MicroBit.IOs.Set(pFetRB, True);
            Display_Right_Strand; -- Show that the right strand is active on the LED matrix
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
