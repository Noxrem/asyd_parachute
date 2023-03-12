------------------------------------------------------------------------------
-- Template                                                                         --
------------------------------------------------------------------------------

with LSM303; use LSM303;

with MicroBit.Display;
with MicroBit.Accelerometer;
with MicroBit.Console;
--with MicroBit.IOs;
with MicroBit.Time;

with freefall_detection;

use MicroBit;
--use MicroBit.IOs;
use freefall_detection;


procedure Main is

   Data : LSM303.All_Axes_Data;
   --Value : MicroBit.IOs.Analog_Value;
   sFactor_Sqrd : S_Factor_Sqrd_t;

begin

   Console.Put_Line ("Accelerator Test");

   loop

      --  Read the accelerometer data
      Data := Accelerometer.Data;

      --  Print the data on the serial port
      Console.Put_Line ("X:" & Data.X'Img & ASCII.HT &
                        "Y:" & Data.Y'Img & ASCII.HT &
                          "Z:" & Data.Z'Img);
      -- Print the S-Factor of the accelerator data (convert Float to String)
      sFactor_Sqrd := get_S_Factor_Sqrd(Data);
      Console.Put_Line ("S-Factor squared:" & sFactor_Sqrd'Img);

      --  Clear the LED matrix
      Display.Clear;

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
