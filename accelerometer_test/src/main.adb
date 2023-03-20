------------------------------------------------------------------------------
-- Template                                                                         --
------------------------------------------------------------------------------

with LSM303; use LSM303;

with MicroBit.Display;
with MicroBit.Accelerometer;
with MicroBit.Console;
with MicroBit.IOs;
with MicroBit.Time;
with MicroBit.Music;

with freefall_detection;

use MicroBit;
--use MicroBit.IOs;
use freefall_detection;
use MicroBit.Music;
use MicroBit.IOs;


procedure Main is

   Data : LSM303.All_Axes_Data;
   --Value : MicroBit.IOs.Analog_Value;
   sFactor_Sqrd : S_Factor_Sqrd_t;
   iFallCounter : Integer := 0;
   iFallCounterThresh : constant Integer := 3;
   bFreefallDetected : Boolean := False;   -- Becomes true when a freefall
                                           -- got detected
   tonePin : constant Pin_Id := 0;                  -- Pin for the speaker
   toneDuration : constant Time.Time_Ms := 200;    -- Duration of a tone
   nFreefallTone : constant Note := (P => A4,              -- Tone played on freefall
                            Ms => toneDuration);

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
      if sFactor_Sqrd <= 3000 then -- before 6000
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

      -- Displays a 'F' if freefall is detected and a 'O' if not
      if bFreefallDetected then
         Display.Display('F');
         Play(Pin => tonePin, N => nFreefallTone); -- Play tone when in freefall
      else
         Display.Display('O');
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
