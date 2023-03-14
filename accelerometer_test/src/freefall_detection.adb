package body freefall_detection is

   function get_S_Factor_Sqrd (data : LSM303.All_Axes_Data) return S_Factor_Sqrd_t is
      S_factor : S_Factor_Sqrd_t;
   begin
      S_factor := S_Factor_Sqrd_t(S_Factor_Sqrd_t(abs data.X) ** 2 + S_Factor_Sqrd_t(abs data.Y) ** 2 + S_Factor_Sqrd_t(abs data.Z) ** 2);
      return S_factor;
   end get_S_Factor_Sqrd;

end freefall_detection;
