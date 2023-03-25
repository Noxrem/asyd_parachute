------------------------------------------------------------------------------
-- Template                                                                         --
------------------------------------------------------------------------------

with LSM303; use LSM303;

with MicroBit.Display;
with MicroBit.Accelerometer;
with MicroBit.Console;
with MicroBit.IOs;
with MicroBit.Time;
with MicroBit.Buttons;
--with MicroBit.Music;

with freefall_detection;

use MicroBit;
use MicroBit.Buttons;
--use MicroBit.IOs;
use freefall_detection;
--use MicroBit.Music;
--use MicroBit.IOs;


procedure Main is

   Data : LSM303.All_Axes_Data;
   --Value : MicroBit.IOs.Analog_Value;
   sFactor_Sqrd : S_Factor_Sqrd_t;
   sFactorFallThresh : constant S_Factor_Sqrd_t := 3000; -- Threshold under which a freefall is considered
   iFallCounter : Integer := 0;
   iFallCounterThresh : constant Integer := 3; -- 3 before
   bFreefallDetected : Boolean := False;   -- Becomes true when a freefall
                                           -- got detected
   --tonePin : constant Pin_Id := 0;                  -- Pin for the speaker
   --toneDuration : constant Time.Time_Ms := 200;    -- Duration of a tone
   --nFreefallTone : constant Note := (P => A4,              -- Tone played on freefall
   --                         Ms => toneDuration);
   bMotorLStrand : Boolean := False; -- Left MOSFET strand for the motor
   bMotorRStrand : Boolean := False; -- Right MOSFET strand for the motor
   iMotorCounter : Integer := 0; -- Counter gets incremented as long the motor is running
   iMotorCounterLim : constant Integer := 6; -- Time duration which the motor runs (x50 ms)

   bButtonA : Boolean := False; -- Current button state
   bButtonAPrev : Boolean := False; -- Previous button state for debouncing

   bButtonB : Boolean := False;
   bButtonBPrev : Boolean := False;
begin

   Console.Put_Line ("Accelerator Test");

   loop

      --  Read the accelerometer data
      Data := Accelerometer.Data;

      bFreefallDetected := False;   -- Initialize the freefall detection

      --  Print the data on the serial port
      --  Console.Put_Line ("X:" & Data.X'Img & ASCII.HT &
      --                    "Y:" & Data.Y'Img & ASCII.HT &
      --                      "Z:" & Data.Z'Img);
      -- Print the S-Factor of the accelerator data (convert Float to String)
      sFactor_Sqrd := get_S_Factor_Sqrd(Data);
      if sFactor_Sqrd <= sFactorFallThresh then
         if iFallCounter >= iFallCounterThresh then
            Console.Put_Line ("S-Factor squared:" & sFactor_Sqrd'Img);
            bFreefallDetected := True;
            iFallCounter := 0; -- Reset
         else
            iFallCounter := iFallCounter + 1; -- Increment counter
         end if;
      end if;
      --  Clear the LED matrix
      Display.Clear;

      if State(Button_A) = Pressed then -- Set the current state of the button
         bButtonA := True;
      else
         bButtonA := False;
      end if;

      if State(Button_B) = Pressed then
         bButtonB := True;
      else
         bButtonB := False;
      end if;

      if bButtonA and bButtonAPrev = False then -- Detect pos. edge, turn on/off left motor strand
         bMotorLStrand := not bMotorLStrand;
      end if;

      if bButtonB and bButtonBPrev = False then -- Detect pos. edge, turn on/off right motor strand
         bMotorRStrand := not bMotorRStrand;
      end if;

      -- Set the previous button state to current
      bButtonAPrev := bButtonA;
      bButtonBPrev := bButtonB;

      -- Let the motor run for the bMotorCounterLim amount of time
      if (bMotorLStrand or bMotorRStrand) -- If one motor strand is on
        and iMotorCounter < iMotorCounterLim then -- And counter is still running
         iMotorCounter := iMotorCounter + 1; -- Increment the motor counter

         if bMotorLStrand then
            -- Turn on the GPIO P8 and P15 (left strand)
            MicroBit.IOs.Set(8, True);
            MicroBit.IOs.Set(15, True);
         end if;

         if bMotorRStrand then
            --  Turn on the GPIO P9 and P16 (right strand)
            MicroBit.IOs.Set(13, True);
            MicroBit.IOs.Set(16, True);
         end if;
         Display.Display('F'); -- Show 'F' on display
      else -- Turn off the motor
         bMotorLStrand := False;
         bMotorRStrand := False;
         iMotorCounter := 0; -- Reset counter
         MicroBit.IOs.Set(8, False);
         MicroBit.IOs.Set(13, False);
         MicroBit.IOs.Set(15, False);
         MicroBit.IOs.Set(16, False);
      end if;

      -- Displays a 'F' if freefall is detected
      if bFreefallDetected then
         -- For now lets both strand run
         bMotorLStrand := True;
         bMotorRStrand := True;
      end if;
      --  -- Check, whether we are free floating or not (to be refined ...)
      --  if -100 < Data.X and Data.X < 100 then
      --     Display.Display ('0');
      --  else
      --     Display.Display ('X');
      --  end if;
      --
      --  -- Read analogue pin (could be 0,1,2,3,4, or 10)
      --  Value := MicroBit.IOs.Analog (2);
      --  Console.Put_Line ("Value : " & Value'Image);
      --
      --  -- Set output
      --  if Value > Analog_Value(200) then
      --     MicroBit.IOs.Set (12, True);
      --  else
      --     MicroBit.IOs.Set (12, False);
      --  end if;

      Time.Sleep (50);
   end loop;
end Main;
