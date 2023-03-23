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
   iFallCounter : Integer := 0;
   iFallCounterThresh : constant Integer := 2; -- 3 before
   bFreefallDetected : Boolean := False;   -- Becomes true when a freefall
                                           -- got detected
   --tonePin : constant Pin_Id := 0;                  -- Pin for the speaker
   --toneDuration : constant Time.Time_Ms := 200;    -- Duration of a tone
   --nFreefallTone : constant Note := (P => A4,              -- Tone played on freefall
   --                         Ms => toneDuration);
   bMotorRunning : Boolean := False; -- If the motor is running
   iMotorCounter : Integer := 0; -- Counter gets incremented as long the motor is running
   iMotorCounterLim : constant Integer := 8; -- Time duration which the motor runs (x50 ms)

   bButtonA : Boolean := False; -- Current button state
   bButtonAPrev : Boolean := False; -- Previous button state for debouncing
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

      if State(Button_A) = Pressed then -- Set the current state of the button
         bButtonA := True;
      else
         bButtonA := False;
      end if;

      if bButtonA and bButtonAPrev = False then -- Detect pos. edge, turn on/off motor
         bMotorRunning := not bMotorRunning;
      end if;

      bButtonAPrev := bButtonA; -- Set the previous button state to current

      -- Let the motor run for the bMotorCounterLim amount of time
      if bMotorRunning and iMotorCounter < iMotorCounterLim then
         iMotorCounter := iMotorCounter + 1; -- Increment the motor counter
         --  Turn on the GPIO P8, P9, P15, P16
         MicroBit.IOs.Set(8, True);
         MicroBit.IOs.Set(9, True);
         MicroBit.IOs.Set(15, True);
         MicroBit.IOs.Set(16, True);
         Display.Display('F'); -- Show 'F' on display
      else -- Turn off the motor
         bMotorRunning := False;
         iMotorCounter := 0; -- Reset counter
         MicroBit.IOs.Set(8, False);
         MicroBit.IOs.Set(9, False);
         MicroBit.IOs.Set(15, False);
         MicroBit.IOs.Set(16, False);
      end if;

      -- Displays a 'F' if freefall is detected and a 'O' if not
      if bFreefallDetected then
         bMotorRunning := True;
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
