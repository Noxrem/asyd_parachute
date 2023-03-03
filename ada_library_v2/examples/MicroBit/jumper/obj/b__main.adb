pragma Warnings (Off);
pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__main.adb");
pragma Suppress (Overflow_Check);

package body ada_main is

   E04 : Short_Integer; pragma Import (Ada, E04, "lsm303_E");
   E86 : Short_Integer; pragma Import (Ada, E86, "memory_barriers_E");
   E84 : Short_Integer; pragma Import (Ada, E84, "cortex_m__nvic_E");
   E78 : Short_Integer; pragma Import (Ada, E78, "nrf__events_E");
   E31 : Short_Integer; pragma Import (Ada, E31, "nrf__gpio_E");
   E93 : Short_Integer; pragma Import (Ada, E93, "nrf__gpio__tasks_and_events_E");
   E80 : Short_Integer; pragma Import (Ada, E80, "nrf__interrupts_E");
   E37 : Short_Integer; pragma Import (Ada, E37, "nrf__rtc_E");
   E40 : Short_Integer; pragma Import (Ada, E40, "nrf__spi_master_E");
   E66 : Short_Integer; pragma Import (Ada, E66, "nrf__tasks_E");
   E91 : Short_Integer; pragma Import (Ada, E91, "nrf__adc_E");
   E64 : Short_Integer; pragma Import (Ada, E64, "nrf__clock_E");
   E95 : Short_Integer; pragma Import (Ada, E95, "nrf__ppi_E");
   E44 : Short_Integer; pragma Import (Ada, E44, "nrf__timers_E");
   E47 : Short_Integer; pragma Import (Ada, E47, "nrf__twi_E");
   E50 : Short_Integer; pragma Import (Ada, E50, "nrf__uart_E");
   E22 : Short_Integer; pragma Import (Ada, E22, "nrf__device_E");
   E58 : Short_Integer; pragma Import (Ada, E58, "microbit__console_E");
   E56 : Short_Integer; pragma Import (Ada, E56, "microbit__i2c_E");
   E54 : Short_Integer; pragma Import (Ada, E54, "microbit__accelerometer_E");
   E89 : Short_Integer; pragma Import (Ada, E89, "microbit__ios_E");
   E62 : Short_Integer; pragma Import (Ada, E62, "microbit__time_E");
   E60 : Short_Integer; pragma Import (Ada, E60, "microbit__display_E");

   Sec_Default_Sized_Stacks : array (1 .. 1) of aliased System.Secondary_Stack.SS_Stack (System.Parameters.Runtime_Default_Sec_Stack_Size);


   procedure adainit is
      Binder_Sec_Stacks_Count : Natural;
      pragma Import (Ada, Binder_Sec_Stacks_Count, "__gnat_binder_ss_count");

      Default_Secondary_Stack_Size : System.Parameters.Size_Type;
      pragma Import (C, Default_Secondary_Stack_Size, "__gnat_default_ss_size");
      Default_Sized_SS_Pool : System.Address;
      pragma Import (Ada, Default_Sized_SS_Pool, "__gnat_default_ss_pool");

   begin
      null;

      ada_main'Elab_Body;
      Default_Secondary_Stack_Size := System.Parameters.Runtime_Default_Sec_Stack_Size;
      Binder_Sec_Stacks_Count := 1;
      Default_Sized_SS_Pool := Sec_Default_Sized_Stacks'Address;


      E04 := E04 + 1;
      E86 := E86 + 1;
      Cortex_M.Nvic'Elab_Spec;
      E84 := E84 + 1;
      E78 := E78 + 1;
      E31 := E31 + 1;
      E93 := E93 + 1;
      Nrf.Interrupts'Elab_Body;
      E80 := E80 + 1;
      E37 := E37 + 1;
      E40 := E40 + 1;
      E66 := E66 + 1;
      E91 := E91 + 1;
      E64 := E64 + 1;
      E95 := E95 + 1;
      E44 := E44 + 1;
      E47 := E47 + 1;
      E50 := E50 + 1;
      Nrf.Device'Elab_Spec;
      Nrf.Device'Elab_Body;
      E22 := E22 + 1;
      Microbit.Console'Elab_Body;
      E58 := E58 + 1;
      E56 := E56 + 1;
      Microbit.Accelerometer'Elab_Body;
      E54 := E54 + 1;
      Microbit.Ios'Elab_Spec;
      Microbit.Ios'Elab_Body;
      E89 := E89 + 1;
      Microbit.Time'Elab_Body;
      E62 := E62 + 1;
      Microbit.Display'Elab_Body;
      E60 := E60 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_main");

   procedure main is
      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      adainit;
      Ada_Main_Program;
   end;

--  BEGIN Object file/option list
   --   C:\Users\Noxrem\Documents\GitHub\asyd_parachute\ada_library_v2\examples\MicroBit\jumper\obj\main.o
   --   -LC:\Users\Noxrem\Documents\GitHub\asyd_parachute\ada_library_v2\examples\MicroBit\jumper\obj\
   --   -LC:\Users\Noxrem\Documents\GitHub\asyd_parachute\ada_library_v2\examples\MicroBit\jumper\obj\
   --   -LC:\Users\Noxrem\Documents\GitHub\asyd_parachute\ada_library_v2\boards\MicroBit\obj\zfp_lib_Debug\
   --   -LC:\gnat\2020-arm-elf\arm-eabi\lib\gnat\zfp-cortex-m4f\adalib\
   --   -static
   --   -lgnat
--  END Object file/option list   

end ada_main;
