with LSM303; use LSM303;

package freefall_detection is

   -- max. value is 512² + 512² + 512² = 786_432
   type S_Factor_Sqrd_t is range 0 .. 786_432;
   
   function get_S_Factor_Sqrd (data : LSM303.All_Axes_Data) return S_Factor_Sqrd_t;
   
end freefall_detection;
